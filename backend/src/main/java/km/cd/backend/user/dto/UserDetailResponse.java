package km.cd.backend.user.dto;

import java.util.List;
import km.cd.backend.challenge.domain.ChallengeCategory;
import lombok.Data;

@Data
public class UserDetailResponse {
    Long id;
    String email;
    String avatar;
    String name;
    int point;
    List<String> categories;
    List<FriendListResponse> following;
    List<FriendListResponse> follower;
}
