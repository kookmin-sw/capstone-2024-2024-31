package km.cd.backend.oauth2;

import km.cd.backend.jwt.PrincipalDetails;
import km.cd.backend.oauth2.attributes.OAuth2Attributes;
import km.cd.backend.oauth2.attributes.OAuth2AttributesFactory;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.security.oauth2.client.userinfo.DefaultOAuth2UserService;
import org.springframework.security.oauth2.client.userinfo.OAuth2UserRequest;
import org.springframework.security.oauth2.core.OAuth2AuthenticationException;
import org.springframework.security.oauth2.core.user.OAuth2User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Map;

@Service
@Transactional
@RequiredArgsConstructor
public class OAuth2UserServiceImpl extends DefaultOAuth2UserService {

    private final UserRepository userRepository;

    @Override
    public OAuth2User loadUser(OAuth2UserRequest userRequest) throws OAuth2AuthenticationException {
        OAuth2User oAuth2User = super.loadUser(userRequest);

        String registrationId = userRequest.getClientRegistration().getRegistrationId();
        String userNameAttributeName = userRequest.getClientRegistration()
                .getProviderDetails().getUserInfoEndpoint().getUserNameAttributeName();

        Map<String, Object> attributes = oAuth2User.getAttributes();
        OAuth2Attributes oAuth2Attributes = OAuth2AttributesFactory.getOauth2Attributes(registrationId, attributes, userNameAttributeName);

        User user = userRepository.findByEmail(oAuth2Attributes.getEmail()).orElse(null);
        if (user != null) {
            user = updateUser(user, oAuth2Attributes);
        } else {
            user = registerUser(registrationId, oAuth2Attributes);
        }

        return new PrincipalDetails(user, oAuth2Attributes);
    }

    private User registerUser(String registrationId, OAuth2Attributes oAuth2Attributes) {
        User user = User.builder()
                .email(oAuth2Attributes.getEmail())
                .name(oAuth2Attributes.getName())
                .avatar(oAuth2Attributes.getAvatar())
                .provider(registrationId)
                .oauth2Id(oAuth2Attributes.getOAuth2Id())
                .build();
        return userRepository.save(user);
    }

    private User updateUser(User user, OAuth2Attributes oAuth2Attributes) {
        user.updateDefaultAttributes(oAuth2Attributes);
        return userRepository.save(user);
    }

}
