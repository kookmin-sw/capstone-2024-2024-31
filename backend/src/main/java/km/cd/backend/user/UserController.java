package km.cd.backend.user;

import km.cd.backend.oauth2.PrincipalDetails;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class UserController {

    @GetMapping("/")
    public String home() {
        return "Hello, It's Home!";
    }

    @GetMapping("/user")
    public PrincipalDetails user(@AuthenticationPrincipal PrincipalDetails principalDetails) {
        return principalDetails;
    }
}
