package km.cd.backend.challenge.dto;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.Participant;
import lombok.Data;

import java.util.Date;
import java.util.List;

@Data
public class ChallengeResponseDto {
    private Long challengeId;
    private String challengeName;
    private Date startDate;
    private Date endDate;
    private Integer certificationFrequency;
    private String certificationExplanation;
    private Integer certificationCount;
    private String certificationMethod;
    private String challengeExplanation;
    private Integer maximumPeople;
    private Boolean isPrivate;
    private String privateCode;
    private List<Participant> participants;

    public ChallengeResponseDto() {
    }

    public ChallengeResponseDto(Long challengeId, String challengeName, Date startDate, Date endDate, Integer certificationFrequency,
        String certificationExplanation, Integer certificationCount, String certificationMethod,
        String challengeExplanation, Integer maximumPeople, Boolean isPrivate, String privateCode, List<Participant> participants) {
        this.challengeId = challengeId;
        this.challengeName = challengeName;
        this.startDate = startDate;
        this.endDate = endDate;
        this.certificationFrequency = certificationFrequency;
        this.certificationExplanation = certificationExplanation;
        this.certificationCount = certificationCount;
        this.certificationMethod = certificationMethod;
        this.challengeExplanation = challengeExplanation;
        this.maximumPeople = maximumPeople;
        this.isPrivate = isPrivate;
        this.privateCode = privateCode;
        this.participants = participants;
    }

    public static ChallengeResponseDto toDto(Challenge challenge) {
        return new ChallengeResponseDto(
            challenge.getChallenge_id(),
            challenge.getChallenge_name(),
            challenge.getStart_date(),
            challenge.getEnd_date(),
            challenge.getCertification_frequency(),
            challenge.getCertification_explanation(),
            challenge.getCertification_count(),
            challenge.getCertification_method(),
            challenge.getChallenge_explanation(),
            challenge.getMaximum_people(),
            challenge.getIs_private(),
            challenge.getPrivate_code(),
            challenge.getParticipants()
        );
    }
}
