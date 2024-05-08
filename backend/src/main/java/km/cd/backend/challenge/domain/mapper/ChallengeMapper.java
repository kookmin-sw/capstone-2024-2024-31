package km.cd.backend.challenge.domain.mapper;

import java.util.List;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.dto.response.ChallengeInformationResponse;
import km.cd.backend.challenge.dto.response.ChallengeSimpleResponse;
import km.cd.backend.challenge.dto.response.ChallengeStatusResponse;
import km.cd.backend.challenge.dto.enums.ChallengeFrequency;
import km.cd.backend.challenge.dto.response.ParticipantResponse;
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
    ChallengeStatusResponse toChallengeStatusResponse(Challenge challenge, Long numberOfCertifications);
    
    @Mappings({
        @Mapping(target = "challengeId", source = "participant.challenge.id"),
        @Mapping(target = "userId", source = "participant.user.id"),
        @Mapping(target = "participantId", source = "participant.id"),
    })
    ParticipantResponse participantToParticipantResponse(Participant participant);
    List<ParticipantResponse> participantListToParticipantResponseList(List<Participant> participants);

    default int calculateTotalCertificationCount(Integer challengePeriod, String certificationFrequency) {
        return challengePeriod * ChallengeFrequency.findByFrequency(certificationFrequency).getDaysPerWeek();
    }
 
    ChallengeSimpleResponse entityToSimpleResponse(Challenge challenge);
}

