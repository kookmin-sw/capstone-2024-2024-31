package km.cd.backend.community.controller;

import km.cd.backend.community.dto.PostSimpleResponse;
import km.cd.backend.community.dto.PostDetailResponse;
import km.cd.backend.community.service.LikeService;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.*;

import km.cd.backend.common.jwt.PrincipalDetails;
import km.cd.backend.community.dto.PostRequest;
import km.cd.backend.community.service.PostService;
import lombok.RequiredArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@RestController
@RequestMapping("/challenges/{challengeId}/posts")
@RequiredArgsConstructor
public class PostController {

  private final PostService postService;
  private final LikeService likeService;

  @PostMapping(path = "", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
  @ResponseStatus(HttpStatus.CREATED)
  public ResponseEntity<PostDetailResponse> createPost(
      @PathVariable(name = "challengeId") Long challengeId,
      @RequestPart(value = "data") PostRequest postRequest,
      @RequestPart(value = "image") MultipartFile image,
      @AuthenticationPrincipal PrincipalDetails principalDetails) {
    PostDetailResponse postResponse = postService.createPost(principalDetails.getUserId(), challengeId, postRequest, image);
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

  @GetMapping("/{postId}")
  public ResponseEntity<PostDetailResponse> getPost(
          @PathVariable(name = "postId") Long postId
  ) {
    PostDetailResponse postDetailResponse = postService.findByPostId(postId);
    return ResponseEntity.ok(postDetailResponse);
  }

  @DeleteMapping("/{postId}")
  public ResponseEntity<Void> deletePost(
          @PathVariable(name = "postId") Long postId,
          @AuthenticationPrincipal PrincipalDetails principalDetails) {
    postService.deletePost(principalDetails.getUserId(), postId);
    return ResponseEntity.ok(null);
  }

  @PostMapping("/{postId}/likes")
  public ResponseEntity<Void> likePost(
          @AuthenticationPrincipal PrincipalDetails principalDetails,
          @PathVariable(name = "postId") Long postId
  ) {
    likeService.likePost(principalDetails.getUserId(), postId);
    return ResponseEntity.ok(null);
  }

  @DeleteMapping("/{postId}/likes")
  public ResponseEntity<Void> unlikePost(
          @AuthenticationPrincipal PrincipalDetails principalDetails,
          @PathVariable(name = "postId") Long postId
  ) {
    likeService.unlikePost(principalDetails.getUserId(), postId);
    return ResponseEntity.ok(null);
  }

}