package km.cd.backend.user.domain.mapper;

import java.util.ArrayList;
import java.util.List;
import km.cd.backend.user.domain.Friend;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.dto.FriendListResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Named;
import org.mapstruct.control.MappingControl.Use;
import org.mapstruct.factory.Mappers;

@Mapper
public interface FriendMapper {
    
    FriendMapper INSTANCE = Mappers.getMapper(FriendMapper.class);
    
    @Mapping(source = "friend.id", target = "friendId")
    @Mapping(target = "friendEmail", expression = "java(isFromUser ? friend.getFriendEmail() : friend.getMyEmail())")
    FriendListResponse FRIEND_LIST_RESPONSE(Friend friend, boolean isFromUser);
    
    @Named("mapFriendListResponse")
    default ArrayList<FriendListResponse> FRIEND_LIST_RESPONSE_LIST(List<Friend> friendList, boolean isFromUser) {
        ArrayList<FriendListResponse> resultList = new ArrayList<>();
        for (Friend friend : friendList) {
            resultList.add(FRIEND_LIST_RESPONSE(friend, isFromUser));
        }
        return resultList;
    }
}

