package km.cd.backend.user.dto;

import java.util.List;
import lombok.Data;

@Data
public class UserDetailResponse {
    Long id;
    String email;
    String avatar;
    String name;
    int point;
    List<String> categories;
}
