package km.cd.backend.challenge.certification.strategy;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.user.User;

public class GestureRecognitionCertificationStrategy implements CertificationStrategy {

    private static final GestureRecognitionCertificationStrategy INSTANCE = new GestureRecognitionCertificationStrategy();

    public static GestureRecognitionCertificationStrategy getInstance() {
        return INSTANCE;
    }

    private GestureRecognitionCertificationStrategy() {}

    @Override
    public boolean certify(Challenge challenge, User user) {
        return false;
    }
}
