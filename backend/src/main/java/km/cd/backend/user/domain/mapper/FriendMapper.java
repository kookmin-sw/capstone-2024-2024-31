package km.cd.backend.user.domain.mapper;

import km.cd.backend.user.domain.Friend;
import km.cd.backend.user.dto.FriendListResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.factory.Mappers;

@Mapper
public interface FriendMapper {
    
    FriendMapper INSTANCE = Mappers.getMapper(FriendMapper.class);
    
    @Mapping(source = "friend.id", target = "friendId")
    @Mapping(target = "friendEmail", expression = "java(isFromUser ? friend.getFriendEmail() : friend.getMyEmail())")
    @Mapping(source = "friendImage", target = "friendImage")
    FriendListResponse FRIEND_LIST_RESPONSE(Friend friend, boolean isFromUser, String friendImage);
}

