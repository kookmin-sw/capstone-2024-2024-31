package km.cd.backend.community.dto;

import org.springframework.format.annotation.DateTimeFormat;

import java.time.LocalDateTime;
import java.util.List;

public record PostResponse(
        Long id,
        String title,
        String content,
        String author,
        String avatar,
        String image,

        @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm:ss")
        LocalDateTime createdDate,
        List<LikeResponse> likes,
        List<CommentResponse> comments) {
}
