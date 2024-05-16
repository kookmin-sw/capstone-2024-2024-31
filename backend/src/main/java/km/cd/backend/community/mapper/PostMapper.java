package km.cd.backend.community.mapper;

import java.util.ArrayList;
import java.util.List;
import java.util.stream.Collectors;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.community.dto.CommentResponse;
import km.cd.backend.community.dto.PostRequest;
import km.cd.backend.community.dto.PostDetailResponse;
import km.cd.backend.community.dto.PostSimpleResponse;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.domain.mapper.UserMapper;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.factory.Mappers;

import km.cd.backend.community.domain.Comment;
import km.cd.backend.community.domain.Post;

@Mapper
public interface PostMapper {

  PostMapper INSTANCE = Mappers.getMapper(PostMapper.class);

  String CONTENT_DELETE = "삭제된 댓글입니다.";

  @Mapping(target = "comments", source = "comments", qualifiedByName = "mapComments")
  PostDetailResponse entityToDetailResponse(Post post);

  @Mapping(target = "author", source = "user")
  Post requestToEntity(PostRequest postRequest, User user, Challenge challenge);

  @Named("mapComments")
  default List<CommentResponse> mapComments(List<Comment> comments) {
    return comments.stream()
        .filter(comment -> !comment.hasParent())
        .map(comment -> new CommentResponse(
            comment.getId(),
            comment.getAuthor().getName(),
            comment.isDeleted() ? CONTENT_DELETE : comment.getContent(),
            CommentMapper.INSTANCE.COMMENT_RESPONSE_LIST(comment.getChildren()),
            UserMapper.INSTANCE.userToUserResponse(comment.getAuthor())))
        .collect(Collectors.toList());
  }

  @Mapping(target = "author", source = "post.author.name")
  PostSimpleResponse entityToSimpleResponse(Post post);
}
