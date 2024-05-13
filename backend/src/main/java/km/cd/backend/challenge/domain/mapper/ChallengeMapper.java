package km.cd.backend.challenge.domain.mapper;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import km.cd.backend.certification.domain.CertificationType;
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
    @Mapping(target = "isEnded", ignore = true)
    @Mapping(target = "totalParticipants", ignore = true)
    @Mapping(target = "totalCertificationCount", expression = "java(calculateTotalCertificationCount(convertNumber(request.getChallengePeriod()), request.getCertificationFrequency()))")
    Challenge requestToEntity(ChallengeCreateRequest request);
    
    ChallengeInformationResponse challengeToChallengeResponse(Challenge challenge);
    
    ChallengeStatusResponse toChallengeStatusResponse(Challenge challenge, Long numberOfCertifications);
    
    @Mappings({
        @Mapping(target = "challengeId", source = "participant.challenge.id"),
        @Mapping(target = "userId", source = "participant.user.id"),
        @Mapping(target = "participantId", source = "participant.id"),
    })
    ParticipantResponse participantToParticipantResponse(Participant participant);
    List<ParticipantResponse> participantListToParticipantResponseList(List<Participant> participants);

    @Mapping(target = "imageUrl", expression = "java(challenge.getChallengeImagePaths().get(0))")
    ChallengeSimpleResponse entityToSimpleResponse(Challenge challenge);

    default int calculateTotalCertificationCount(Integer challengePeriod, String certificationFrequency) {
        return challengePeriod * ChallengeFrequency.findByFrequency(certificationFrequency).getDaysPerWeek();
    }


    default Date parseDateString(String dateString) {
        SimpleDateFormat simpleDateFormat = new SimpleDateFormat("yyyy-MM-dd");
        try {
            return simpleDateFormat.parse(dateString);
        } catch (ParseException e) {
            return null;
        }
    }

    default Date calculateEndDate(Date StartDate, String challengePeriod) {
        int weeks = convertNumber(challengePeriod);

        Calendar calendar = Calendar.getInstance();
        calendar.setTime(StartDate);
        calendar.add(Calendar.WEEK_OF_YEAR, weeks);

        return calendar.getTime();
    }

    default Integer convertNumber(String sentence) {
        return Integer.parseInt(sentence.replaceAll("\\D+", ""));
    }

}

