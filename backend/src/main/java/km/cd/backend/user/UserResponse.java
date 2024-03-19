package km.cd.backend.user;

public record UserResponse(
        String email,
        String avatar,
        String name,
        int level,
        int xp,
        int point
){ }
