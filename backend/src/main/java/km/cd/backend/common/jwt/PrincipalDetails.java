package km.cd.backend.common.jwt;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.oauth2.core.user.OAuth2User;

import java.util.Collection;
import java.util.Map;

/**
 * UserDetails, OAuth2User를 동시에 구현하여 일반 유저 및 소셜 로그인 유저를 통합 관리하는 객체
 * @author Sukju Hong
 * @see org.springframework.security.core.userdetails.UserDetails
 * @see org.springframework.security.oauth2.core.user.OAuth2User
 */
@Getter
@AllArgsConstructor
public class PrincipalDetails implements UserDetails, OAuth2User {

    private Long userId;
    private String email;
    private String name;

    private Collection<? extends GrantedAuthority> authorities;

    @Override
    public Map<String, Object> getAttributes() {
        return null;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return authorities;
    }

    @Override
    public String getUsername() {
        return this.email;
    }

    @Override
    public String getName() {
        return this.name;
    }

    @Override
    public String getPassword() {
        return null;
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
