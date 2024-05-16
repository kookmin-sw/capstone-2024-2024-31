package km.cd.backend.challenge.dto.response;

import java.time.LocalDate;
import lombok.Data;

import java.util.List;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class ChallengeInformationResponse {
    private Long id;
    
    private Boolean isPrivate;
    
    private String privateCode;
    
    private String challengeName;
    
    private String challengeExplanation;
    
    private Integer challengePeriod;
    
    private LocalDate startDate;
    
    private LocalDate endDate;
    
    private String certificationFrequency;
    
    private Integer certificationStartTime;
    
    private Integer certificationEndTime;
    
    private String certificationExplanation;
    
    private Boolean isGalleryPossible;
    
    private Integer maximumPeople;
    
    private List<String> challengeImagePaths;
    
    private String failedVerificationImage;
    
    private String successfulVerificationImage;
    
    private String status;
    
    private Integer totalParticipants;
}

