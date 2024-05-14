package km.cd.backend.user;

import java.util.ArrayList;
import java.util.List;
import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.user.domain.Friend;
import km.cd.backend.user.domain.FriendStatus;
import km.cd.backend.user.domain.User;
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
    
    public void createFriend(String targetEmail, Long userId) {
        User fromUser = findById(userId);
        User toUser = findByEmail(targetEmail);
        
        // 친구 요청을 받는 사람측에 저장될 값
        Friend receivedFriendRequests = Friend.builder()
            .users(fromUser).userEmail(fromUser.getEmail())
            .friendEmail(targetEmail)
            .status(FriendStatus.WAITING)
            .isFrom(true) // 받는 요청을 의미
            .build();
        
        // 친구 요청을 보내는 사람측에 저장될 값
        Friend sentFriendRequests = Friend.builder()
            .users(toUser).userEmail(targetEmail)
            .friendEmail(fromUser.getEmail())
            .status(FriendStatus.WAITING)
            .isFrom(false)
            .build();
        
        fromUser.getFriends().add(sentFriendRequests);
        toUser.getFriends().add(receivedFriendRequests);
        
        friendRepository.save(sentFriendRequests);
        friendRepository.save(receivedFriendRequests);
        
        // 매칭되는 친구 요청의 아이디 저장
        sentFriendRequests.setCounterpartId(fromUser.getId());
        receivedFriendRequests.setCounterpartId(toUser.getId());
    }
    
    public List<FriendListResponse> getWaitingFriendList(Long userId) {
        User user = findById(userId);
        List<Friend> friendList = user.getFriends();
        
        List<FriendListResponse> responseList = new ArrayList<>();
        for (Friend friend : friendList) {
            // 받은 요청이고 수락 대기 중인 요청만 조회
            if (!friend.isFrom() && friend.getStatus() == FriendStatus.WAITING) {
                User sentUser = findByEmail(friend.getFriendEmail());
                FriendListResponse dto = FriendListResponse.builder()
                    .friendShipId(friend.getId())
                    .friendEmail(sentUser.getEmail())
                    .friendName(sentUser.getName())
                    .status(friend.getStatus())
                    .build();
                responseList.add(dto);
            }
        }
        
        return responseList;
    }
    
    public List<FriendListResponse> getFriendList(Long userId) {
        User user = findById(userId);
        List<Friend> friendList = user.getFriends();
        
        List<FriendListResponse> responseList = new ArrayList<>();
        for (Friend friend : friendList) {
            if (friend.getStatus() == FriendStatus.ACCEPT) {
                User counterUser = friend.isFrom() ? findByEmail(friend.getUserEmail()) : findByEmail(friend.getFriendEmail());
                FriendListResponse dto = FriendListResponse.builder()
                    .friendShipId(friend.getId())
                    .friendEmail(counterUser.getEmail())
                    .friendName(counterUser.getName())
                    .status(friend.getStatus())
                    .build();
                responseList.add(dto);
            }
        }
        
        return responseList;
    }
    
    public void approveFriendRequest(Long friendId) {
        Friend friend = friendRepository.findById(friendId).orElseThrow(() -> new CustomException(ExceptionCode.FRIEND_REQUEST_NOT_FOUND));
        Friend counterFriend = friendRepository.findById(friend.getCounterpartId()).orElseThrow(() -> new CustomException(ExceptionCode.FRIEND_REQUEST_NOT_FOUND));
        
        friend.acceptFriendRequest();
        counterFriend.acceptFriendRequest();
    }
    
    public void rejectFriendRequest(Long friendId) {
        Friend friend = friendRepository.findById(friendId).orElseThrow(() -> new CustomException(ExceptionCode.FRIEND_REQUEST_NOT_FOUND));
        Friend counterFriend = friendRepository.findById(friend.getCounterpartId()).orElseThrow(() -> new CustomException(ExceptionCode.FRIEND_REQUEST_NOT_FOUND));
        
        friendRepository.delete(friend);
        friendRepository.delete(counterFriend);
    }
    
}
