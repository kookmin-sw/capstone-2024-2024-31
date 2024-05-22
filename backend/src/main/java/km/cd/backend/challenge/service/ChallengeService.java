package km.cd.backend.challenge.service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;

import java.util.Optional;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.domain.mapper.ParticipantMapper;
import km.cd.backend.challenge.dto.enums.ChallengeStatus;
import km.cd.backend.challenge.dto.request.ChallengeJoinRequest;
import km.cd.backend.challenge.dto.response.ChallengeInformationResponse;
import km.cd.backend.challenge.dto.request.ChallengeInviteCodeRequest;
import km.cd.backend.challenge.dto.response.ChallengeInviteCodeResponse;
import km.cd.backend.challenge.dto.response.ChallengeSimpleResponse;
import km.cd.backend.challenge.dto.enums.FilePathEnum;
import km.cd.backend.challenge.dto.request.ChallengeCreateRequest;
import km.cd.backend.challenge.dto.request.ChallengeFilter;
import km.cd.backend.challenge.dto.response.ChallengeStatusResponse;
import km.cd.backend.challenge.dto.response.ParticipantResponse;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.challenge.repository.ParticipantRepository;
import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.common.utils.RandomUtil;
import km.cd.backend.common.utils.redis.RedisUtil;
import km.cd.backend.common.utils.s3.S3Uploader;
import km.cd.backend.common.utils.sms.SmsUtil;
import km.cd.backend.community.repository.PostRepository;
import km.cd.backend.user.domain.User;
import km.cd.backend.user.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Slf4j
@Service
@RequiredArgsConstructor
@Transactional
public class ChallengeService {

    private final UserRepository userRepository;
    private final ChallengeRepository challengeRepository;
    private final ParticipantRepository participantRepository;
    private final PostRepository postRepository;
    private final S3Uploader s3Uploader;
    private final RedisUtil redisUtil;
    private final SmsUtil smsUtil;
    
    final private static String INVITE_LINK_PREFIX = "challengeId=%d";
    
    public Challenge createChallenge(
        Long userId, ChallengeCreateRequest challengeCreateRequest,
        List<MultipartFile> images,
        MultipartFile successfulVerificationImage,
        MultipartFile failedVerificationImage) {
        User user = validateExistUser(userId);

        // 프론트로부터 넘겨받은 챌린지 데이터
        Challenge challenge = ChallengeMapper.INSTANCE.requestToEntity(challengeCreateRequest);
        
        // 챌린지 상태 설정
        boolean isProgress = challenge.getStartDate().isEqual(LocalDate.now()) || challenge.getStartDate().isBefore(LocalDate.now());
        challenge.setStatus(
            isProgress ?
                ChallengeStatus.IN_PROGRESS.getDescription() :
                ChallengeStatus.NOT_STARTED.getDescription()
        );

        // participant 생성
        Participant creator = new Participant();
        creator.setChallenge(challenge);
        creator.setUser(user);
        creator.setOwner(true);

        // 챌린지 participant에 생성자 추가
        challenge.getParticipants().add(creator);

        // 챌린지 이미지 업로드
        List<String> imagePaths = images.stream().map(
            image -> s3Uploader.uploadFileToS3(image, FilePathEnum.CHALLENGES.getPath())
            ).toList();
        challenge.setChallengeImagePaths(imagePaths);
        
        // 인증 성공 이미지 업로드
        String successImagePath = s3Uploader.uploadFileToS3(successfulVerificationImage, FilePathEnum.CHALLENGES.getPath());
        challenge.setSuccessfulVerificationImage(successImagePath);

        // 인증 실패 이미지 업로드
        String failImagePath = s3Uploader.uploadFileToS3(failedVerificationImage, FilePathEnum.CHALLENGES.getPath());
        challenge.setFailedVerificationImage(failImagePath);

        return challengeRepository.save(challenge);
    }
    
    public void joinChallenge(Long challengeId, Long userId, ChallengeJoinRequest challengeJoinRequest) {
        Challenge challenge =validateExistChallenge(challengeId);
        User user = validateExistUser(userId);
        
        if (challenge.getParticipants().stream().anyMatch(p -> p.getUser().getId().equals(userId))) {
            throw new CustomException(ExceptionCode.ALREADY_JOINED_CHALLENGE);
        }
        
        Participant participant;
        if (challengeJoinRequest != null){
            participant = ParticipantMapper.INSTANCE.ChallengeJoinRequestToParticipant(challengeJoinRequest);
        } else {
            participant = new Participant();
        }
        
        // 참여 설정
        participant.setChallenge(challenge);
        participant.setUser(user);
        
        challenge.getParticipants().add(participant);

        challengeRepository.save(challenge);
    }
    
    public void joinChallengeByInviteCode(Long challengeId, Long userId, ChallengeInviteCodeRequest request) {
        validateExistChallenge(challengeId);

        Optional<String> link = redisUtil.getData(INVITE_LINK_PREFIX.formatted(challengeId), String.class);
        if (link.isPresent()) {
            validateMatchLink(link.get(), request.code());
            joinChallenge(challengeId, userId, null);
        } else {
            throw new CustomException(ExceptionCode.EXPIRED_INVITE_CODE);
        }
    }
    
    public ChallengeStatusResponse checkChallengeStatus(Long challengeId, Long userId) {
        Challenge challenge = validateExistChallenge(challengeId);
        List<Participant> participants = challenge.getParticipants();
        Long countCertifications = postRepository.countCertification(challengeId, userId);
        
        int fullAchievementCount = 0;
        int highAchievementCount = 0;
        int lowAchievementCount = 0;
        int overallAverageAchievement = 0;
        
        for (Participant participant : participants) {
            Long participantUserId = participant.getUser().getId();
            Long counts = postRepository.countCertification(challengeId, participantUserId);
            double percentage = (double) counts / challenge.getTotalCertificationCount() * 100;
            
            if (percentage == 100.0) {
                fullAchievementCount += 1;
            } else if (percentage >= 80.0) {
                highAchievementCount += 1;
            } else {
                lowAchievementCount += 1;
            }
            
            if (willAchieveTarget(challenge, countCertifications)) {
                overallAverageAchievement += 1;
            }
        }
        double overallAverageAchievementRate = (double) overallAverageAchievement / participants.size() * 100;
        overallAverageAchievementRate = Math.ceil(overallAverageAchievementRate * 10) / 10.0;

        return ChallengeMapper.INSTANCE.toChallengeStatusResponse(
            challenge,
            countCertifications,
            fullAchievementCount,
            highAchievementCount,
            lowAchievementCount,
            overallAverageAchievementRate
        );
    }
    
    private boolean willAchieveTarget(Challenge challenge, Long countCertifications) {
        int requiredCount = (int) Math.ceil((90.0 / 100) * challenge.getTotalCertificationCount());
        int challengeFrequency = challenge.getTotalCertificationCount() / challenge.getChallengePeriod();
        int futureCount = countCertifications.intValue() + (challengeFrequency * calculateRemainingWeeks(challenge.getEndDate()));
        return futureCount >= requiredCount;
    }
    
    private int calculateRemainingWeeks(LocalDate endDate) {
        LocalDate currentDate = LocalDate.now();
        if (currentDate.isAfter(endDate)) {
            return 0;
        }
        return (int) ChronoUnit.WEEKS.between(currentDate, endDate);
    }
    public void finishChallenge(Challenge challenge) {
        // 참여자 성공/실패 결과 전송
        Integer totalCount = challenge.getTotalCertificationCount();
        List<Participant> participants = challenge.getParticipants();
        for (Participant participant: participants) {
            Long countCertifications = postRepository.countCertification(challenge.getId(), participant.getId());
            boolean isSuccess = isOverNinetyPercent(totalCount, countCertifications);
            
            distributeRewards(isSuccess, countCertifications, participant.getUser());
            smsUtil.sendResult(participant, challenge.getChallengeName(), participant.getUser().getName(), isSuccess);
        }
        
        // 챌린지 상태 변경
        challenge.setStatus(ChallengeStatus.COMPLETED.getDescription());
        challengeRepository.save(challenge);
    }
    
    public void startChallenge(Challenge challenge) {
        challenge.setStatus(ChallengeStatus.IN_PROGRESS.getDescription());
        challengeRepository.save(challenge);
    }
    private void distributeRewards(boolean isSuccess, Long countCertifications, User user) {
        if (isSuccess) {
            int challengePoint = (int) (countCertifications * 10);
            user.setPoint(user.getPoint() + challengePoint);
            userRepository.save(user);
        }
    }
    private boolean isOverNinetyPercent(Integer totalCount, Long countCertifications) {
        double ratio = (double) countCertifications / totalCount;
        return ratio >= 0.9;
    }
    
    public ChallengeInformationResponse getChallenge(Long challengeId, Long userId, String code) {
        Challenge challenge = validateExistChallenge(challengeId);
        
        Participant participant = participantRepository.findByChallengeIdAndUserId(challengeId, userId)
            .orElse(null);

        if (participant == null) {
            if (challenge.getIsPrivate() && !challenge.getPrivateCode().equals(code)) {
                throw new CustomException(ExceptionCode.FORBIDDEN_ERROR);
            }
        }
        
        // 5. 도전 과제 정보를 응답으로 반환합니다.
        return ChallengeMapper.INSTANCE.challengeToChallengeResponse(challenge);
    }
    

    public List<ChallengeSimpleResponse> getAllChallenge(Long cursorId, int size, ChallengeFilter filter) {
        List<Challenge> challenges = challengeRepository.findByChallengeWithFilterAndPaging(cursorId, size, filter);

        return challenges.stream().map(ChallengeMapper.INSTANCE::entityToSimpleResponse).toList();
    }

    public List<ParticipantResponse> getParticipant(Long challengeId) {
        Challenge challenge = validateExistChallenge(challengeId);
        return ChallengeMapper.INSTANCE.participantListToParticipantResponseList(challenge.getParticipants());
    }

    public void leaveChallenge(Long userId, Long challengeId) {
        Participant participant = participantRepository.findByChallengeIdAndUserId(challengeId, userId)
                .orElseThrow(() -> new CustomException(ExceptionCode.PARTICIPANT_NOT_FOUND_ERROR));

        participantRepository.delete(participant);
    }
    
    public ChallengeInviteCodeResponse generateChallengeInviteCode(final Long challengeId) {
        validateExistChallenge(challengeId);
        final Optional<String> link = redisUtil.getData(INVITE_LINK_PREFIX.formatted(challengeId), String.class);
        if (link.isEmpty()) {
            final String randomCode = RandomUtil.generateRandomCode('0', 'z', 10);
            redisUtil.setDataExpire(INVITE_LINK_PREFIX.formatted(challengeId), randomCode, RedisUtil.toTomorrow());
            return new ChallengeInviteCodeResponse(randomCode, redisUtil.getTTL(INVITE_LINK_PREFIX.formatted(challengeId)));
        }
        
        return new ChallengeInviteCodeResponse(link.get(), redisUtil.getTTL(INVITE_LINK_PREFIX.formatted(challengeId)));
    }
    
    public void validateMatchLink(String link, String inviteCode) {
        if (!link.equals(inviteCode)) {
            throw new CustomException(ExceptionCode.INVALID_INVITE_CODE);
        }
    }
    
    public Challenge validateExistChallenge(Long challengeId) {
        return challengeRepository.findById(challengeId)
            .orElseThrow(() -> new CustomException(ExceptionCode.CHALLENGE_NOT_FOUND));
    }
    
    public User validateExistUser(Long userId) {
        return userRepository.findById(userId)
            .orElseThrow(() -> new CustomException(ExceptionCode.USER_NOT_FOUND));
    }
    
}
