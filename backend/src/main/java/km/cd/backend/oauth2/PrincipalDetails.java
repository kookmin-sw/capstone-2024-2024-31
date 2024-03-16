package km.cd.backend.oauth2;

import km.cd.backend.oauth2.attributes.OAuth2Attributes;
import km.cd.backend.user.User;
import lombok.Setter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;

@Setter
public class PrincipalDetails implements UserDetails, OAuth2User {

    private User user;
    private OAuth2Attributes oAuth2Attributes;

    private PrincipalDetails() {}

    public static PrincipalDetails login(User user) {
        PrincipalDetails principalDetails = new PrincipalDetails();
        principalDetails.setUser(user);
        return principalDetails;
    }

    public static PrincipalDetails socialLogin(User user, OAuth2Attributes oAuth2Attributes) {
        PrincipalDetails principalDetails = new PrincipalDetails();
        principalDetails.setUser(user);
        principalDetails.setOAuth2Attributes(oAuth2Attributes);
        return principalDetails;
    }

    @Override
    public Map<String, Object> getAttributes() {
        return oAuth2Attributes.getAttributes();
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton(new SimpleGrantedAuthority(user.getRole()));
    }

    @Override
    public String getUsername() {
        return user.getEmail();
    }

    @Override
    public String getName() {
        return user.getName();
    }

    @Override
    public String getPassword() {
        return user.getPassword();
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
