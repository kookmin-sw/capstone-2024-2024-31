package km.cd.backend.challenge.controller;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.dto.ChallengeReceivedDto;
import km.cd.backend.challenge.dto.ChallengeResponseDto;
import km.cd.backend.challenge.dto.ChallengeStatusResponseDto;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.common.jwt.PrincipalDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/challenges")
@RequiredArgsConstructor
public class ChallengeController {

    private final ChallengeService challengeService;

    @PostMapping(path = "", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<ChallengeResponseDto> createChallenge(
            @ModelAttribute ChallengeReceivedDto challengeReceivedDTO,
            @AuthenticationPrincipal PrincipalDetails principalDetails) {
        Challenge saved = challengeService.createChallenge(principalDetails.getUserId(), challengeReceivedDTO);
        ChallengeResponseDto challenge = ChallengeMapper.INSTANCE.challengeToChallengeResponse(saved);
        return ResponseEntity.ok(challenge);
    }

    @GetMapping("/{challengeId}")
    public ResponseEntity<ChallengeStatusResponseDto> checkChallengeStatus(
            @PathVariable(name = "challengeId") Long challengeId,
            @AuthenticationPrincipal PrincipalDetails principalDetails) {
        ChallengeStatusResponseDto challengeStatusResponseDto = challengeService.checkChallengeStatus(challengeId, principalDetails.getUserId());
        return ResponseEntity.ok(challengeStatusResponseDto);
    }

    @PostMapping("/{challengeId}/join")
    public ResponseEntity<String> joinChallenge(
            @PathVariable Long challengeId,
            @AuthenticationPrincipal PrincipalDetails principalDetails) {
        challengeService.joinChallenge(challengeId, principalDetails.getUserId());
        return ResponseEntity.ok("Success");
    }

}
