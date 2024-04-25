package km.cd.backend.community.service;

import km.cd.backend.common.error.CustomException;
import km.cd.backend.community.domain.Like;
import km.cd.backend.community.domain.Post;
import km.cd.backend.community.repository.LikeRepository;
import km.cd.backend.community.repository.PostRepository;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Optional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class LikeService {

    private final UserRepository userRepository;
    private final PostRepository postRepository;
    private final LikeRepository likeRepository;

    @Transactional
    public void likePost(Long userId, Long postId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(400, "User not found."));
        Post post = postRepository.findByIdWithComment(postId)
                .orElseThrow(() -> new CustomException(400, "Post not found."));

        Optional<Like> _like = likeRepository.findByUserAndPost(user, post);
        if (_like.isPresent()) {
            throw new CustomException(400, "Like already exists.");
        }

        Like like = Like.builder()
                .user(user)
                .post(post)
                .build();
        likeRepository.save(like);
    }

    @Transactional
    public void unlikePost(Long userId, Long postId) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(400, "User not found."));
        Post post = postRepository.findByIdWithComment(postId)
                .orElseThrow(() -> new CustomException(400, "Post not found."));
        Like like = likeRepository.findByUserAndPost(user, post)
                .orElseThrow(() -> new CustomException(400, "Like not found."));

        likeRepository.delete(like);
    }

}
