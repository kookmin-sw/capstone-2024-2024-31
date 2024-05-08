package km.cd.backend.challenge.repository;

import java.util.Date;
import java.util.List;
import km.cd.backend.challenge.domain.Challenge;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;

public interface ChallengeRepository extends CrudRepository<Challenge, Long>, ChallengeCustomRepository {
    List<Challenge> findByEndDate(Date end_date);
    
    @Query("SELECT c FROM Challenge c WHERE c.challengeName = :challenge_name")
    Challenge findByChallengeName(String challenge_name);
}
