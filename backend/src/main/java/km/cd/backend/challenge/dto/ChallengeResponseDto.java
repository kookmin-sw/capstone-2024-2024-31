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
    private Long challenge_id;
    private String challenge_name;
    private Date start_date;
    private Date end_date;
    private String certification_frequency;
    private String certification_explanation;
    private Integer maximum_people;
    private Boolean is_private;
    private String private_code;
    private List<Participant> participants;
}

