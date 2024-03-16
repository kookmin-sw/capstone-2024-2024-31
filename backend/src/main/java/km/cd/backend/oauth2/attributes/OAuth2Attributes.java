package km.cd.backend.oauth2.attributes;

import lombok.Getter;

import java.util.Map;

@Getter
public abstract class OAuth2Attributes {

    protected Map<String, Object> attributes;

    public abstract String getOAuth2Id();
    public abstract String getEmail();
    public abstract String getName();
}
