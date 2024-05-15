package km.cd.backend.user.dto;

public record UserResponse(
        Long id,
        String email,
        String avatar,
        String name,
        int point
){ }
