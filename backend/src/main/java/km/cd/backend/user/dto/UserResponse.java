package km.cd.backend.user.dto;

public record UserResponse(
        String email,
        String avatar,
        String name,
        int level,
        int xp,
        int point
){ }
