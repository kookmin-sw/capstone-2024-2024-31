package km.cd.backend.community.dto;

import com.fasterxml.jackson.annotation.JsonFormat;

import java.time.LocalDateTime;
import java.util.List;

public record CommentResponse(
        Long id,
        Long parentId,
        String author,
        String avatar,
        String content,

        @JsonFormat(shape = JsonFormat.Shape.STRING, pattern = "yyyy-MM-dd HH:mm:ss", timezone = "Asia/Seoul")
        LocalDateTime createdDate,
        List<CommentResponse> children
) {
}