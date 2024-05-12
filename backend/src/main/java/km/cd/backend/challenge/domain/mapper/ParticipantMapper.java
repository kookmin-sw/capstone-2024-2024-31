package km.cd.backend.challenge.domain.mapper;

import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.dto.request.ChallengeJoinRequest;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper
public interface ParticipantMapper {
    ParticipantMapper INSTANCE = Mappers.getMapper(ParticipantMapper.class);
    
    Participant ChallengeJoinRequestToParticipant(ChallengeJoinRequest challengeJoinRequest);
}
