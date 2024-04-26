package km.cd.backend.community.service;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.community.domain.Comment;
import km.cd.backend.community.domain.Post;
import km.cd.backend.community.dto.CommentRequest;
import km.cd.backend.community.dto.CommentResponse;
import km.cd.backend.community.repository.CommentRepository;
import km.cd.backend.community.repository.PostRepository;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.test.context.junit.jupiter.SpringExtension;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest
@ExtendWith(SpringExtension.class)
@Transactional
class CommentServiceTest {


    @Autowired
    UserRepository userRepository;

    @Autowired
    ChallengeRepository challengeRepository;

    @Autowired
    PostRepository postRepository;

    @Autowired
    CommentRepository commentRepository;

    @Autowired
    CommentService commentService;

    private User fakeUser;
    private Post fakePost;

    @BeforeEach
    void setUp() {
        fakeUser = User.builder()
                .email("email")
                .name("name")
                .build();
        Challenge fakeChallenge = new Challenge();
        fakePost = Post.builder()
                .title("title")
                .content("content")
                .author(fakeUser)
                .challenge(fakeChallenge)
                .build();
        userRepository.save(fakeUser);
        challengeRepository.save(fakeChallenge);
        postRepository.save(fakePost);
    }

    @Test
    @DisplayName("댓글_생성-성공")
    void create_comment_success() {
        CommentRequest commentRequest1 = new CommentRequest(
                "content1"
        );

        CommentRequest commentRequest2 = new CommentRequest(
                "content2"
        );

        CommentResponse commentResponse = commentService.createComment(fakeUser.getId(), fakePost.getId(), commentRequest1, null);
        commentService.createComment(fakeUser.getId(), fakePost.getId(), commentRequest2, commentResponse.id());

        assertEquals(commentRequest1.content(), commentResponse.content());

        Optional<Comment> _commentWithChildren = commentRepository.findById(commentResponse.id());
        assertTrue(_commentWithChildren.isPresent());
        assertEquals(1, _commentWithChildren.get().getChildren().size());
    }

    @Test
    @DisplayName("댓글_수정-성공")
    void update_comment_success() {
        CommentRequest commentRequest1 = new CommentRequest(
                "content1"
        );

        CommentResponse commentResponse = commentService.createComment(fakeUser.getId(), fakePost.getId(), commentRequest1, null);

        String newContent = "new-content";

        commentService.updateComment(fakeUser.getId(), commentResponse.id(), newContent);

        Optional<Comment> _comment = commentRepository.findById(commentResponse.id());
        assertTrue(_comment.isPresent());
        assertEquals(newContent, _comment.get().getContent());
    }

    @Test
    @DisplayName("댓글_삭제-성공")
    void delete_comment_success() {
        CommentRequest commentRequest1 = new CommentRequest(
                "content1"
        );

        CommentResponse commentResponse = commentService.createComment(fakeUser.getId(), fakePost.getId(), commentRequest1, null);

        commentService.deleteComment(fakeUser.getId(), commentResponse.id());
        Optional<Comment> _comment = commentRepository.findById(commentResponse.id());
        assertTrue(_comment.isPresent());
        assertTrue(_comment.get().isDeleted());
    }

}