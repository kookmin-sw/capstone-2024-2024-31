package km.cd.backend.user;

import java.util.List;
import km.cd.backend.common.jwt.PrincipalDetails;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.dto.UserResponse;
import km.cd.backend.user.dto.FriendListResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

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
    
    @PostMapping("/friend/{targetEmail}")
    public ResponseEntity<String> sendFriendRequest(
        @PathVariable String targetEmail,
        @AuthenticationPrincipal PrincipalDetails principalDetails
    ) {
        userService.createFriend(targetEmail, principalDetails.getUserId());
        return ResponseEntity.status(HttpStatus.CREATED).build();
    }
    
    @GetMapping("/friend/received")
    public ResponseEntity<List<FriendListResponse>> getWaitingFriendInfo(@AuthenticationPrincipal PrincipalDetails principalDetails) {
        return ResponseEntity.ok(userService.getWaitingFriendList(principalDetails.getUserId()));
    }
    
    @GetMapping("/friend")
    public ResponseEntity<List<FriendListResponse>> getFriendInfo(@AuthenticationPrincipal PrincipalDetails principalDetails) {
        return ResponseEntity.ok(userService.getFriendList(principalDetails.getUserId()));
    }
    
    @PostMapping("/friend/approve/{friendId}")
    public ResponseEntity<String> approveFriendRequest(@PathVariable Long friendId) {
        userService.approveFriendRequest(friendId);
        return ResponseEntity.status(HttpStatus.OK).build();
    }
    
    @DeleteMapping("/friend/reject/{friendId}")
    public ResponseEntity<String> rejectFriendRequest(@PathVariable Long friendId) {
        userService.rejectFriendRequest(friendId);
        return ResponseEntity.status(HttpStatus.ACCEPTED).build();
    }
    
    
}
