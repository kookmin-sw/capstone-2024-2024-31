package km.cd.backend.user.dto;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class UserRegister {

    private String email;
    private String password;
    private String name;

}
