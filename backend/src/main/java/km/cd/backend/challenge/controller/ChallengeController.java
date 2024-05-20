package km.cd.backend.challenge.controller;

import jakarta.validation.Valid;
import java.util.List;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.dto.request.ChallengeJoinRequest;
import km.cd.backend.challenge.dto.response.ChallengeInformationResponse;
import km.cd.backend.challenge.dto.request.ChallengeInviteCodeRequest;
import km.cd.backend.challenge.dto.response.ChallengeInviteCodeResponse;
import km.cd.backend.challenge.dto.response.ChallengeSimpleResponse;
import km.cd.backend.challenge.dto.request.ChallengeCreateRequest;
import km.cd.backend.challenge.dto.request.ChallengeFilter;
import km.cd.backend.challenge.dto.response.ChallengeStatusResponse;
import km.cd.backend.challenge.dto.response.ParticipantResponse;
import km.cd.backend.challenge.service.ChallengeService;
import km.cd.backend.common.jwt.PrincipalDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;


@RestController
@RequestMapping("/challenges")
@RequiredArgsConstructor
public class ChallengeController {

    private final ChallengeService challengeService;

    @PostMapping(path = "/create", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<ChallengeSimpleResponse> createChallenge(
            @RequestPart(name = "json") ChallengeCreateRequest challengeCreateRequest,
            @RequestPart(name = "images") List<MultipartFile> images,
            @RequestPart(name = "successImage") MultipartFile successfulVerificationImage,
            @RequestPart(name = "failedImage") MultipartFile failedVerificationImage,
            @AuthenticationPrincipal PrincipalDetails principalDetails) {
        Challenge saved = challengeService.createChallenge(
            principalDetails.getUserId(),
            challengeCreateRequest,
            images,
            successfulVerificationImage,
            failedVerificationImage);
        ChallengeSimpleResponse challengeSimpleResponse = ChallengeMapper.INSTANCE.entityToSimpleResponse(saved);
        return ResponseEntity.ok(challengeSimpleResponse);
    }

    @GetMapping("/list")
    public ResponseEntity<List<ChallengeSimpleResponse>> getAllChallenge(
        @RequestParam(name = "cursorId", required = false, defaultValue = "0") Long cursorId,
        @RequestParam(name = "size", required = false, defaultValue = "5") int size,
        @RequestBody ChallengeFilter filter
    ) {
        List<ChallengeSimpleResponse> challenges = challengeService.getAllChallenge(cursorId, size, filter);
        return ResponseEntity.ok(challenges);
    }


    @GetMapping("/{challengeId}")
    public ResponseEntity<ChallengeInformationResponse> getChallenge(
            @AuthenticationPrincipal PrincipalDetails principalDetails,
            @PathVariable Long challengeId,
            @RequestParam(name = "code", required = false, defaultValue = "") String code
    ) {
        ChallengeInformationResponse challengeInformationResponse =  challengeService.getChallenge(challengeId, principalDetails.getUserId(), code);
        return ResponseEntity.ok(challengeInformationResponse);
    }

    @GetMapping(value = "/{challengeId}/participant")
    public ResponseEntity<List<ParticipantResponse>> getParticipant(@PathVariable Long challengeId) {
        List<ParticipantResponse> participants =  challengeService.getParticipant(challengeId);
        return ResponseEntity.ok(participants);
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
            @PathVariable(name = "challengeId") Long challengeId,
            @AuthenticationPrincipal PrincipalDetails principalDetails,
            @RequestBody ChallengeJoinRequest challengeJoinRequest) {
        challengeService.joinChallenge(challengeId, principalDetails.getUserId(), challengeJoinRequest);
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
    
    @PostMapping("/{challengeId}/inviteCode")
    public ResponseEntity<ChallengeInviteCodeResponse> generateChallengeInviteCode(
        @PathVariable final Long challengeId
    ) {
        final ChallengeInviteCodeResponse challengeInviteCodeResponse = challengeService.generateChallengeInviteCode(challengeId);
        return ResponseEntity.ok(challengeInviteCodeResponse);
    }
    
    @PostMapping("/{challengeId}/joinByInviteCode")
    public ResponseEntity<String> joinChallengeByInviteCode(
        @PathVariable Long challengeId,
        @AuthenticationPrincipal PrincipalDetails principalDetails,
        @Valid @RequestBody final ChallengeInviteCodeRequest request)
    {
        challengeService.joinChallengeByInviteCode(challengeId, principalDetails.getUserId(), request);
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }
}
