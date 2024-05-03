package km.cd.backend.challenge.dto.response;

import java.time.LocalDateTime;

public record ChallengeInviteCodeResponse(
    String code,
    LocalDateTime expirationTime
) {
}
