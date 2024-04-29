package km.cd.backend.challenge.domain.mapper;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.dto.ChallengeResponseDto;
import km.cd.backend.challenge.dto.ChallengeStatusResponseDto;
import km.cd.backend.challenge.dto.enums.ChallengeFrequency;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.factory.Mappers;

@Mapper
public interface ChallengeMapper {
    ChallengeMapper INSTANCE = Mappers.getMapper(ChallengeMapper.class);

    ChallengeResponseDto challengeToChallengeResponse(Challenge challenge);

    @Mappings({
            @Mapping(target = "id", source = "challenge.id"),
            @Mapping(target = "totalCertificationCount", expression = "java(calculateTotalCertificationCount(challenge.getChallengePeriod(), challenge.getCertificationFrequency()))"),
    })
    ChallengeStatusResponseDto toChallengeStatusResponseDto(Challenge challenge, Long numberOfCertifications);

    default int calculateTotalCertificationCount(Integer challengePeriod, String certificationFrequency) {
        return challengePeriod * ChallengeFrequency.findByFrequency(certificationFrequency).getDaysPerWeek();
    }
}

