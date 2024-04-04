package km.cd.backend.challenge.domain;

import jakarta.persistence.*;
import lombok.Builder;
import lombok.Getter;
import lombok.Setter;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

@Entity
@Getter @Setter
public class Challenge {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long challenge_id;

    private String challenge_name;

    private Date start_date;

    private Date end_date;

    private Integer certification_frequency;

    private String certification_explanation;

    private Integer certification_count;

    private String certification_method;

    private String challenge_explanation;

    private Integer maximum_people;

    private Boolean is_private;

    private String private_code;

    @OneToMany(mappedBy = "challenge", cascade = CascadeType.ALL)
    private List<Participant> participants = new ArrayList<>();

    public Challenge() {}
    @Builder
    public Challenge(String challenge_name, Date start_date, Date end_date, Integer certification_frequency,
                     String certification_explanation, Integer certification_count, String certification_method,
                     String challenge_explanation, Integer maximum_people, Boolean is_private, String private_code, List<Participant> participants) {
        this.challenge_name = challenge_name;
        this.start_date = start_date;
        this.end_date = end_date;
        this.certification_frequency = certification_frequency;
        this.certification_explanation = certification_explanation;
        this.certification_count = certification_count;
        this.certification_method = certification_method;
        this.challenge_explanation = challenge_explanation;
        this.maximum_people = maximum_people;
        this.is_private = is_private;
        this.private_code = private_code;
        this.participants = participants;
    }

}
