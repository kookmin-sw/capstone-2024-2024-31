package km.cd.backend.community.repository;

import km.cd.backend.community.domain.Post;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;

import java.util.List;
import java.util.Optional;

public interface PostRepository extends JpaRepository<Post, Long> {

  @Query("SELECT p FROM Post p LEFT JOIN FETCH p.comments WHERE p.id = :id ")
  Optional<Post> findByIdWithComment(Long id);

  @Query("SELECT p FROM Post p WHERE p.challenge.id = :challengeId")
  List<Post> findAllByChallengeId(Long challengeId);

}
