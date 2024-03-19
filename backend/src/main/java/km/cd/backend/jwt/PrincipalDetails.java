package km.cd.backend.jwt;

import km.cd.backend.oauth2.attributes.OAuth2Attributes;
import km.cd.backend.user.User;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Collection;
import java.util.Collections;
import java.util.Map;

/**
 * UserDetails, OAuth2User를 동시에 구현하여 일반 유저 및 소셜 로그인 유저를 통합 관리하는 객체
 * @author Sukju Hong
 * @see org.springframework.security.core.userdetails.UserDetails
 * @see org.springframework.security.oauth2.core.user.OAuth2User
 */
@Getter
public class PrincipalDetails implements UserDetails, OAuth2User {

    private final User user;
    private OAuth2Attributes oAuth2Attributes;

    public PrincipalDetails(User user) {
        this.user = user;
    }

    public PrincipalDetails(User user, OAuth2Attributes oAuth2Attributes) {
        this.user = user;
        this.oAuth2Attributes = oAuth2Attributes;
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
