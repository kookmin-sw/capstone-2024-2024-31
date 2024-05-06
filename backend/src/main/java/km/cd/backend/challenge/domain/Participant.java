package km.cd.backend.challenge.domain;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.persistence.*;
import km.cd.backend.user.User;
import lombok.*;

@Entity
@Table(name = "participants")
@Getter @Setter
@RequiredArgsConstructor
public class Participant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "challenge_id")
    private Challenge challenge;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    private boolean isOwner;
}
