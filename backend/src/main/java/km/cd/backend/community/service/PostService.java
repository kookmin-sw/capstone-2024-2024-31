package km.cd.backend.community.service;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.dto.enums.FilePathEnum;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.utils.S3Uploader;
import km.cd.backend.community.domain.Post;
import km.cd.backend.community.dto.PostDetailResponse;
import km.cd.backend.community.dto.PostRequest;
import km.cd.backend.community.dto.PostSimpleResponse;
import km.cd.backend.community.mapper.PostMapper;
import km.cd.backend.community.repository.LikeRepository;
import km.cd.backend.community.repository.PostRepository;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.util.List;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class PostService {

  private final ChallengeRepository challengeRepository;
  private final UserRepository userRepository;
  private final PostRepository postRepository;
  private final S3Uploader s3Uploader;

  @Transactional
  public PostDetailResponse createPost(Long userId, Long challengeId, PostRequest postRequest, MultipartFile image) {
    User user = userRepository.findById(userId)
        .orElseThrow(() -> new CustomException(400, "User not found."));

    Challenge challenge = challengeRepository.findById(challengeId)
        .orElseThrow(() -> new CustomException(400, "Challenge not found."));

    if (image.isEmpty()) {
      throw new CustomException(400, "Image is null.");
    }

    PostMapper postMapper = PostMapper.INSTANCE;
    Post post = postMapper.requestToEntity(postRequest, user, challenge);

    String imagePath = s3Uploader.uploadFileToS3(image, FilePathEnum.COMMUNITY.getPath());
    post.setImage(imagePath);
    postRepository.save(post);

    return postMapper.entityToDetailResponse(post);
  }

  public List<PostSimpleResponse> findAllByChallengeId(Long challengeId) {
    List<Post> posts = postRepository.findAllByChallengeId(challengeId);
    return posts.stream()
            .map(PostMapper.INSTANCE::entityToSimpleResponse)
            .toList();
  }

  @Transactional
  public void deletePost(Long userId, Long challengeId) {
    Post post = postRepository.findById(challengeId)
            .orElseThrow(() -> new CustomException(400,"Challenge not found."));

    if (!post.isAuthor(userId)) {
      throw new CustomException(403, "You do not have permission to delete posts.");
    }

    postRepository.delete(post);
  }

  public PostDetailResponse findByPostId(Long postId) {
    Post post = postRepository.findByIdWithComment(postId)
            .orElseThrow(() -> new CustomException(400, "Post not found."));

    return PostMapper.INSTANCE.entityToDetailResponse(post);
  }
}
