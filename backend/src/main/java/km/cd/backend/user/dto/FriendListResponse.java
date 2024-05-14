package km.cd.backend.user.dto;

import km.cd.backend.user.domain.FriendStatus;
import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class FriendListResponse {
    private Long friendShipId;
    private String friendEmail;
    private String friendName;
    private FriendStatus status;
}
