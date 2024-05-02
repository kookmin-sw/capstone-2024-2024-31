package km.cd.backend.challenge.fixture;

import java.io.IOException;
import java.io.InputStream;
import java.util.ArrayList;
import java.util.List;
import km.cd.backend.challenge.dto.request.ChallengeCreateRequest;
import org.springframework.mock.web.MockMultipartFile;
import org.springframework.web.multipart.MultipartFile;

public class ChallengeRequestFixture {
    
    public static ChallengeCreateRequest challengeCreateRequest() {
        ChallengeCreateRequest request = new ChallengeCreateRequest();
        request.setIsPrivate(true);
        request.setPrivateCode("내비밀코드");
        request.setChallengeName("나의 피트니스 챌린지");
        request.setChallengeExplanation("건강을 위해 이 피트니스 챌린지에 참여해 보세요!");
        List<MultipartFile> images = new ArrayList<>();
        images.add(createMockImageFile());
        images.add(createMockImageFile());
        request.setChallengeImages(images);
        request.setChallengePeriod("8주");
        request.setStartDate("2024-05-01");
        request.setCertificationFrequency("주5일");
        request.setCertificationStartTime("9시");
        request.setCertificationEndTime("18시");
        request.setCertificationExplanation("운동 사진을 업로드하세요.");
        request.setIsGalleryPossible(true);
        request.setFailedVerificationImage(createMockImageFile());
        request.setSuccessfulVerificationImage(createMockImageFile());
        request.setMaximumPeople(50);
        return request;
    }
    
    public static MultipartFile createMockImageFile() {
        try {
            // 테스트 리소스 폴더에 있는 이미지 파일을 사용하여 MockMultipartFile을 생성합니다.
            InputStream inputStream = ChallengeRequestFixture.class.getClassLoader().getResourceAsStream("resources/test_image.png");
            return new MockMultipartFile("images", "test_image.png", "image/png", inputStream);
        } catch (IOException e) {
            throw new RuntimeException("Failed to create MockMultipartFile", e);
        }
    }
    
}

