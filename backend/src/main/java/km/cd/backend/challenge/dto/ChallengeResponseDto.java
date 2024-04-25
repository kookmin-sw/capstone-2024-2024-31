package km.cd.backend.challenge.dto;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.Participant;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;
import java.util.List;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChallengeResponseDto {
    private Long challengeId;
    private String challengeName;
    private Date startDate;
    private Date endDate;
    private String certificationFrequency;
    private String certificationExplanation;
    private Integer maximumPeople;
    private Boolean isPrivate;
    private String privateCode;
    private List<Participant> participants;
}

