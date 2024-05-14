package km.cd.backend.user.repository;

import km.cd.backend.user.domain.Friend;
import org.springframework.data.jpa.repository.JpaRepository;

public interface FriendRepository  extends JpaRepository<Friend, Long> {

}
