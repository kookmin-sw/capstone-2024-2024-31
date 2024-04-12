package km.cd.backend.community.mapper;

import km.cd.backend.community.domain.Comment;
import km.cd.backend.community.dto.CommentResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper
public interface CommentMapper {

    CommentMapper INSTANCE = Mappers.getMapper(CommentMapper.class);

    @Mapping(target = "author", source = "author.name")
    CommentResponse entityToResponse(Comment comment);
}
