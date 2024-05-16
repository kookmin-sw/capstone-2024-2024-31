package km.cd.backend.challenge.dto.response;

import com.fasterxml.jackson.annotation.JsonFormat;
import io.swagger.v3.oas.annotations.media.Schema;

import java.time.LocalDate;

public record ChallengeSimpleResponse(
    
    @Schema(description = "챌린지 id")
        Long id,
    
    @Schema(description = "챌린지 이름")
        String challengeName,
    
    @Schema(description = "챌린지 시작일")
    @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd", timezone = "Asia/Seoul")
        LocalDate startDate,
    
    @Schema(description = "챌린지 기간")
        Integer challengePeriod,
    
    @Schema(description = "인증 빈도")
        String certificationFrequency,
    
    @Schema(description = "전체 참여 인원")
        int totalParticipants,
    
    @Schema(description = "챌린지 대표 이미지 url")
        String imageUrl,
    
    @Schema(description = "챌린지 종료 여부")
        String status,

    @Schema(description = "챌린지 비공개 여부")
        boolean isPrivate
) {
}
