package km.cd.backend.challenge.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;
import java.time.LocalDate;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ChallengeStatusResponse {
    
    @Schema(description = "챌린지 ID")
    private Long id;
    
    @Schema(description = "챌린지 이름")
    private String challengeName;
    
    @Schema(description = "챌린지 기간")
    private Integer challengePeriod;
    
    @Schema(description = "챌린지 시작일")
    private LocalDate startDate;
    
    @Schema(description = "챌린지 종료일")
    private LocalDate endDate;
    
    @Schema(description = "인증 시작 시간")
    private Integer certificationStartTime;
    
    @Schema(description = "인증 종료 시간")
    private Integer certificationEndTime;
    
    @Schema(description = "인증 빈도")
    private String certificationFrequency;
    
    @Schema(description = "전체 참여 인원")
    private int totalParticipants;
    
    @Schema(description = "내 인증 횟수")
    private int numberOfCertifications;
    
    @Schema(description = "전체 인증 횟수")
    private int totalCertificationCount;
    
    private Double currentAchievementRate;
    
    private Integer fullAchievementCount;
    
    private Integer highAchievementCount;
    
    private Integer lowAchievementCount;
    
    private Double overallAverageAchievementRate;
}