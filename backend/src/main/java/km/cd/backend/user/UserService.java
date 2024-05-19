package km.cd.backend.user;

import java.util.ArrayList;
import java.util.Set;
import java.util.stream.Collectors;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.ChallengeCategory;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.dto.enums.FilePathEnum;
import km.cd.backend.challenge.dto.response.ChallengeSimpleResponse;
import km.cd.backend.challenge.repository.ParticipantRepository;
import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.common.utils.s3.S3Uploader;
import km.cd.backend.user.domain.Friend;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.domain.mapper.FriendMapper;
import km.cd.backend.user.domain.mapper.UserMapper;
import km.cd.backend.user.dto.FriendListResponse;
import km.cd.backend.user.dto.GithubUsernameRequest;
import km.cd.backend.user.dto.UserCategoryRequest;
import km.cd.backend.user.dto.UserDetailResponse;
import km.cd.backend.user.dto.UserResponse;
import km.cd.backend.user.repository.FriendRepository;
import km.cd.backend.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import org.springframework.web.multipart.MultipartFile;

@Service
@Transactional
@RequiredArgsConstructor
public class UserService {

    private final UserRepository userRepository;
    private final FriendRepository friendRepository;
    private final ParticipantRepository participantRepository;
    private final S3Uploader s3Uploader;

    public User findByEmail(String email) {
        return userRepository.findByEmail(email).orElseThrow(() -> new CustomException(ExceptionCode.USER_NOT_FOUND));
    }

    public User findById(Long userId) {
        return userRepository.findById(userId).orElseThrow(() -> new CustomException(ExceptionCode.USER_NOT_FOUND));
    }
    
    public UserDetailResponse getMyInfo(Long userId) {
        User user = findById(userId);
        return UserMapper.INSTANCE.userToUserDetailResponse(user, getFollowingList(user.getEmail()), getFollwerList(user.getEmail()));
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
    
    public List<FriendListResponse> getFollowingList(String targetEmail) {
        User selectedUser = findByEmail(targetEmail);
        List<Friend> friendList = friendRepository.findByFromUser(selectedUser);
        
        ArrayList<FriendListResponse> resultList = new ArrayList<>();
        for (Friend friend : friendList) {
            String friendImage = findByEmail(friend.getMyEmail()).getAvatar();
            resultList.add(FriendMapper.INSTANCE.FRIEND_LIST_RESPONSE(friend, true, friendImage));
        }
        
        return resultList;
    }
    
    public List<FriendListResponse> getFollwerList(String targetEmail) {
        User selectedUser = findByEmail(targetEmail);
        List<Friend> friendList = friendRepository.findByToUser(selectedUser);
        
        ArrayList<FriendListResponse> resultList = new ArrayList<>();
        for (Friend friend : friendList) {
            String friendImage = findByEmail(friend.getMyEmail()).getAvatar();
            resultList.add(FriendMapper.INSTANCE.FRIEND_LIST_RESPONSE(friend, false, friendImage));
        }
        
        return resultList;
    }
    
    public void removeFollow(String targetEmail, Long userId) {
        User fromUser = findById(userId);
        User toUser = findByEmail(targetEmail);
        
        friendRepository.deleteFriendByFromUserAndToUser(fromUser, toUser);
    }
    

    public List<ChallengeSimpleResponse> getChallengesByUserId(Long userId) {
        List<Participant> participants = participantRepository.findAllByUserId(userId);

        return participants.stream().map(
                participant -> {
                    Challenge challenge = participant.getChallenge();
                    return ChallengeMapper.INSTANCE.entityToSimpleResponse(challenge);
                }
        ).toList();
    }
    
    public UserResponse uploadProfileImage(MultipartFile profileImage, Long userId) {
        User user = findById(userId);
        String profileImageUrl = s3Uploader.uploadFileToS3(profileImage, FilePathEnum.USER.getPath());
        user.setAvatar(profileImageUrl);
        userRepository.save(user);
        
        return UserMapper.INSTANCE.userToUserResponse(user);
    }
    
    public UserResponse updateProfileImage(MultipartFile profileImage, Long userId){
        User user = findById(userId);
        s3Uploader.deleteS3(user.getAvatar());
        
        String profileImageUrl = s3Uploader.uploadFileToS3(profileImage, FilePathEnum.USER.getPath());
        user.setAvatar(profileImageUrl);
        userRepository.save(user);
        
        return UserMapper.INSTANCE.userToUserResponse(user);
    }
    
    public UserResponse deleteProfileImage(Long userId) {
        User user = findById(userId);
        s3Uploader.deleteS3(user.getAvatar());
        user.setAvatar(null);
        userRepository.save(user);
        
        return UserMapper.INSTANCE.userToUserResponse(user);
    }
    
    public String getProfileImage(Long userId) {
        return findById(userId).getAvatar();
    }
    
    public UserResponse setCategories(UserCategoryRequest userCategoryRequest, Long userId) {
        User user = findById(userId);
        List<String> categories = userCategoryRequest.getCategories();
        
        List<ChallengeCategory> challengeCategories = categories.stream()
            .map(ChallengeCategory::fromString)
            .filter(category -> category != null)
            .collect(Collectors.toList());
        
        user.setCategories(challengeCategories);
        userRepository.save(user);
        
        return UserMapper.INSTANCE.userToUserResponse(user);
    }
    
    public void setGithubUsername(GithubUsernameRequest githubUsernameRequest, Long userId) {
        User user = findById(userId);
        user.setGithubUsername(githubUsernameRequest.username());
        userRepository.save(user);
    }
    
}
