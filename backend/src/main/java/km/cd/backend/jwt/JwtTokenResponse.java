package km.cd.backend.jwt;

import lombok.Builder;
import lombok.Getter;

@Getter
@Builder
public class JwtTokenResponse {

    private String accessToken;

}
