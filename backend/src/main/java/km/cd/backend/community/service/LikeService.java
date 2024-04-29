package km.cd.backend.community.service;

import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
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
                .orElseThrow(() -> new CustomException(ExceptionCode.USER_NOT_FOUND));
        Post post = postRepository.findByIdWithComment(postId)
                .orElseThrow(() -> new CustomException(ExceptionCode.POST_NOT_FOUND));

        Optional<Like> _like = likeRepository.findByUserAndPost(user, post);
        if (_like.isPresent()) {
            throw new CustomException(ExceptionCode.ALREADY_LIKED);
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
                .orElseThrow(() -> new CustomException(ExceptionCode.USER_NOT_FOUND));
        Post post = postRepository.findByIdWithComment(postId)
                .orElseThrow(() -> new CustomException(ExceptionCode.POST_NOT_FOUND));
        Like like = likeRepository.findByUserAndPost(user, post)
                .orElseThrow(() -> new CustomException(ExceptionCode.LIKE_NOT_FOUND));

        likeRepository.delete(like);
    }

}
