package km.cd.backend.challenge.domain;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Data @Builder
@AllArgsConstructor
@NoArgsConstructor
public class Challenge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long challengeId;

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
    
    public void increaseNumOfParticipants() {
        totalParticipants += 1;
    }
}
