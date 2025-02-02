package km.cd.backend.community.controller;

import km.cd.backend.community.dto.PostResponse;
import km.cd.backend.community.dto.ReportResponse;
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
@RequestMapping("/posts")
@RequiredArgsConstructor
public class PostController {

  private final PostService postService;
  private final LikeService likeService;

  @PostMapping(path = "", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
  @ResponseStatus(HttpStatus.CREATED)
  public ResponseEntity<PostResponse> createPost(
      @RequestParam(name = "challengeId") Long challengeId,
      @RequestPart(name = "data") PostRequest postRequest,
      @RequestPart(name = "image") MultipartFile image,
      @AuthenticationPrincipal PrincipalDetails principalDetails) {
    PostResponse postResponse = postService.createPost(principalDetails.getUserId(), challengeId, postRequest, image);
    return ResponseEntity
            .status(HttpStatus.CREATED)
            .body(postResponse);
  }

  @GetMapping("")
  public ResponseEntity<List<PostResponse>> getAllPost(
          @RequestParam(name = "challengeId") Long challengeId
  ) {
    List<PostResponse> postResponses = postService.findAllByChallengeId(challengeId);
    return ResponseEntity.ok(postResponses);
  }

  @GetMapping("/users/{userId}")
  public ResponseEntity<List<PostResponse>> getAllPostByUserId(
          @RequestParam(name = "challengeId") Long challengeId,
          @PathVariable(name = "userId") Long userId
  ) {
    List<PostResponse> postResponses = postService.findAllByChallengeIdAndUserId(challengeId, userId);
    return ResponseEntity.ok(postResponses);
  }

  @GetMapping("/{postId}")
  public ResponseEntity<PostResponse> getPost(
          @PathVariable(name = "postId") Long postId
  ) {
    PostResponse postResponse = postService.findByPostId(postId);
    return ResponseEntity.ok(postResponse);
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
  
  @PostMapping("/{postId}/report")
  public ResponseEntity<ReportResponse> reportPost(
      @AuthenticationPrincipal PrincipalDetails principalDetails,
      @PathVariable(name = "postId") Long postId
  ) {
    return ResponseEntity.ok(postService.reportPost(principalDetails.getUserId(), postId));
  }
}