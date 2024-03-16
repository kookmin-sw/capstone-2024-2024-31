package km.cd.backend.oauth2.attributes;

import km.cd.backend.oauth2.attributes.GoogleOAuth2Attributes;
import km.cd.backend.oauth2.attributes.OAuth2Attributes;

import java.util.Map;

public class OAuth2AttributesFactory {

    public static OAuth2Attributes getOauth2Attributes(String registrationId, Map<String, Object> attributes) {
        switch (registrationId) {
            case "google": return GoogleOAuth2Attributes.builder().attributes(attributes).build();
            default: throw new IllegalArgumentException();
        }
    }

}
