package km.cd.backend.challenge.domain;

import com.fasterxml.jackson.annotation.JsonManagedReference;
import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Data
@AllArgsConstructor
@NoArgsConstructor
public class Challenge {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long challenge_id;

    private Boolean is_private;

    private String private_code;

    private String challenge_name;

    private String challenge_explanation;

    private Date start_date;

    private Date end_date;

    private String certification_frequency;

    private Integer certification_start_time;

    private Integer certification_end_time;

    private String certification_explanation;

    private Boolean is_gallery_possible;

    private Integer maximum_people;
    
    @JsonManagedReference
    @OneToMany(mappedBy = "challenge", cascade = CascadeType.ALL)
    private List<Participant> participants = new ArrayList<>();

    @ElementCollection(fetch = FetchType.LAZY)
    private List<String> challenge_image_path;

    private String failed_verification_image;

    private String successful_verification_image;
}
