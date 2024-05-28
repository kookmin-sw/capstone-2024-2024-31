package km.cd.backend.common.oauth2;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import km.cd.backend.common.jwt.JwtTokenProvider;
import km.cd.backend.common.jwt.PrincipalDetails;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;
import org.springframework.web.util.UriComponentsBuilder;

import java.io.IOException;

@Slf4j
@Component
@RequiredArgsConstructor
public class OAuth2AuthenticationSuccessHandler extends SimpleUrlAuthenticationSuccessHandler {

    private final JwtTokenProvider jwtTokenProvider;

    // TODO: Flutter App Redirect 주소로 변경
    public static final String REDIRECT_URL = "web-auth-callback://";
    public static final String PARAM_AC_TOKEN = "access_token";
    public static final String PARAM_RF_TOKEN = "refresh_token";

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
        // TODO: save refresh token
        PrincipalDetails principalDetails = (PrincipalDetails) authentication.getPrincipal();
        String accessToken = jwtTokenProvider.generateAccessToken(
                principalDetails.getUserId(),
                principalDetails.getEmail(),
                principalDetails.getName(),
                principalDetails.getAuthorities());

        String redirectUrlWithToken = UriComponentsBuilder.fromUriString(REDIRECT_URL)
                .queryParam(PARAM_AC_TOKEN, accessToken)
                .build().toUriString();

        log.debug("access_token: {}", accessToken);
        log.debug("redirect_url: {}", redirectUrlWithToken);

        getRedirectStrategy().sendRedirect(request, response, redirectUrlWithToken);
    }

}