package km.cd.backend.challenge.domain;

import km.cd.backend.challenge.dto.ChallengeResponseDto;
import org.mapstruct.Mapper;
import org.mapstruct.factory.Mappers;

@Mapper
public interface ChallengeMapper {
  ChallengeMapper INSTANCE = Mappers.getMapper(ChallengeMapper.class);

  ChallengeResponseDto challengeToChallengeResponse(Challenge challenge);
}
