package km.cd.backend.user;

import km.cd.backend.challenge.dto.response.ChallengeSimpleResponse;
import km.cd.backend.common.jwt.PrincipalDetails;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.domain.mapper.UserMapper;
import km.cd.backend.user.dto.UserCategoryRequest;
import km.cd.backend.user.dto.UserDetailResponse;
import km.cd.backend.user.dto.UserResponse;
import km.cd.backend.user.dto.FriendListResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;

@RestController
@RequestMapping("/users")
@RequiredArgsConstructor
public class UserController {

    private final UserService userService;

    @GetMapping("/me")
    public ResponseEntity<UserResponse> me(@AuthenticationPrincipal PrincipalDetails principalDetails) {
        Long userId = principalDetails.getUserId();
        User user = userService.findById(userId);
        UserResponse userResponse = UserMapper.INSTANCE.userToUserResponse(user);
        return ResponseEntity.ok(userResponse);
    }
    
    @PostMapping("/follow/{targetEmail}")
    public ResponseEntity<String> followFriend(
        @PathVariable String targetEmail,
        @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        userService.followFriend(targetEmail, principalDetails.getUserId());
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }
    
    @GetMapping("/{targetEmail}/following")
    public ResponseEntity<List<FriendListResponse>> getFollowingList(
        @PathVariable String targetEmail
    ) {
        return ResponseEntity.ok(userService.getFollowingList(targetEmail));
    }
    
    @GetMapping("/{targetEmail}/follower")
    public ResponseEntity<List<FriendListResponse>> getFollwerList(
        @PathVariable String targetEmail
    ) {
        return ResponseEntity.ok(userService.getFollwerList(targetEmail));
    }
    
    @DeleteMapping("/follow/{targetEmail}")
    public ResponseEntity<String> removeFollow(
        @PathVariable String targetEmail,
        @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        userService.removeFollow(targetEmail, principalDetails.getUserId());
        return ResponseEntity.status(HttpStatus.ACCEPTED).build();
    }
    
    @GetMapping("/me/challenges")
    public ResponseEntity<List<ChallengeSimpleResponse>> myChallenges(
            @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        Long userId = principalDetails.getUserId();
        List<ChallengeSimpleResponse> challengeSimpleResponses = userService.getChallengesByUserId(userId);
        return ResponseEntity.ok(challengeSimpleResponses);
    }
    
    @PostMapping(path = "/image", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<UserResponse> uploadProfileImage(
        @RequestPart(name = "profileImage") MultipartFile profileImage,
        @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        return ResponseEntity.ok(userService.uploadProfileImage(profileImage, principalDetails.getUserId()));
    }
    
    @PutMapping(path = "/image", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<UserResponse> updateProfileImage(
        @RequestPart(name = "profileImage") MultipartFile profileImage,
        @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        return ResponseEntity.ok(userService.updateProfileImage(profileImage, principalDetails.getUserId()));
    }
    
    @DeleteMapping("/image")
    public ResponseEntity<UserResponse> deleteProfileImage(
        @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        return ResponseEntity.ok(userService.deleteProfileImage(principalDetails.getUserId()));
    }
    
    @GetMapping("/image")
    public ResponseEntity<String> getProfileImage(
        @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        return ResponseEntity.ok(userService.getProfileImage(principalDetails.getUserId()));
    }
    
    @PostMapping("/category")
    public ResponseEntity<UserDetailResponse> setCategory(
        @RequestBody UserCategoryRequest userCategoryRequest,
        @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        return ResponseEntity.ok(userService.setCategories(userCategoryRequest, principalDetails.getUserId()));
    }
    
}
