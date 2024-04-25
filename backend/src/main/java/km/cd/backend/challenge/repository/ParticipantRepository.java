package km.cd.backend.challenge.repository;

import java.util.Optional;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.user.User;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ParticipantRepository extends JpaRepository<Participant, Long> {
    
    Participant findByChallengeAndUser(Challenge challenge, User user);
}
