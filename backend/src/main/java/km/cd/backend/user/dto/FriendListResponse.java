package km.cd.backend.user.dto;

import lombok.Builder;
import lombok.Data;

@Builder
@Data
public class FriendListResponse {
    private Long friendId;
    private String friendEmail;
    private String friendName;
}
