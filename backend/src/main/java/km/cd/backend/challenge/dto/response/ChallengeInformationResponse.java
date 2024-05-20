package km.cd.backend.challenge.dto.response;

import java.time.LocalDate;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonFormat;
import com.fasterxml.jackson.annotation.JsonValue;
import km.cd.backend.challenge.domain.ChallengeCategory;
import lombok.Data;

import java.util.List;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class ChallengeInformationResponse {
    private Long id;

    private String challengeName;

    private String challengeExplanation;

    private String challengeCategory;

    private int challengePeriod;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private LocalDate startDate;

    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
    private LocalDate endDate;

    private String certificationFrequency;

    private int certificationStartTime;

    private int certificationEndTime;

    private String certificationExplanation;

    private int maximumPeople;

    private List<String> challengeImagePaths;

    private String failedVerificationImage;

    private String successfulVerificationImage;

    private String status;

    private int totalParticipants;

    private boolean isPrivate;

    private boolean isGalleryPossible;
}

