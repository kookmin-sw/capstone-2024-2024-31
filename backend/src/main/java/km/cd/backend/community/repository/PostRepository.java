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

  /**
   * challengeId와 userId를 이용해서 현재까지 인증 성공한 Post의 개수를 가져옵니다.
   * 신고에 의해 reject된 post는 제외됩니다.
   * @param challengeId pk of challenge
   * @param userId pk of user
   * @return 인증 성공한 Post의 개수
   */
  @Query("SELECT COUNT(p) FROM Post p WHERE p.author.id = :userId AND p.challenge.id = :challengeId AND p.isRejected = false")
  Long countCertification(Long challengeId, Long userId);

  @Query("SELECT p FROM Post p WHERE p.challenge.id = :challengeId and p.author.id = :userId")
  List<Post> findAllByChallengeIdAndUserId(Long challengeId, Long userId);
}
