package km.cd.backend.challenge.domain.mapper;

import java.time.LocalDate;
import java.time.format.DateTimeFormatter;
import java.util.List;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.dto.response.ChallengeInformationResponse;
import km.cd.backend.challenge.dto.response.ChallengeSimpleResponse;
import km.cd.backend.challenge.dto.response.ChallengeStatusResponse;
import km.cd.backend.challenge.dto.enums.ChallengeFrequency;
import km.cd.backend.challenge.dto.request.ChallengeCreateRequest;
import km.cd.backend.challenge.dto.response.ParticipantResponse;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.Mappings;
import org.mapstruct.factory.Mappers;

@Mapper
public interface ChallengeMapper {

    ChallengeMapper INSTANCE = Mappers.getMapper(ChallengeMapper.class);


    @Mapping(target = "id", ignore = true)
    @Mapping(target = "participants", ignore = true)
    @Mapping(target = "startDate", expression = "java(parseDateString(request.getStartDate()))")
    @Mapping(target = "endDate", expression = "java(calculateEndDate(parseDateString(request.getStartDate()), request.getChallengePeriod()))")
    @Mapping(target = "challengePeriod", expression = "java(convertNumber(request.getChallengePeriod()))")
    @Mapping(target = "challengeImagePaths", ignore = true)
    @Mapping(target = "successfulVerificationImage", ignore = true)
    @Mapping(target = "failedVerificationImage", ignore = true)
    @Mapping(target = "certificationType", ignore = true)
    @Mapping(target = "status", ignore = true)
    @Mapping(target = "totalParticipants", ignore = true)
    @Mapping(target = "totalCertificationCount", expression = "java(calculateTotalCertificationCount(convertNumber(request.getChallengePeriod()), request.getCertificationFrequency()))")
    Challenge requestToEntity(ChallengeCreateRequest request);
    
    ChallengeInformationResponse challengeToChallengeResponse(Challenge challenge);
    
    @Mapping(target = "currentAchievementRate", expression = "java(getCurrentAchievementRate(numberOfCertifications, challenge.getTotalCertificationCount()))")
    ChallengeStatusResponse toChallengeStatusResponse(Challenge challenge, Long numberOfCertifications, Integer fullAchievementCount, Integer highAchievementCount,Integer lowAchievementCount, Double overallAverageAchievementRate);
    
    @Mappings({
        @Mapping(target = "challengeId", source = "participant.challenge.id"),
        @Mapping(target = "userId", source = "participant.user.id"),
        @Mapping(target = "participantId", source = "participant.id"),
    })
    ParticipantResponse participantToParticipantResponse(Participant participant);
    List<ParticipantResponse> participantListToParticipantResponseList(List<Participant> participants);

    @Mapping(target = "imageUrl", expression = "java(challenge.getChallengeImagePaths().get(0))")
    ChallengeSimpleResponse entityToSimpleResponse(Challenge challenge);
    
    default Double getCurrentAchievementRate(Long numberOfCertifications, int totalCertificationCount){
        if (totalCertificationCount == 0) {
            throw new IllegalArgumentException();
        }
        double rate = (double) numberOfCertifications / totalCertificationCount * 100;
        return Math.round(rate * 10) / 10.0;
    }

    default int calculateTotalCertificationCount(Integer challengePeriod, String certificationFrequency) {
        return challengePeriod * ChallengeFrequency.findByFrequency(certificationFrequency).getDaysPerWeek();
    }
    
    
    default LocalDate parseDateString(String dateString) {
        DateTimeFormatter formatter = DateTimeFormatter.ofPattern("yyyy-MM-dd");
        return LocalDate.parse(dateString, formatter);
    }

    default LocalDate calculateEndDate(LocalDate StartDate, String challengePeriod) {
        int weeks = convertNumber(challengePeriod);
        return StartDate.plusWeeks(weeks);
    }

    default Integer convertNumber(String sentence) {
        return Integer.parseInt(sentence.replaceAll("\\D+", ""));
    }

}

