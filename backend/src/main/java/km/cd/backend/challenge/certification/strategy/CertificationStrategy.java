package km.cd.backend.challenge.certification.strategy;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.user.User;

public interface CertificationStrategy {
    boolean certify(Challenge challenge, User user);
}
