package km.cd.backend.challenge.dto.response;

import km.cd.backend.certification.domain.CertificationType;
import km.cd.backend.challenge.domain.Participant;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Date;
import java.util.List;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class ChallengeInformationResponse {
    private Long id;
    private String challengeName;
    private Date startDate;
    private Date endDate;
    private String certificationFrequency;
    private String certificationExplanation;
    private CertificationType certificationType;
    private Integer maximumPeople;
    private Boolean isPrivate;
    private String privateCode;
    private List<Participant> participants;
}

