package km.cd.backend.community.dto;

import km.cd.backend.community.domain.Like;
import km.cd.backend.user.dto.UserResponse;

import java.time.LocalDateTime;
import java.util.List;

public record PostResponse(
        Long id,
        String title,
        String content,
        UserResponse author,
        String image,
        LocalDateTime createdDate,
        List<Like> likes,
        List<CommentResponse> comments) {
}
