package km.cd.backend.community.mapper;

import java.util.List;
import km.cd.backend.community.domain.Comment;
import km.cd.backend.community.dto.CommentResponse;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.domain.mapper.UserMapper;
import km.cd.backend.user.dto.UserResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper
public interface CommentMapper {

    CommentMapper INSTANCE = Mappers.getMapper(CommentMapper.class);

    @Mapping(target = "parentId", source = "parent.id")
    @Mapping(target = "author", source = "author.name")
    @Mapping(target = "avatar", source = "author.avatar")
    CommentResponse entityToResponse(Comment comment);
}
