package km.cd.backend.community.service;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.community.domain.Post;
import km.cd.backend.community.dto.PostResponse;
import km.cd.backend.community.dto.PostRequest;
import km.cd.backend.community.repository.PostRepository;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.repository.UserRepository;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.junit.jupiter.api.extension.ExtendWith;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import org.springframework.mock.web.MockMultipartFile;
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

    @Autowired
    LikeService likeService;
    
    private User fakeUser;
    private Challenge fakeChallenge;
    private final MockMultipartFile file = new MockMultipartFile(
        "files",
        "imageFile.png",
        "image/png",
        "<<png data>>".getBytes());
    
    @BeforeEach
    void setUp() {
        fakeUser = User.builder()
            .email("email")
            .name("name")
            .build();
        fakeChallenge = new Challenge();
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

        PostResponse postResponse = postService.createPost(fakeUser.getId(), fakeChallenge.getId(), postRequest, file);
        
        assertEquals(postRequest.title(), postResponse.title());
        assertEquals(postRequest.content(), postResponse.content());
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
        
        postService.createPost(fakeUser.getId(), fakeChallenge.getId(), postRequest1, file);
        postService.createPost(fakeUser.getId(), fakeChallenge.getId(), postRequest2, file);
        
        List<PostResponse> postSimpleResponses = postService.findAllByChallengeId(fakeChallenge.getId());
        
        assertEquals(2, postSimpleResponses.size());
    }

    @Test
    @DisplayName("게시물_삭제-성공")
    void delete_post_success() {
        PostRequest postRequest = new PostRequest(
            "title",
            "description"
        );
        
        PostResponse postResponse = postService.createPost(fakeUser.getId(), fakeChallenge.getId(), postRequest, file);
        
        postService.deletePost(fakeUser.getId(), postResponse.id());
        
        Optional<Post> _post = postRepository.findById(postResponse.id());
        assertTrue(_post.isEmpty());
    }

    @Test
    @DisplayName("게시물_좋아요-성공")
    void like_post_success() {
        User user = User.builder()
                .email("test@exam.ple")
                .build();
        user = userRepository.save(user);

        PostRequest postRequest = new PostRequest(
                "title",
                "description"
        );

        PostResponse postResponse = postService.createPost(fakeUser.getId(), fakeChallenge.getId(), postRequest, file);

        likeService.likePost(user.getId(), postResponse.id());

        postResponse = postService.findByPostId(postResponse.id());
        assertEquals(postResponse.likes().size(), 1);
    }
}