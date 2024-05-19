package km.cd.backend.user.domain.mapper;

import java.util.List;
import java.util.Set;
import java.util.stream.Collectors;
import km.cd.backend.challenge.domain.ChallengeCategory;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.dto.FriendListResponse;
import km.cd.backend.user.dto.UserDetailResponse;
import km.cd.backend.user.dto.UserResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper
public interface UserMapper {

    UserMapper INSTANCE = Mappers.getMapper(UserMapper.class);

    UserResponse userToUserResponse(User user);
    
    @Mapping(source = "user.categories", target = "categories")
    UserDetailResponse userToUserDetailResponse(User user, List<FriendListResponse> following, List<FriendListResponse> follower);
    
    default List<String> mapCategories(Set<ChallengeCategory> categories) {
        return categories.stream()
            .map(ChallengeCategory::getName)
            .collect(Collectors.toList());
    }
}
