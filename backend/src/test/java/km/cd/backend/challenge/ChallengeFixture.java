package km.cd.backend.challenge;

import java.util.Arrays;
import java.util.Date;
import km.cd.backend.certification.domain.CertificationType;
import km.cd.backend.challenge.domain.Challenge;

public class ChallengeFixture {
    
    public static Challenge challenge() {
        return Challenge.builder()
            .id(123L)
            .isPrivate(false)
            .privateCode("ABC123")
            .challengeName("피트니스 챌린지")
            .challengeExplanation("저희 피트니스 챌린지에 참여하여 몸매를 만들어 보세요!")
            .challengePeriod(30)
            .startDate(new Date())
            .endDate(new Date(System.currentTimeMillis() + 30 * 24 * 60 * 60 * 1000)) // 현재로부터 30일 후
            .certificationFrequency("주5일")
            .certificationStartTime(8) // 오전 8시
            .certificationEndTime(20) // 오후 8시
            .certificationExplanation("참가자들은 매일 운동 사진을 업로드해야 합니다.")
            .isGalleryPossible(true)
            .maximumPeople(100)
            .challengeImagePaths(Arrays.asList("image1.jpg", "image2.jpg"))
            .failedVerificationImage("failed.jpg")
            .successfulVerificationImage("success.jpg")
            .certificationType(CertificationType.HAND_GESTURE) // PHOTO가 CertificationType 열거형 값이라고 가정합니다
            .build();
    }
    
}
