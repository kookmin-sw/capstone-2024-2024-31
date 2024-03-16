package km.cd.backend.user;

import jakarta.persistence.*;
import km.cd.backend.oauth2.attributes.OAuth2Attributes;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;

import java.time.LocalDateTime;

@Entity
@Table(name = "users")
@Getter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class User {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String email;

    private String password;

    private String provider;
    private String oauth2Id;

    @Column(nullable = false)
    private String name;

    @Builder.Default
    private String role = "ROLE_USER";

    @CreatedDate
    private LocalDateTime createdDate;

    private String avatar;

    @Builder.Default
    private Integer level = 1;

    @Builder.Default
    private Integer xp = 0;

    @Builder.Default
    private Integer point = 0;

    public void updateDefaultAttributes(OAuth2Attributes oAuth2Attributes) {
        this.email = oAuth2Attributes.getEmail();
        this.name = oAuth2Attributes.getName();
        this.oauth2Id = oAuth2Attributes.getOAuth2Id();
    }
}
