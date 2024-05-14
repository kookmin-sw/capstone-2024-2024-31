package km.cd.backend.challenge.repository;

import java.util.List;
import java.util.Optional;

import km.cd.backend.challenge.domain.Participant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.stereotype.Repository;

@Repository
public interface ParticipantRepository extends JpaRepository<Participant, Long> {
    
    Optional<Participant> findByChallengeIdAndUserId(Long challengeId, Long userId);

    @Query("select p from Participant p left join Challenge c on p.challenge.id = c.id where p.user.id = :userId")
    List<Participant> findAllByUserId(Long userId);
}
