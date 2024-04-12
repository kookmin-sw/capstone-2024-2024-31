package km.cd.backend.community.service;

import km.cd.backend.common.error.CustomException;
import km.cd.backend.community.domain.Comment;
import km.cd.backend.community.domain.Post;
import km.cd.backend.community.dto.CommentRequest;
import km.cd.backend.community.dto.CommentResponse;
import km.cd.backend.community.mapper.CommentMapper;
import km.cd.backend.community.repository.CommentRepository;
import km.cd.backend.community.repository.PostRepository;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
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
                .orElseThrow(() -> new CustomException(400, "User not found."));
        Post post = postRepository.findById(postId)
                .orElseThrow(() -> new CustomException(400, "Post not found."));

        String content = commentRequest.content();
        Comment comment = new Comment(
                post,
                user,
                content
        );
        if (parentId != null) {
            Comment parent = commentRepository.findById(parentId)
                    .orElseThrow(() -> new CustomException(400, "Parent comment not found."));
            comment.setParent(parent);
        }
        commentRepository.save(comment);
        return CommentMapper.INSTANCE.entityToResponse(comment);
    }

    @Transactional
    public void updateComment(Long authorId, Long commentId, String newContent) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new CustomException(400, "Comment not found."));

        if (!comment.getAuthor().getId().equals(authorId)) {
            throw new CustomException(403, "You do not have permission to update comments.");
        }

        comment.updateContent(newContent);
        commentRepository.save(comment);
    }

    @Transactional
    public void deleteComment(Long authorId, Long commentId) {
        Comment comment = commentRepository.findById(commentId)
                .orElseThrow(() -> new CustomException(400, "Comment not found."));

        if (!comment.getAuthor().getId().equals(authorId)) {
            throw new CustomException(403, "You do not have permission to delete comments.");
        }

        comment.deleteComment();
        commentRepository.save(comment);
    }
}
