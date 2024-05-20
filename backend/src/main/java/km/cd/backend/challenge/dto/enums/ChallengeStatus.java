package km.cd.backend.challenge.dto.enums;

import lombok.Getter;
import lombok.RequiredArgsConstructor;

@Getter
@RequiredArgsConstructor
public enum ChallengeStatus {
    NOT_STARTED("진행전"),
    IN_PROGRESS("진행중"),
    COMPLETED("진행완료");
    
    private final String description;
}
