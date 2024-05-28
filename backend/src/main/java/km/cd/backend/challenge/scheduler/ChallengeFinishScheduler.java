package km.cd.backend.challenge.scheduler;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.repository.ChallengeRepository;
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
    private final ChallengeRepository challengeRepository;
    
    @Scheduled(cron = "0 0 0 * * ?") // 초, 분, 시 일, 월, 주(요일)
    public void checkChallengeEndDate() {
        List<Challenge> challengeToEnd = challengeRepository.findByStartDate(LocalDate.now());
        for (Challenge challenge : challengeToEnd) {
            challengeService.finishChallenge(challenge);
        }
    }
    
    @Scheduled(cron = "0 0 0 * * ?") // 초, 분, 시 일, 월, 주(요일)
    public void checkChallengeStartDate() {
        List<Challenge> challengeToEnd = challengeRepository.findByStartDate(LocalDate.now());
        for (Challenge challenge : challengeToEnd) {
            challengeService.startChallenge(challenge);
        }
    }
}
