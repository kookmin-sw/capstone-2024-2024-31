package km.cd.backend.challenge.controller;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.ChallengeMapper;
import km.cd.backend.challenge.dto.ChallengeReceivedDto;
import km.cd.backend.challenge.dto.ChallengeResponseDto;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.user.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
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
    private final Logger log = LoggerFactory.getLogger(getClass());

    public ChallengeController(ChallengeService challengeService) {
        this.challengeService = challengeService;
    }

    @PostMapping("/challenge/create")
    public ResponseEntity<ChallengeResponseDto> createChallenge(@ModelAttribute ChallengeReceivedDto challengeReceivedDTO, @AuthenticationPrincipal User user) {
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
