package km.cd.backend.community.controller;

import km.cd.backend.community.dto.PostSimpleResponse;
import km.cd.backend.community.dto.PostDetailResponse;
import org.springframework.http.HttpStatus;
import org.springframework.web.bind.annotation.*;

import km.cd.backend.common.jwt.PrincipalDetails;
import km.cd.backend.community.dto.PostRequest;
import km.cd.backend.community.service.PostService;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;

import java.util.List;

@RestController
@RequestMapping("/challenge/{challengeId}/posts")
@RequiredArgsConstructor
public class PostController {

  private final PostService postService;

  @PostMapping("")
  @ResponseStatus(HttpStatus.CREATED)
  public ResponseEntity<PostDetailResponse> createPost(
      @PathVariable(name = "challengeId") Long challengeId,
      @RequestBody PostRequest postRequest,
      @AuthenticationPrincipal PrincipalDetails principalDetails) {
    PostDetailResponse postResponse = postService.createPost(principalDetails.getUserId(), challengeId, postRequest);
    return ResponseEntity
            .status(HttpStatus.CREATED)
            .body(postResponse);
  }

  @GetMapping("")
  public ResponseEntity<List<PostSimpleResponse>> getAllPost(
          @PathVariable(name = "challengeId") Long challengeId
  ) {
    List<PostSimpleResponse> postSimpleResponses = postService.findAllByChallengeId(challengeId);
    return ResponseEntity.ok(postSimpleResponses);
  }

  @GetMapping("{postId}")
  public ResponseEntity<PostDetailResponse> getPost(
          @PathVariable(name = "postId") Long postId
  ) {
    PostDetailResponse postDetailResponse = postService.findByPostId(postId);
    return ResponseEntity.ok(postDetailResponse);
  }

  @DeleteMapping("{postId}")
  public ResponseEntity<Void> deletePost(
          @PathVariable(name = "postId") Long postId,
          @AuthenticationPrincipal PrincipalDetails principalDetails) {
    postService.deletePost(principalDetails.getUserId(), postId);
    return ResponseEntity.ok(null);
  }

}