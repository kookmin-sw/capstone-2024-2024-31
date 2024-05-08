package km.cd.backend.challenge.dto.response;

import io.swagger.v3.oas.annotations.media.Schema;

import java.util.Date;

public record ChallengeSimpleResponse(

        @Schema(description = "챌린지 id")
        Long id,

        @Schema(description = "챌린지 이름")
        String challengeName,

        @Schema(description = "챌린지 시작일")
        Date startDate,

        @Schema(description = "챌린지 기간")
        Integer challengePeriod,

        @Schema(description = "인증 빈도")
        String certificationFrequency,

        @Schema(description = "전체 참여 인원")
        int totalParticipants

) { }
