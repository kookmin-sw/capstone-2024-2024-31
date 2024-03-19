package km.cd.backend.oauth2;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import km.cd.backend.jwt.JwtTokenProvider;
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
    public static final String REDIRECT_URL = "http://localhost:3000/oauth2/success";

    @Override
    public void onAuthenticationSuccess(HttpServletRequest request, HttpServletResponse response, Authentication authentication) throws IOException {
        String token = jwtTokenProvider.generateToken(authentication);
        String redirectUrlWithToken = UriComponentsBuilder.fromUriString(REDIRECT_URL)
                .queryParam("token", token)
                .build().toUriString();

        log.debug("token: {}", token);
        log.debug("redirect_url: {}", redirectUrlWithToken);

        getRedirectStrategy().sendRedirect(request, response, redirectUrlWithToken);
    }

}