package km.cd.backend.challenge.repository;

import java.util.Date;
import java.util.List;
import km.cd.backend.challenge.domain.Challenge;
import org.springframework.data.repository.CrudRepository;

public interface ChallengeRepository extends CrudRepository<Challenge, Long> {
    
    List<Challenge> findByEndDate(Date end_date);
}
