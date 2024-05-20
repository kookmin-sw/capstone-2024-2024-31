package km.cd.backend.common.utils;


import java.time.LocalDate;
import java.util.Arrays;
import km.cd.backend.certification.domain.CertificationType;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.ChallengeCategory;
import km.cd.backend.challenge.dto.enums.ChallengeFrequency;
import km.cd.backend.challenge.dto.enums.ChallengeStatus;
import km.cd.backend.challenge.repository.ChallengeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.CommandLineRunner;
import org.springframework.stereotype.Component;

@Component
public class ChallengeDataSeeder implements CommandLineRunner {
    
    @Autowired
    private ChallengeRepository challengeRepository;
    
    @Override
    public void run(String... args) throws Exception {
        Challenge privateChallenge1 = Challenge.builder()
            .isPrivate(true)
            .privateCode("1234")
            .challengeName("혁규의 1일 1헬스")
            .challengeExplanation("헬스 is my life")
            .challengePeriod(3)
            .startDate(LocalDate.now())
            .endDate(LocalDate.now().plusDays(21))
            .certificationFrequency(ChallengeFrequency.EVERY_DAY.getFrequency())
            .certificationStartTime(1)
            .certificationEndTime(24)
            .certificationExplanation("손 인증으로 합니다 ~")
            .isGalleryPossible(false)
            .maximumPeople(25)
            .challengeImagePaths(Arrays.asList("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609"))
            .failedVerificationImage("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609")
            .successfulVerificationImage("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609")
            .status(ChallengeStatus.IN_PROGRESS.getDescription())
            .certificationType(CertificationType.HAND_GESTURE)
            .challengeCategory(ChallengeCategory.EXERCISE)
            .totalCertificationCount(21)
            .build();
        
        Challenge privateChallenge2 = Challenge.builder()
            .isPrivate(true)
            .privateCode("1234")
            .challengeName("석주의 커밋 도전기")
            .challengeExplanation("난 네이버 사장이 되겠어")
            .challengePeriod(5)
            .startDate(LocalDate.now())
            .endDate(LocalDate.now().plusDays(35))
            .certificationFrequency(ChallengeFrequency.EVERY_4TH_WEEK.getFrequency())
            .certificationStartTime(0)
            .certificationEndTime(24)
            .certificationExplanation("github 커밋 인증으로 합니다 ~")
            .isGalleryPossible(false)
            .maximumPeople(4)
            .challengeImagePaths(Arrays.asList("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609"))
            .failedVerificationImage("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609")
            .successfulVerificationImage("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609")
            .status(ChallengeStatus.IN_PROGRESS.getDescription())
            .certificationType(CertificationType.GITHUB_COMMIT)
            .challengeCategory(ChallengeCategory.STUDY)
            .totalCertificationCount(35)
            .build();
        
        // 공개 챌린지 2개 생성
        Challenge publicChallenge1 = Challenge.builder()
            .isPrivate(false)
            .challengeName("혜은이랑 같이 수영하실 분 ~ ㅋ")
            .challengeExplanation("혜은이는 수영 잘하지롱 ㅋ")
            .challengePeriod(2)
            .startDate(LocalDate.now())
            .endDate(LocalDate.now().plusDays(14))
            .certificationFrequency(ChallengeFrequency.EVERY_3RD_WEEK.getFrequency())
            .certificationStartTime(0)
            .certificationEndTime(24)
            .certificationExplanation("손 인증으로 합니다 ~")
            .isGalleryPossible(true)
            .maximumPeople(100)
            .challengeImagePaths(Arrays.asList("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609"))
            .failedVerificationImage("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609")
            .successfulVerificationImage("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609")
            .status(ChallengeStatus.IN_PROGRESS.getDescription())
            .certificationType(CertificationType.HAND_GESTURE)
            .challengeCategory(ChallengeCategory.EXERCISE)
            .totalCertificationCount(14)
            .build();
        
        Challenge publicChallenge2 = Challenge.builder()
            .isPrivate(false)
            .challengeName("채환이는 닭가슴살을 좋아해")
            .challengeExplanation("닭가슬살 패실 분 구함")
            .challengePeriod(6)
            .startDate(LocalDate.now())
            .endDate(LocalDate.now().plusDays(42))
            .certificationFrequency(ChallengeFrequency.EVERY_5TH_WEEK.getFrequency())
            .certificationStartTime(0)
            .certificationEndTime(24)
            .certificationExplanation("손 인증으로 합니다 ~")
            .isGalleryPossible(false)
            .maximumPeople(1000)
            .challengeImagePaths(Arrays.asList("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609"))
            .failedVerificationImage("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609")
            .successfulVerificationImage("https://routineup-s3.s3.ap-northeast-2.amazonaws.com/challenges/008e838c-256f-4803-a272-5a0c6977f609")
            .status(ChallengeStatus.IN_PROGRESS.getDescription())
            .certificationType(CertificationType.HAND_GESTURE)
            .challengeCategory(ChallengeCategory.EATING)
            .totalCertificationCount(42)
            .build();
        
        // 데이터 저장
        challengeRepository.save(privateChallenge1);
        challengeRepository.save(privateChallenge2);
        challengeRepository.save(publicChallenge1);
        challengeRepository.save(publicChallenge2);
        
        // 출력 확인
        System.out.println("Challenges initialized");
    }
}
