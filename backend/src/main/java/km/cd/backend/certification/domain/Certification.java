package km.cd.backend.certification.domain;

import jakarta.persistence.*;
import km.cd.backend.challenge.domain.Participant;
import lombok.*;

@Entity
@Table(name = "certifications")
@Getter
@Builder
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
public class Certification {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "participant_id")
    private Participant participant;

}
