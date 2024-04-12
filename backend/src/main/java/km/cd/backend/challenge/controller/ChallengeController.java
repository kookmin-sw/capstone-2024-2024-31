package km.cd.backend.challenge.controller;

import io.swagger.v3.oas.annotations.Parameter;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.ChallengeMapper;
import km.cd.backend.challenge.dto.ChallengeReceivedDto;
import km.cd.backend.challenge.dto.ChallengeResponseDto;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.user.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ChallengeController {

    @Autowired
    private final ChallengeService challengeService;

    public ChallengeController(ChallengeService challengeService) {
        this.challengeService = challengeService;
    }

    @PostMapping(path = "/challenge/create", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<ChallengeResponseDto> createChallenge(@ModelAttribute ChallengeReceivedDto challengeReceivedDTO,
        @Parameter(hidden = true) // 테스트 시 로그인 안하기 위함
        @AuthenticationPrincipal User user) {
        Challenge saved = challengeService.createChallenge(challengeReceivedDTO, user);
        ChallengeResponseDto challenge = ChallengeMapper.INSTANCE.challengeToChallengeResponse(saved);
        return ResponseEntity.ok(challenge);
    }

    @PostMapping("/challenge/{challenge_id}/join")
    public String joinChallenge(@PathVariable Long challenge_id, @AuthenticationPrincipal User user) {
        challengeService.joinChallenge(challenge_id, user);

        return "Success";
    }

}
