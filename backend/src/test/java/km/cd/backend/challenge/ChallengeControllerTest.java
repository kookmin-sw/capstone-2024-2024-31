package km.cd.backend.challenge;

import com.fasterxml.jackson.databind.ObjectMapper;
import km.cd.backend.challenge.controller.ChallengeController;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.dto.request.ChallengeCreateRequest;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.common.jwt.PrincipalDetails;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.mockito.InjectMocks;
import org.mockito.Mock;
import org.mockito.junit.jupiter.MockitoExtension;
import org.springframework.http.MediaType;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.test.web.servlet.MockMvc;
import org.springframework.test.web.servlet.setup.MockMvcBuilders;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.*;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;



@ExtendWith(MockitoExtension.class)
public class ChallengeControllerTest {

    @InjectMocks
    private ChallengeController challengeController;

    @Mock
    private ChallengeService challengeService;

    private MockMvc mockMvc;

    @Mock
    private UserRepository userRepository;

    @BeforeEach
    public void setUp() {
        mockMvc = MockMvcBuilders.standaloneSetup(challengeController).build();
    }

    @Test
    @DisplayName("챌린지 생성 테스트")
    public void testCreateChallenge() throws Exception {
        // given
        User user = new User(1L, "123@gmail.com", "ehyeok9");
        userRepository.save(user);
        PrincipalDetails principalDetails = new PrincipalDetails(user.getId(), user.getEmail(), user.getName(), user.getAuthorities());


        ChallengeCreateRequest challengeCreateRequest = new ChallengeCreateRequest();
        challengeCreateRequest.setChallengeName("Test");

        Challenge challenge = new Challenge();
        challenge.setId(1L);

        doReturn(challenge)
            .when(challengeService)
            .createChallenge(user.getId(), any(ChallengeCreateRequest.class));

        //when, then
        mockMvc.perform(post("/challenge/create")
                .with(SecurityMockMvcRequestPostProcessors.user(principalDetails))
                .contentType(MediaType.APPLICATION_JSON)
                .content(new ObjectMapper().writeValueAsString(challengeCreateRequest)))
            .andExpect(status().isOk())
            .andExpect(jsonPath("$.challengeId").exists());
    }

    @Test
    @DisplayName("챌린지 참여 테스트")
    public void testJoinChallenge() throws Exception {
        // given
        User user = new User(1L, "123@gmail.com", "ehyeok9");
        userRepository.save(user);
        PrincipalDetails principalDetails = new PrincipalDetails(user.getId(), user.getEmail(), user.getName(), user.getAuthorities());

        long challenge_id = 1L;
        // when, then
        mockMvc.perform(post("/challenge/" + challenge_id + "/join")
                .with(SecurityMockMvcRequestPostProcessors.user(principalDetails))
                .contentType(MediaType.APPLICATION_JSON))
            .andExpect(status().isOk())
            .andExpect(content().string("Success"));
    }
}
