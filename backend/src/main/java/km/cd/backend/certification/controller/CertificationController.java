package km.cd.backend.certification.controller;

import km.cd.backend.certification.dto.GithubCommitResponse;
import km.cd.backend.certification.service.CertificationService;
import km.cd.backend.common.jwt.PrincipalDetails;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/certifications")
@RequiredArgsConstructor
public class CertificationController {

    private final CertificationService certificationService;

    @PostMapping(value = "/hand-gesture", consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<Void> certifyHandGesture(@RequestPart(name = "image") MultipartFile image) {
        certificationService.certifyHandGesture(image);
        return ResponseEntity.ok(null);
    }

    @PostMapping(value = "/github-commit")
    public ResponseEntity<GithubCommitResponse> certifyGitubCommit(
        @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        return ResponseEntity.ok(certificationService.certifyGitubCommit(principalDetails.getUserId()));
    }

}
