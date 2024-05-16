package km.cd.backend.user.domain;

import jakarta.persistence.*;
import java.util.ArrayList;
import java.util.Collection;
import java.util.Collections;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import km.cd.backend.challenge.domain.ChallengeCategory;
import km.cd.backend.common.oauth2.attributes.OAuth2Attributes;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;

@Entity
@EntityListeners(value = AuditingEntityListener.class)
@Table(name = "users")
@Getter @Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false, unique = true)
    private String email;

    private String password;

    private String provider;
    private String providerId;

    @Column(nullable = false)
    private String name;

    private String avatar;

    @Builder.Default
    private String role = "ROLE_USER";

    @CreatedDate
    private LocalDateTime createdDate;

    @Builder.Default
    private int point = 0;
    
    @OneToMany(mappedBy = "fromUser", cascade = CascadeType.ALL)
    private List<Friend> following = new ArrayList<>();
    
    @OneToMany(mappedBy = "toUser", cascade = CascadeType.ALL)
    private List<Friend> follower = new ArrayList<>();
    
    @ElementCollection(fetch = FetchType.EAGER)
    @Enumerated(EnumType.STRING)
    private List<ChallengeCategory> categories = new ArrayList<>();
    
    public User(Long id, String email, String name) {
        this.id = id;
        this.email = email;
        this.name = name;
    }

    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singleton(new SimpleGrantedAuthority("ROLE_USER"));
    }

    public void updateDefaltInfo(OAuth2Attributes oAuth2Attributes) {
        this.email = oAuth2Attributes.getEmail();
        this.name = oAuth2Attributes.getName();
        this.avatar = oAuth2Attributes.getAvatar();
    }
}
