package km.cd.backend.user.dto;

import java.util.List;
import km.cd.backend.challenge.domain.ChallengeCategory;

public record UserResponse(
        Long id,
        String email,
        String avatar,
        String name,
        int point,
        List<ChallengeCategory> categories
) { }
