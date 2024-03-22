package km.cd.backend.user;

import jakarta.persistence.*;
import km.cd.backend.oauth2.attributes.OAuth2Attributes;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

@Entity
@EntityListeners(value = AuditingEntityListener.class)
@Table(name = "users")
@Getter
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
    private int level = 1;

    @Builder.Default
    private int xp = 0;

    @Builder.Default
    private int point = 0;

    public void updateDefaltInfo(OAuth2Attributes oAuth2Attributes) {
        this.email = oAuth2Attributes.getEmail();
        this.name = oAuth2Attributes.getName();
        this.avatar = oAuth2Attributes.getAvatar();
    }
}
