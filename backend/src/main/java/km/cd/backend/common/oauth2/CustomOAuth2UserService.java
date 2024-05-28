package km.cd.backend.common.oauth2;

import km.cd.backend.common.jwt.PrincipalDetails;
import km.cd.backend.common.oauth2.attributes.OAuth2Attributes;
import km.cd.backend.common.oauth2.attributes.OAuth2AttributesFactory;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Collections;
import java.util.Map;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class CustomOAuth2UserService extends DefaultOAuth2UserService {

    private final UserRepository userRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        String userNameAttributeName = userRequest.getClientRegistration()
                .getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();

        Map<String, Object> attributes = oAuth2User.getAttributes();
        OAuth2Attributes oAuth2Attributes = OAuth2AttributesFactory.getOauth2Attributes(registrationId, userNameAttributeName, attributes);

        Optional<User> _user = userRepository.findByEmail(oAuth2Attributes.getEmail());
        User user;
        if (_user.isPresent()) {
            user = updateUser(_user.get(), oAuth2Attributes);
        } else {
            user = registerUser(oAuth2Attributes);
        }

        return new PrincipalDetails(
                user.getId(),
                user.getEmail(),
                user.getName(),
                Collections.singleton(new SimpleGrantedAuthority("ROLE_USER"))
        );
    }

    private User registerUser(OAuth2Attributes oAuth2Attributes) {
        User user = User.builder()
                .email(oAuth2Attributes.getEmail())
                .name(oAuth2Attributes.getName())
                .avatar(oAuth2Attributes.getAvatar())
                .provider(oAuth2Attributes.getProvider())
                .providerId(oAuth2Attributes.getProviderId())
                .build();
        return userRepository.save(user);
    }

    private User updateUser(User user, OAuth2Attributes OAuth2Attributes) {
        user.updateDefaltInfo(OAuth2Attributes);
        return userRepository.save(user);
    }

}
