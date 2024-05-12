package km.cd.backend.challenge.domain;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import km.cd.backend.certification.domain.CertificationType;
import lombok.*;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Table(name = "challenges")
@Getter @Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor
public class Challenge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    private Boolean isPrivate;

    private String privateCode;

    private String challengeName;

    private String challengeExplanation;
    
    private Integer challengePeriod;

    private Date startDate;

    private Date endDate;

    private String certificationFrequency;

    private Integer certificationStartTime;

    private Integer certificationEndTime;

    private String certificationExplanation;

    private Boolean isGalleryPossible;

    private Integer maximumPeople;
    
    @JsonManagedReference
    @OneToMany(mappedBy = "challenge", cascade = CascadeType.ALL)
    @Builder.Default
    private List<Participant> participants = new ArrayList<>();

    @ElementCollection(fetch = FetchType.LAZY)
    private List<String> challengeImagePaths;

    private String failedVerificationImage;

    private String successfulVerificationImage;
    
    @Builder.Default
    private Boolean isEnded = false;
    
    @Builder.Default
    private Integer totalParticipants = 0;

    @Builder.Default
    @Enumerated(EnumType.STRING)
    private CertificationType certificationType = CertificationType.HAND_GESTURE;

    @Enumerated(EnumType.STRING)
    private ChallengeCategory challengeCategory;
    
    public void increaseNumOfParticipants() {
        totalParticipants += 1;
    }

    public void finishChallenge() {
        this.isEnded = true;
    }
}
