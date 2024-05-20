package km.cd.backend.community.service;

import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.community.domain.Comment;
import km.cd.backend.community.domain.Post;
import km.cd.backend.community.dto.CommentRequest;
import km.cd.backend.community.dto.CommentResponse;
import km.cd.backend.community.mapper.CommentMapper;
import km.cd.backend.community.repository.CommentRepository;
import km.cd.backend.community.repository.PostRepository;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CommentService {

    private final UserRepository userRepository;
    private final PostRepository postRepository;
    private final CommentRepository commentRepository;

    @Transactional
    public CommentResponse createComment(Long userId, Long postId, CommentRequest commentRequest, Long parentId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(ExceptionCode.USER_NOT_FOUND));
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new CustomException(ExceptionCode.POST_NOT_FOUND));

        String content = commentRequest.content();
        Comment comment = new Comment(
                post,
                user,
                content
        );
        if (parentId != null) {
            Comment parent = commentRepository.findById(parentId)
                    .orElseThrow(() -> new CustomException(ExceptionCode.PARENT_COMMENT_NOT_FOUND));
            comment.setParent(parent);
            parent.getChildren().add(comment);
        }
        commentRepository.save(comment);
        return CommentMapper.INSTANCE.entityToResponse(comment);
    }

    @Transactional
    public void updateComment(Long authorId, Long commentId, String newContent) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new CustomException(ExceptionCode.REPLY_NOT_FOUND));

        if (!comment.getAuthor().getId().equals(authorId)) {
            throw new CustomException(ExceptionCode.PERMISSION_UPDATE_COMMENT_DENIED);
        }

        comment.updateContent(newContent);
        commentRepository.save(comment);
    }

    @Transactional
    public void deleteComment(Long authorId, Long commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new CustomException(ExceptionCode.REPLY_NOT_FOUND));

        if (!comment.getAuthor().getId().equals(authorId)) {
            throw new CustomException(ExceptionCode.PERMISSION_DELETE_COMMENT_DENIED);
        }

        comment.deleteComment();
        commentRepository.save(comment);
    }
}
