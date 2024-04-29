package km.cd.backend.challenge;

import java.util.Date;
import java.util.Optional;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.dto.ChallengeStatusResponseDto;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.challenge.repository.ParticipantRepository;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.common.utils.S3Uploader;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.mockito.Mock;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;

@SpringBootTest
class ChallengeServiceTest {
    
    @Autowired
    private ChallengeService challengeService;
    
    @MockBean
    private ChallengeRepository challengeRepository;
    
    @MockBean
    private ParticipantRepository participantRepository;
    @Mock
    private UserRepository userRepository;
    
    @Mock
    private S3Uploader s3Uploader;
    
    private MockMvc mockMvc;
    
    private Long challengeId;
    private User user;
    private Challenge challenge;
    private Participant participant;
    
    @BeforeEach
    public void setUp() {
        MockitoAnnotations.openMocks(this);
        
        // User 생성
        user = new User(1L, "123@gmail.com", "ehyeok9");
        userRepository.save(user);
        
        // Challenge Entity 설정
        challengeId = 2L;
        challenge = new Challenge();
        challenge.setId(challengeId);
        challenge.setChallengeName("Test Challenge");
        challenge.setChallengePeriod(4);
        challenge.setStartDate(new Date());
        challenge.setTotalParticipants(7);
        challenge.setCertificationFrequency("주5일");
        challengeRepository.save(challenge);
        
        // Participant Entity 설정
        participant = new Participant();
        participant.setId(1L);
        participant.setChallenge(challenge);
        participant.setUser(user);
        participantRepository.save(participant);
        
        mockMvc = MockMvcBuilders.standaloneSetup().build();
    }
    
    @Test
    @DisplayName("내 챌린지 정보 확인하기")
    void checkChallengeStatus_Success() {
        // 반환값 설정
        ChallengeStatusResponseDto expectedResponseDto = new ChallengeStatusResponseDto(); // Set expected response DTO if needed
        expectedResponseDto.setId(challengeId);
        expectedResponseDto.setChallengeName("Test Challenge");
        expectedResponseDto.setChallengePeriod(4);
        expectedResponseDto.setStartDate(new Date());
        expectedResponseDto.setCertificationFrequency("주5일");
        expectedResponseDto.setTotalParticipants(7);
        expectedResponseDto.setNumberOfCertifications(3);
        
        // 기간 * 주당 횟수
        expectedResponseDto.setTotalCertificationCount(20);
        
        // Mock behavior
        when(challengeRepository.findById(challengeId)).thenReturn(Optional.of(challenge));
        when(participantRepository.findByChallengeIdAndUserId(challengeId, user.getId())).thenReturn(Optional.of(participant));
        
        // Call the method
        ChallengeStatusResponseDto responseEntity = challengeService.checkChallengeStatus(challengeId, user.getId());
        
        // Verify the result
        assertEquals(responseEntity.toString(), expectedResponseDto.toString());
    }

}
