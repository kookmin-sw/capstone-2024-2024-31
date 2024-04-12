package km.cd.backend.challenge.dto;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import io.swagger.v3.oas.annotations.media.Schema;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.List;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.dto.enums.FilePathEnum;
import km.cd.backend.common.utils.S3Uploader;
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
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class ChallengeReceivedDto {

    @Schema(description = "비공개 챌린지 선택")
    private Boolean is_private;

    @Schema(description = "암호 설정")
    private String private_code;

    @Schema(description = "챌린지 이름")
    private String challenge_name;

    @Schema(description = "챌린지 소개")
    private String challenge_explanation;

    @Schema(description = "챌린지 소개 사진")
    private List<MultipartFile> challenge_image;
    
    @Schema(description = "챌린지 기간")
    private String challenge_period;

    @Schema(description = "챌린지 시작일")
    private String start_date;

    @Schema(description = "챌린지 인증 빈도")
    private String certification_frequency;

    @Schema(description = "챌린지 인증 가능 시작 시간")
    private String certification_start_time;

    @Schema(description = "챌린지 인증 가능 종료 시간")
    private String certification_end_time;

    @Schema(description = "인증 방법")
    private String certification_explanation;

    @Schema(description = "인증 수단")
    private Boolean is_gallery_possible;

    @Schema(description = "인증 성공 예시")
    private MultipartFile failed_verification_image;

    @Schema(description = "인증 실패 예시")
    private MultipartFile successful_verification_image;

    @Schema(description = "최대 모집 인원")
    private Integer maximum_people;


    public Challenge toEntity(S3Uploader s3Uploader) {
        Challenge challenge = new Challenge();
        challenge.setChallenge_name(challenge_name);
        challenge.setStart_date(
            parseDateString(start_date)
        );
        challenge.setEnd_date(
            calcylateEndDate(challenge.getStart_date(), challenge_period)
        );

        challenge.setCertification_frequency(certification_frequency);
        challenge.setCertification_explanation(certification_explanation);
        challenge.setCertification_start_time(
            convertNumber(certification_start_time)
        );
        challenge.setCertification_end_time(
            convertNumber(certification_end_time)
        );
        challenge.setChallenge_explanation(challenge_explanation);
        challenge.setMaximum_people(maximum_people);
        challenge.setIs_private(is_private);
        challenge.setPrivate_code(private_code);
        
        String filePath = FilePathEnum.CHALLENGES.getPath();

        List<String> imageUrls = new ArrayList<>();
        for (MultipartFile multipartFile : challenge_image) {
            if (multipartFile != null && !multipartFile.isEmpty()) {
                String imageUrl = s3Uploader.uploadFileToS3(multipartFile, filePath);
                imageUrls.add(imageUrl);
            }
        }
        challenge.setChallenge_image_path(imageUrls);

        if (failed_verification_image != null && !failed_verification_image.isEmpty()) {
            String failedVerificationImageUrl = s3Uploader.uploadFileToS3(failed_verification_image, filePath);
            challenge.setFailed_verification_image(failedVerificationImageUrl);
        }
        if (successful_verification_image != null && !successful_verification_image.isEmpty()) {
            String successfulVerificationImageUrl = s3Uploader.uploadFileToS3(successful_verification_image, filePath);
            challenge.setSuccessful_verification_image(successfulVerificationImageUrl);
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

    private Date calcylateEndDate(Date StartDate, String challenge_period) {
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
