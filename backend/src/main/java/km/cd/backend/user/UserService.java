package km.cd.backend.user;

import java.util.List;
import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.user.domain.Friend;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.domain.mapper.FriendMapper;
import km.cd.backend.user.dto.FriendListResponse;
import km.cd.backend.user.repository.FriendRepository;
import km.cd.backend.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final FriendRepository friendRepository;

    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElseThrow(() -> new CustomException(ExceptionCode.USER_NOT_FOUND));
    }

    public User findById(Long userId) {
        return userRepository.findById(userId).orElseThrow(() -> new CustomException(ExceptionCode.USER_NOT_FOUND));
    }
    
    public void followFriend(String targetEmail, Long userId) {
        User fromUser = findById(userId);
        User toUser = findByEmail(targetEmail);
        
        if (fromUser.equals(toUser)) throw new CustomException(ExceptionCode.CANNOT_FOLLOW_YOURSELF);
        
        Friend follow = Friend.builder()
            .toUser(toUser).fromUser(fromUser)
            .friendEmail(toUser.getEmail())
            .myEmail(fromUser.getEmail())
            .friendName(toUser.getName())
            .build();
        
        friendRepository.save(follow);
    }
    
    public List<FriendListResponse> getFollowingList(String targetEmail, Long userId) {
        User selectedUser = findByEmail(targetEmail);
        User requestUser = findById(userId);
        
        List<Friend> friendList = friendRepository.findByFromUser(selectedUser);
        return FriendMapper.INSTANCE.FRIEND_LIST_RESPONSE_LIST(friendList, true);
    }
    
    public List<FriendListResponse> getFollwerList(String targetEmail, Long userId) {
        User selectedUser = findByEmail(targetEmail);
        User requestUser = findById(userId);
        
        List<Friend> friendList = friendRepository.findByToUser(selectedUser);
        return FriendMapper.INSTANCE.FRIEND_LIST_RESPONSE_LIST(friendList, false);
    }
    
    public void removeFollow(String targetEmail, Long userId) {
        User fromUser = findById(userId);
        User toUser = findByEmail(targetEmail);
        
        friendRepository.deleteFriendByFromUserAndToUser(fromUser, toUser);
    }
    
}
