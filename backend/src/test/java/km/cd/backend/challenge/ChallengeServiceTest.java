package km.cd.backend.challenge;

import java.util.Optional;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.dto.request.ChallengeInviteCodeRequest;
import km.cd.backend.challenge.dto.response.ChallengeStatusResponse;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.challenge.repository.ParticipantRepository;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.common.utils.redis.RedisUtil;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.transaction.annotation.Transactional;

import static org.assertj.core.api.Assertions.assertThat;
import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.assertj.core.api.Assertions.assertThatThrownBy;
import static org.junit.jupiter.api.Assertions.assertDoesNotThrow;
import static org.mockito.Mockito.*;

@SpringBootTest
@Transactional
class ChallengeServiceTest {
    
    @Autowired
    private ChallengeService challengeService;
    
    @MockBean
    private ChallengeRepository challengeRepository;
    
    @MockBean
    private ParticipantRepository participantRepository;
    @Mock
    private UserRepository userRepository;
    
    @Autowired
    protected RedisUtil redisUtil;
    
    private Challenge challenge;
    private User user;
    private Participant participant;
    private Long challengeId;
    private Long userId;
    
    @BeforeEach
    public void setUp() {
        user = userRepository.save(UserFixture.user());
        userId = user.getId();
        
        challenge = challengeRepository.save(ChallengeFixture.challenge());
        challengeId = challenge.getId();
        
        // Participant Entity 설정
        participant = new Participant();
        participant.setId(1L);
        participant.setChallenge(challenge);
        participant.setUser(user);
        participantRepository.save(participant);
    }
    
    @AfterEach
    void flushAll() {
        redisUtil.flushAll();
    }
    
    @Test
    @DisplayName("[성공] 초대코드는 생성된다.")
    public void generateTeamInviteCode_초대코드는_생성된다_성공() {
        //when
        var teamInviteLinkResponse = challengeService.generateChallengeInviteCode(challengeId);
        
        //then
        Optional<String> data = redisUtil.getData("teamId:%d".formatted(challengeId), String.class);
        assertThat(data).isNotEmpty();
        assertThat(data.get()).isEqualTo(teamInviteLinkResponse.code());
    }
    
    @Test
    @DisplayName("[성공] 이미 존재하는 초대코드가 있을 경우 초대코드를 반환한다.")
    public void generateTeamInviteCode_이미_존재하는_초대코드가_있을_경우_초대코드를_반환한다_성공() {
        //given
        var createdCode = challengeService.generateChallengeInviteCode(challengeId).code();
        
        //when
        var getCode = challengeService.generateChallengeInviteCode(challengeId).code();
        
        //then
        assertThat(createdCode).isEqualTo(getCode);
    }
    
    @Test
    @DisplayName("[성공] 초대코드와 유저코드가 일치하면 팀 가입은 성공한다.")
    public void joinTeam_초대코드와_유저코드가_일치하면_팀_가입은_성공한다_성공() {
        //given
        var createdCode = challengeService.generateChallengeInviteCode(challengeId).code();
        
        //when & then
        assertDoesNotThrow(() -> challengeService.joinChallengeByInviteCode(challengeId,
            user.getId(), new ChallengeInviteCodeRequest(createdCode)));
    }
    
    @Test
    @DisplayName("[실패] 초대코드와 유저코드가 일치하지 않으면 팀 가입은 실패한다.")
    public void joinTeam_초대코드와_유저코드가_일치하지_않으면_팀_가입은_실패() {
        //given
        challengeService.generateChallengeInviteCode(challengeId).code();
        
        //when & then
        assertThatThrownBy(() -> {
            challengeService.joinChallengeByInviteCode(challengeId,
                user.getId(), new ChallengeInviteCodeRequest("invalid code"));
        }).isInstanceOf(CustomException.class)
            .hasMessage(ExceptionCode.INVALID_INVITE_CODE.getMessage());
    }
    
    @Test
    @DisplayName("[성공] 챌린지와 인증 횟수가 주어지면 챌린지 진행 현황 조회는 성공한다.")
    void checkChallengeStatus_챌린지와_인증_횟수가_주어지면_챌린지_진행_현황_조회는_성공() {
        // 반환값 설정
        ChallengeStatusResponse expectedResponseDto = ChallengeMapper.INSTANCE.toChallengeStatusResponseDto(challenge, 0L);
        
        // Mock behavior
        when(challengeRepository.findById(challengeId)).thenReturn(Optional.of(challenge));
        when(participantRepository.findByChallengeIdAndUserId(challengeId, user.getId())).thenReturn(Optional.of(participant));
        
        // Call the method
        ChallengeStatusResponse responseEntity = challengeService.checkChallengeStatus(challengeId, user.getId());
        
        // Verify the result
        assertEquals(responseEntity.toString(), expectedResponseDto.toString());
    }

}
