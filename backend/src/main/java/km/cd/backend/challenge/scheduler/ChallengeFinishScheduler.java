package km.cd.backend.challenge.scheduler;

import java.util.Date;
import java.util.List;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.service.ChallengeService;
import lombok.RequiredArgsConstructor;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Component
@EnableScheduling
@RequiredArgsConstructor
public class ChallengeFinishScheduler {

    private final ChallengeService challengeService;
    
    @Scheduled(cron = "0 0 0 * * ?") // 초, 분, 시 일, 월, 주(요일)
    public void checkChallengeEndDate() {
        Date currentDate = new Date();
        List<Challenge> challengeToEnd = challengeService.findChallengesByEndDate(currentDate);
        for (Challenge challenge : challengeToEnd) {
            challengeService.finishChallenge(challenge);
        }
    }
}
