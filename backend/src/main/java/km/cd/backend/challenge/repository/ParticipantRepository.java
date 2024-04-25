package km.cd.backend.challenge.repository;

import java.util.Optional;

import km.cd.backend.challenge.domain.Participant;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ParticipantRepository extends JpaRepository<Participant, Long> {
    
    Optional<Participant> findByChallengeIdAndUserId(Long challengeId, Long userId);
}
