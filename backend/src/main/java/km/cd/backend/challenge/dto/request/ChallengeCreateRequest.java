package km.cd.backend.challenge.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import km.cd.backend.challenge.domain.ChallengeCategory;
import lombok.AllArgsConstructor;
import lombok.Data;

import lombok.NoArgsConstructor;

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

    @Schema(description = "최대 모집 인원")
    private Integer maximumPeople;

}
