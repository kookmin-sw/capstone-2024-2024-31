package km.cd.backend.community.dto;

import java.util.List;

public record CommentResponse(
    Long id,
    String author,
    String content,
    List<CommentResponse> children) {
}