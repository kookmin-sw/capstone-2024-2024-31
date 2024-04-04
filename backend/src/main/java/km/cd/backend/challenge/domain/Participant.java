package km.cd.backend.challenge.domain;

import jakarta.persistence.*;
import km.cd.backend.user.User;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.math.BigDecimal;

@Entity
@Data
@NoArgsConstructor
public class Participant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne
    @JoinColumn(name = "challenge_id")
    private Challenge challenge;

    @ManyToOne
    @JoinColumn(name = "user_id")
    private User user;

    private boolean is_owner;

    private BigDecimal deposit;

    private boolean payment_status;
}
