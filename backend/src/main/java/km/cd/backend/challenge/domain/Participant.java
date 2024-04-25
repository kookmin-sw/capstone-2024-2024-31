package km.cd.backend.challenge.domain;

import com.fasterxml.jackson.annotation.JsonBackReference;
import jakarta.persistence.*;
import java.time.LocalDate;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import km.cd.backend.user.User;
import lombok.Data;
import lombok.NoArgsConstructor;
@Entity
@Data
@NoArgsConstructor
public class Participant {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;
    
    @JsonBackReference
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "challenge_id")
    private Challenge challenge;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    private boolean isOwner;
    
    @ElementCollection(fetch = FetchType.LAZY)
    @MapKeyColumn(name = "date")
    private Map<LocalDate, String> certificationImages = new HashMap<>();
    
    private Integer numberOfCertifications = 0;
    
    public void increaseNumOfCertifications() {
        numberOfCertifications += 1;
    }
}
