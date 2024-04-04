package km.cd.backend.challenge.controller;

import km.cd.backend.challenge.dto.ChallengeReceivedDto;
import km.cd.backend.challenge.dto.ChallengeResponseDto;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.user.User;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
public class ChallengeController {

    @Autowired
    private ChallengeRepository challengeRepository;

    @Autowired
    private final ChallengeService challengeService;
    private final Logger log = LoggerFactory.getLogger(getClass());

    public ChallengeController(ChallengeService challengeService) {
        this.challengeService = challengeService;
    }

    @PostMapping("/challenge/create")
    public ChallengeResponseDto createChallenge(@ModelAttribute ChallengeReceivedDto challengeReceivedDTO, @AuthenticationPrincipal User user) {
        ChallengeResponseDto saved = challengeService.createChallenge(challengeReceivedDTO, user);
        return saved;
    }

    @PostMapping("/challenge/{challenge_id}/join")
    public String joinChallenge(@PathVariable int challenge_id, @AuthenticationPrincipal User user) {
        challengeService.joinChallenge(challenge_id, user);
        return "Success";
    }

}
