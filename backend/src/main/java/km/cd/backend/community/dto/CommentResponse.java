package km.cd.backend.community.dto;

import java.util.List;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.dto.UserResponse;

public record CommentResponse(
    Long id,
    String author,
    String content,
    List<CommentResponse> children,
    UserResponse userResponse) {
}