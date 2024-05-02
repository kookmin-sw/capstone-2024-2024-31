package km.cd.backend.challenge.dto.response;

import com.fasterxml.jackson.databind.annotation.JsonSerialize;
import java.util.List;
import km.cd.backend.challenge.domain.Participant;
import lombok.Getter;
import lombok.RequiredArgsConstructor;
import lombok.Setter;


@Getter @Setter
@RequiredArgsConstructor
public class ParticipantResponse {
    private Long challengeId;
    private Long userId;
    private Long participantId;
    private boolean isOwner;
}
