package km.cd.backend.community.service;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.dto.enums.FilePathEnum;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.common.utils.s3.S3Uploader;
import km.cd.backend.community.domain.Post;
import km.cd.backend.community.dto.PostResponse;
import km.cd.backend.community.dto.PostRequest;
import km.cd.backend.community.dto.ReportResponse;
import km.cd.backend.community.mapper.PostMapper;
import km.cd.backend.community.repository.PostRepository;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.repository.UserRepository;
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
  public PostResponse createPost(Long userId, Long challengeId, PostRequest postRequest, MultipartFile image) {
    User user = userRepository.findById(userId)
        .orElseThrow(() -> new CustomException(ExceptionCode.USER_NOT_FOUND));

    Challenge challenge = challengeRepository.findById(challengeId)
        .orElseThrow(() -> new CustomException(ExceptionCode.CHALLENGE_NOT_FOUND));

    if (image.isEmpty()) {
      throw new CustomException(ExceptionCode.IMAGE_IS_NULL);
    }

    PostMapper postMapper = PostMapper.INSTANCE;
    Post post = postMapper.requestToEntity(postRequest, user, challenge);

    String imagePath = s3Uploader.uploadFileToS3(image, FilePathEnum.COMMUNITY.getPath());
    post.setImage(imagePath);
    postRepository.save(post);

    return postMapper.entityToResponse(post);
  }

  public List<PostResponse> findAllByChallengeId(Long challengeId) {
    List<Post> posts = postRepository.findAllByChallengeId(challengeId);
    return posts.stream()
            .filter(post -> !post.getIsRejected())
            .map(PostMapper.INSTANCE::entityToResponse)
            .toList();
  }

  @Transactional
  public void deletePost(Long userId, Long challengeId) {
    Post post = postRepository.findById(challengeId)
            .orElseThrow(() -> new CustomException(ExceptionCode.CHALLENGE_NOT_FOUND));

    if (!post.isAuthor(userId)) {
      throw new CustomException(ExceptionCode.PERMISSION_DELETE_COMMENT_DENIED);
    }

    postRepository.delete(post);
  }

  public PostResponse findByPostId(Long postId) {
    Post post = postRepository.findByIdWithComment(postId)
            .orElseThrow(() -> new CustomException(ExceptionCode.POST_NOT_FOUND));

    return PostMapper.INSTANCE.entityToResponse(post);
  }
  
  public ReportResponse reportPost(Long userId, Long postId) {
    Post post = postRepository.findById(postId)
        .orElseThrow(() -> new CustomException(ExceptionCode.POST_NOT_FOUND));
    Long authorId = post.getAuthor().getId();
    List<Long> reportingUser = post.getReport();
    
    if (userId.equals(authorId)) throw new CustomException(ExceptionCode.SAME_REPORTED_USER_ID);
    if (reportingUser.contains(userId)) throw new CustomException(ExceptionCode.ALREADY_REPORTED);
    
    reportingUser.add(userId);
    
    if (reportingUser.size() >= 5) post.rejectCertification();
    postRepository.save(post);
    
    return PostMapper.INSTANCE.postToReportResponse(post);
  }
}
