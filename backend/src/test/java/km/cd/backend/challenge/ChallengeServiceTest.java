package km.cd.backend.challenge;

import java.util.Date;
import java.util.Optional;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.dto.CertificationReceivedDto;
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
import org.mockito.Mockito;
import org.mockito.MockitoAnnotations;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.boot.test.mock.mockito.MockBean;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.mockito.Mockito.*;
import static org.assertj.core.api.Assertions.*;

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
        challenge.setChallengeId(challengeId);
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
        participant.setNumberOfCertifications(3);
        participantRepository.save(participant);
        
        mockMvc = MockMvcBuilders.standaloneSetup().build();
    }
    
    @Test
    @DisplayName("내 챌린지 정보 확인하기")
    void checkChallengeStatus_Success() {
        // 반환값 설정
        ChallengeStatusResponseDto expectedResponseDto = new ChallengeStatusResponseDto(); // Set expected response DTO if needed
        expectedResponseDto.setChallengeId(challengeId);
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
        when(participantRepository.findByChallengeAndUser(challenge, user)).thenReturn(participant);
        
        ChallengeMapper challengeMapperMock = Mockito.mock(ChallengeMapper.class);
        when(challengeMapperMock.toChallengeStatusResponseDto(challenge, participant)).thenReturn(expectedResponseDto);
        
        
        // Call the method
        ChallengeStatusResponseDto responseEntity = challengeService.checkChallengeStatus(challengeId, user);
        
        // Verify the result
        assertEquals(responseEntity.toString(), expectedResponseDto.toString());
    }
    
    @Test
    @DisplayName("인증 성공 테스트")
    void testCertificateChallenge_Success() throws Exception {
        // 인증 받을 이미지 설정
        MockMultipartFile certificationImage = new MockMultipartFile("certificationImage", "test.jpg", "image/jpeg", "test image".getBytes());
        
        // CertificationReceivedDto 객체 설정
        CertificationReceivedDto certificationReceivedDto = new CertificationReceivedDto();
        certificationReceivedDto.setChallengeId(2L);
        certificationReceivedDto.setCertificationImage(certificationImage);
        
        // 예상 결과 설정
        String expectedMessage = "성공";
        
        // Mock behavior
        when(challengeRepository.findById(2L)).thenReturn(Optional.of(challenge));
        when(participantRepository.findByChallengeAndUser(challenge, user)).thenReturn(participant);
        
        // Call the method
        String actualMessage = challengeService.certificateChallenge(certificationReceivedDto, user);
        
        // Verify the result
        assertEquals(expectedMessage, actualMessage);
    }
    
}
