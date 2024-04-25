package km.cd.backend.community.repository;

import km.cd.backend.community.domain.Like;
import km.cd.backend.community.domain.Post;
import km.cd.backend.user.User;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface LikeRepository extends JpaRepository<Like, Long> {

    Optional<Like> findByUserAndPost(User user, Post post);
}
