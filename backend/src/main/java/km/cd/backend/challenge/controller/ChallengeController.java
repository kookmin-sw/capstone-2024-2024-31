package km.cd.backend.challenge.controller;

import jakarta.validation.Valid;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.dto.ChallengeInformationResponse;
import km.cd.backend.challenge.dto.ChallengeInviteCodeResponse;
import km.cd.backend.challenge.dto.ChallengeCreateRequest;
import km.cd.backend.challenge.dto.ChallengeStatusResponse;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.common.jwt.PrincipalDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
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
    public ResponseEntity<ChallengeInformationResponse> createChallenge(
            @ModelAttribute ChallengeCreateRequest challengeCreateRequest,
            @AuthenticationPrincipal PrincipalDetails principalDetails) {
        Challenge saved = challengeService.createChallenge(principalDetails.getUserId(),
            challengeCreateRequest);
        ChallengeInformationResponse challenge = ChallengeMapper.INSTANCE.challengeToChallengeResponse(saved);
        return ResponseEntity.ok(challenge);
    }

    @GetMapping("/{challengeId}")
    public ResponseEntity<ChallengeInformationResponse> getChallenge(@PathVariable Long challengeId) {
        ChallengeInformationResponse challengeInformationResponse =  challengeService.getChallenge(challengeId);
        return ResponseEntity.ok(challengeInformationResponse);
    }

    @GetMapping("/{challengeId}/status")
    public ResponseEntity<ChallengeStatusResponse> checkChallengeStatus(
            @PathVariable(name = "challengeId") Long challengeId,
            @AuthenticationPrincipal PrincipalDetails principalDetails) {
        ChallengeStatusResponse challengeStatusResponse = challengeService.checkChallengeStatus(challengeId, principalDetails.getUserId());
        return ResponseEntity.ok(challengeStatusResponse);
    }

    @PostMapping("/{challengeId}/join")
    public ResponseEntity<String> joinChallenge(
            @PathVariable Long challengeId,
            @AuthenticationPrincipal PrincipalDetails principalDetails) {
        challengeService.joinChallenge(challengeId, principalDetails.getUserId());
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }

    @PostMapping("/{challengeId}/leave")
    public ResponseEntity<String> leaveChallenge(
            @AuthenticationPrincipal PrincipalDetails principalDetails,
            @PathVariable Long challengeId
    ) {
        challengeService.leaveChallenge(principalDetails.getUserId(), challengeId);
        return ResponseEntity.status(HttpStatus.OK).build();
    }
    
    @PostMapping("/{challengeId}/invite-code")
    public ResponseEntity<ChallengeInviteCodeResponse> generateChallengeInviteCode(
        @PathVariable final Long challengeId
    ) {
        final ChallengeInviteCodeResponse challengeInviteCodeResponse = challengeService.generateChallengeInviteCode(challengeId);
        return ResponseEntity.ok(challengeInviteCodeResponse);
    }
    
    @PostMapping("/{challengeId}/join")
    public ResponseEntity<String> joinChallenge(
        @PathVariable Long challengeId,
        @Valid @RequestBody final ChallengeInviteCodeRequest request) {
        challengeService.joinChallenge(challengeId, request);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }
}
