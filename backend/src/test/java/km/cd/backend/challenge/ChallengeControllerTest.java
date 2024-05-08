package km.cd.backend.challenge;

import com.fasterxml.jackson.databind.ObjectMapper;
import km.cd.backend.challenge.controller.ChallengeController;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.ChallengeCategory;
import km.cd.backend.challenge.dto.request.ChallengeCreateRequest;
import km.cd.backend.challenge.dto.request.ChallengeFilter;
import km.cd.backend.challenge.fixture.ChallengeFixture;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.common.jwt.PrincipalDetails;
import km.cd.backend.helper.IntegrationTest;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.security.test.context.support.WithMockUser;
import org.springframework.security.test.web.servlet.request.SecurityMockMvcRequestPostProcessors;
import org.springframework.test.web.servlet.ResultActions;

import static org.mockito.ArgumentMatchers.any;
import static org.mockito.Mockito.doReturn;
import static org.springframework.test.web.servlet.request.MockMvcRequestBuilders.*;
import static org.springframework.test.web.servlet.result.MockMvcResultMatchers.*;


public class ChallengeControllerTest extends IntegrationTest {

    @Autowired
    private ChallengeController challengeController;

    @Autowired
    private ChallengeService challengeService;
    
    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ChallengeRepository challengeRepository;
    
    @Test
    @DisplayName("[성공] 챌린지를 생성한 후 올바른 response 값을 반환한다.")
    public void ceateChallenge_챌린지를_생성한_후_올바른_response_값을_반환한다() throws Exception {
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

    @Test
    @DisplayName("챌린지 필터링 및 페이징 테스트")
    @WithMockUser
    public void get_challenge_with_filtering_and_paging() throws Exception {
        // given
        Challenge challenge = ChallengeFixture.challengeWithCategory(ChallengeCategory.HOBBY);
        challenge = challengeRepository.save(challenge);

        ChallengeFilter filter
                = new ChallengeFilter("", false, ChallengeCategory.HOBBY);

        // when
        ResultActions resultActions = mockMvc.perform(
                get("/challenges/list")
                        .contentType(MediaType.APPLICATION_JSON)
                        .content(objectMapper.writeValueAsString(filter))
        );

        // then
        resultActions
                .andExpect(status().isOk())
                .andExpect(jsonPath("$.size()").value(1))
                .andExpect(jsonPath("$.[0].challengeName").value(challenge.getChallengeName()));
    }

}
