package km.cd.backend.challenge.domain.mapper;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.dto.response.ChallengeInformationResponse;
import km.cd.backend.challenge.dto.response.ChallengeStatusResponse;
import km.cd.backend.challenge.dto.enums.ChallengeFrequency;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.factory.Mappers;

@Mapper
public interface ChallengeMapper {
    ChallengeMapper INSTANCE = Mappers.getMapper(ChallengeMapper.class);

    ChallengeInformationResponse challengeToChallengeResponse(Challenge challenge);

    @Mappings({
            @Mapping(target = "id", source = "challenge.id"),
            @Mapping(target = "totalCertificationCount", expression = "java(calculateTotalCertificationCount(challenge.getChallengePeriod(), challenge.getCertificationFrequency()))"),
    })
    ChallengeStatusResponse toChallengeStatusResponseDto(Challenge challenge, Long numberOfCertifications);

    default int calculateTotalCertificationCount(Integer challengePeriod, String certificationFrequency) {
        return challengePeriod * ChallengeFrequency.findByFrequency(certificationFrequency).getDaysPerWeek();
    }
}

