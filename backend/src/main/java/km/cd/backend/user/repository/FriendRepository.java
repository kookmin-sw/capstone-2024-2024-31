package km.cd.backend.user.repository;

import java.util.List;
import km.cd.backend.user.domain.Friend;
import km.cd.backend.user.domain.User;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FriendRepository  extends JpaRepository<Friend, Long> {
    List<Friend> findByFromUser(User from_user);
    List<Friend> findByToUser(User to_user);
    void deleteFriendByFromUserAndToUser(User fromUser, User toUser);
}
