package km.cd.backend.challenge.fixture;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.List;
import km.cd.backend.challenge.dto.response.ChallengeInformationResponse;

public class ChallengeResponseFixture {
    
    public static ChallengeInformationResponse challengeInformationResponse() {
        ChallengeInformationResponse response = new ChallengeInformationResponse();
        response.setId(1L); // 챌린지 ID는 일단 1로 가정합니다.
        response.setIsPrivate(true);
        response.setPrivateCode("내비밀코드");
        response.setChallengeName("나의 피트니스 챌린지");
        response.setChallengeExplanation("건강을 위해 이 피트니스 챌린지에 참여해 보세요!");
        response.setChallengePeriod(56); // 기간을 일단 정수형으로 가정합니다.
        response.setStartDate(parseDateString("2024-05-01"));
        response.setEndDate(parseDateString("2024-05-31"));
        response.setCertificationFrequency("매일");
        response.setCertificationStartTime(900); // 시간을 정수형으로 가정합니다.
        response.setCertificationEndTime(1800); // 시간을 정수형으로 가정합니다.
        response.setCertificationExplanation("운동 사진을 업로드하세요.");
        response.setIsGalleryPossible(true);
        response.setMaximumPeople(50);
        // 챌린지 이미지 경로 목록을 생성합니다. (테스트용으로 임의의 경로를 가정합니다.)
        List<String> imagePaths = new ArrayList<>();
        imagePaths.add("/images/image1.jpg");
        imagePaths.add("/images/image2.jpg");
        response.setChallengeImagePaths(imagePaths);
        response.setFailedVerificationImage("/images/인증실패이미지.jpg");
        response.setSuccessfulVerificationImage("/images/인증성공이미지.jpg");
        response.setIsEnded(false);
        response.setTotalParticipants(20); // 현재 참여자 수를 임의로 설정합니다.
        return response;
    }
    
    private static Date parseDateString(String dateString) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            return simpleDateFormat.parse(dateString);
        } catch (ParseException e) {
            return null;
        }
    }
}

