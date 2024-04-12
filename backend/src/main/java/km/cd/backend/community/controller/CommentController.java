package km.cd.backend.community.controller;

import km.cd.backend.common.jwt.PrincipalDetails;
import km.cd.backend.community.dto.CommentRequest;
import km.cd.backend.community.dto.CommentResponse;
import km.cd.backend.community.service.CommentService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/challenge/{challengeId}/posts/{postId}/comments")
@RequiredArgsConstructor
public class CommentController {

    private final CommentService commentService;

    @PostMapping("/")
    @ResponseStatus(HttpStatus.CREATED)
    public ResponseEntity<CommentResponse> createComment(
            @PathVariable(name = "postId") Long postId,
            @RequestParam(name = "parentId", required = false) Long parentId,
            @AuthenticationPrincipal PrincipalDetails principalDetails,
            @RequestBody CommentRequest commentRequest
    ) {
        CommentResponse commentResponse = commentService.createComment(principalDetails.getUserId(), postId, commentRequest, parentId);
        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(commentResponse);
    }

    @PutMapping("/{commentId}")
    public ResponseEntity<Void> updateComment(
            @PathVariable(name = "commentId") Long commentId,
            @AuthenticationPrincipal PrincipalDetails principalDetails,
            @RequestBody String content
    ) {
        commentService.updateComment(principalDetails.getUserId(), commentId, content);
        return ResponseEntity.ok(null);
    }

    @DeleteMapping("/{commentId}")
    public ResponseEntity<Void> deleteComment(
            @PathVariable(name = "commentId") Long commentId,
            @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        commentService.deleteComment(principalDetails.getUserId(), commentId);
        return ResponseEntity.ok(null);
    }
}
