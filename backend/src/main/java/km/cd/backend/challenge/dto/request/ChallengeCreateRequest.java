package km.cd.backend.challenge.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.ChallengeCategory;
import km.cd.backend.challenge.dto.enums.FilePathEnum;
import km.cd.backend.common.utils.s3.S3Uploader;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChallengeCreateRequest {

    @Schema(description = "비공개 챌린지 선택")
    private Boolean isPrivate;

    @Schema(description = "암호 설정")
    private String privateCode;

    @Schema(description = "챌린지 이름")
    private String challengeName;

    @Schema(description = "챌린지 소개")
    private String challengeExplanation;

    @Schema(description = "챌린지 소개 사진")
    private List<MultipartFile> challengeImages;
    
    @Schema(description = "챌린지 기간")
    private String challengePeriod;

    @Schema(description = "챌린지 시작일")
    private String startDate;

    @Schema(description = "챌린지 인증 빈도")
    private String certificationFrequency;

    @Schema(description = "챌린지 인증 가능 시작 시간")
    private String certificationStartTime;

    @Schema(description = "챌린지 인증 가능 종료 시간")
    private String certificationEndTime;

    @Schema(description = "인증 방법")
    private String certificationExplanation;

    @Schema(description = "챌린지 카테고리")
    private ChallengeCategory challengeCategory;

    @Schema(description = "인증 수단")
    private Boolean isGalleryPossible;

    @Schema(description = "인증 성공 예시")
    private MultipartFile failedVerificationImage;

    @Schema(description = "인증 실패 예시")
    private MultipartFile successfulVerificationImage;


    @Schema(description = "최대 모집 인원")
    private Integer maximumPeople;


    public Challenge toEntity(S3Uploader s3Uploader) {
        Challenge challenge = new Challenge();
        challenge.setChallengeName(challengeName);
        challenge.setStartDate(
            parseDateString(startDate)
        );
        challenge.setChallengePeriod(
            convertNumber(challengePeriod)
        );
        challenge.setEndDate(
            calculateEndDate(challenge.getStartDate(), challengePeriod)
        );

        challenge.setCertificationFrequency(certificationFrequency);
        challenge.setCertificationExplanation(certificationExplanation);
        challenge.setCertificationStartTime(
            convertNumber(certificationStartTime)
        );
        challenge.setCertificationEndTime(
            convertNumber(certificationEndTime)
        );
        challenge.setIsGalleryPossible(isGalleryPossible);
        challenge.setChallengeExplanation(challengeExplanation);
        challenge.setMaximumPeople(maximumPeople);
        challenge.setIsPrivate(isPrivate);
        challenge.setPrivateCode(privateCode);
        
        String filePath = FilePathEnum.CHALLENGES.getPath();

        List<String> imageUrls = new ArrayList<>();
        for (MultipartFile multipartFile : challengeImages) {
            if (multipartFile != null && !multipartFile.isEmpty()) {
                String imageUrl = s3Uploader.uploadFileToS3(multipartFile, filePath);
                imageUrls.add(imageUrl);
            }
        }
        challenge.setChallengeImagePaths(imageUrls);

        if (failedVerificationImage != null && !failedVerificationImage.isEmpty()) {
            String failedVerificationImageUrl = s3Uploader.uploadFileToS3(failedVerificationImage, filePath);
            challenge.setFailedVerificationImage(failedVerificationImageUrl);
        }
        if (successfulVerificationImage != null && !successfulVerificationImage.isEmpty()) {
            String successfulVerificationImageUrl = s3Uploader.uploadFileToS3(successfulVerificationImage, filePath);
            challenge.setSuccessfulVerificationImage(successfulVerificationImageUrl);
        }

        return challenge;
    }

    private Date parseDateString(String dateString) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            return simpleDateFormat.parse(dateString);
        } catch (ParseException e) {
            return null;
        }
    }

    private Date calculateEndDate(Date StartDate, String challenge_period) {
        int weeks = convertNumber(challenge_period);

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(StartDate);
        calendar.add(Calendar.WEEK_OF_YEAR, weeks);

        return calendar.getTime();
    }

    private Integer convertNumber(String sentence) {
        return Integer.parseInt(sentence.replaceAll("\\D+", ""));
    }

}
