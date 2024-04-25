package km.cd.backend.community.service;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.community.domain.Post;
import km.cd.backend.community.dto.PostDetailResponse;
import km.cd.backend.community.dto.PostRequest;
import km.cd.backend.community.dto.PostSimpleResponse;
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

import java.util.List;
import java.util.Optional;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertTrue;

@SpringBootTest
@ExtendWith(SpringExtension.class)
@Transactional
class PostServiceTest {

    @Autowired
    UserRepository userRepository;

    @Autowired
    ChallengeRepository challengeRepository;

    @Autowired
    PostRepository postRepository;

    @Autowired
    PostService postService;

    private User fakeUser;
    private Challenge fakeChallenge;

    @BeforeEach
    void setUp() {
        fakeUser = User.builder()
                .email("email")
                .name("name")
                .build();
        fakeChallenge = Challenge.builder()
                .build();
        userRepository.save(fakeUser);
        challengeRepository.save(fakeChallenge);
    }

    @Test
    @DisplayName("게시물_생성-성공")
    void create_post_success() {
        PostRequest postRequest = new PostRequest(
                "title",
                "description"
        );

        PostDetailResponse postDetailResponse = postService.createPost(fakeUser.getId(), fakeChallenge.getChallengeId(), postRequest);

        assertEquals(postRequest.title(), postDetailResponse.title());
        assertEquals(postRequest.content(), postDetailResponse.content());
    }

    @Test
    @DisplayName("게시물_전체_조회-성공")
    void find_all_post_success() {
        PostRequest postRequest1 = new PostRequest(
                "title",
                "description"
        );
        PostRequest postRequest2 = new PostRequest(
                "title",
                "description"
        );
        postService.createPost(fakeUser.getId(), fakeChallenge.getChallengeId(), postRequest1);
        postService.createPost(fakeUser.getId(), fakeChallenge.getChallengeId(), postRequest2);

        List<PostSimpleResponse> postSimpleResponses = postService.findAllByChallengeId(fakeChallenge.getChallengeId());

        assertEquals(2, postSimpleResponses.size());
    }

    @Test
    @DisplayName("게시물_단건_조회-성공")
    void find_post_success() {

    }

    @Test
    @DisplayName("게시물_삭제-성공")
    void delete_post_success() {
        PostRequest postRequest = new PostRequest(
                "title",
                "description"
        );

        PostDetailResponse postDetailResponse = postService.createPost(fakeUser.getId(), fakeChallenge.getChallengeId(), postRequest);

        postService.deletePost(fakeUser.getId(), postDetailResponse.id());

        Optional<Post> _post = postRepository.findById(postDetailResponse.id());
        assertTrue(_post.isEmpty());
    }

}