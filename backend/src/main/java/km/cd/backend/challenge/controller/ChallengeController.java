package km.cd.backend.challenge.controller;

import io.swagger.v3.oas.annotations.Parameter;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.dto.CertificationReceivedDto;
import km.cd.backend.challenge.dto.ChallengeReceivedDto;
import km.cd.backend.challenge.dto.ChallengeResponseDto;
import km.cd.backend.challenge.dto.ChallengeStatusResponseDto;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.user.User;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/challenges")
public class ChallengeController {

    @Autowired
    private final ChallengeService challengeService;

    public ChallengeController(ChallengeService challengeService) {
        this.challengeService = challengeService;
    }

    @PostMapping(path = "/create", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<ChallengeResponseDto> createChallenge(@ModelAttribute ChallengeReceivedDto challengeReceivedDTO,
        @Parameter(hidden = true) // 테스트 시 로그인 안하기 위함
        @AuthenticationPrincipal User user) {
        Challenge saved = challengeService.createChallenge(challengeReceivedDTO, user);
        ChallengeResponseDto challenge = ChallengeMapper.INSTANCE.challengeToChallengeResponse(saved);
        return ResponseEntity.ok(challenge);
    }

    @PostMapping("/{challenge_id}/join")
    public ResponseEntity<String> joinChallenge(@PathVariable Long challenge_id, @AuthenticationPrincipal User user) {
        challengeService.joinChallenge(challenge_id, user);
        return ResponseEntity.ok("Success");
    }
    
    @PostMapping("/certification")
    public ResponseEntity<String> certificateChallenge(@ModelAttribute CertificationReceivedDto certificationReceivedDto, @AuthenticationPrincipal User user) {
        String result = challengeService.certificateChallenge(certificationReceivedDto, user);
        return ResponseEntity.ok(result);
    }
    
    @GetMapping("/{challenge_id}")
    public ResponseEntity<ChallengeStatusResponseDto> checkChallengeStatus(@PathVariable Long challenge_id, @AuthenticationPrincipal User user) {
        ChallengeStatusResponseDto challengeStatusResponseDto = challengeService.checkChallengeStatus(challenge_id, user);
        return ResponseEntity.ok(challengeStatusResponseDto);
    }
}
