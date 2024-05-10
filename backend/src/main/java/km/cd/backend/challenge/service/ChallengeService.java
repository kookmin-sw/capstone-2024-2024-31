package km.cd.backend.challenge.service;

import java.time.LocalDateTime;
import java.util.Date;
import java.util.List;

import java.util.Optional;
import km.cd.backend.category.entity.Category;
import km.cd.backend.category.repository.CategoryRepository;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.dto.response.ChallengeInformationResponse;
import km.cd.backend.challenge.dto.request.ChallengeInviteCodeRequest;
import km.cd.backend.challenge.dto.response.ChallengeInviteCodeResponse;
import km.cd.backend.challenge.dto.response.ChallengeSimpleResponse;
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
import km.cd.backend.community.repository.PostRepository;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
    private final CategoryRepository categoryRepository;
    
    final private static String INVITE_LINK_PREFIX = "challengeId=%d";
    
    public Challenge createChallenge(Long userId, ChallengeCreateRequest challengeCreateRequest) {
        User user = validateExistUser(userId);

        // 프론트로부터 넘겨받은 챌린지 데이터
        Challenge challenge = challengeCreateRequest.toEntity(s3Uploader);

        // participant 생성
        Participant creator = new Participant();
        creator.setChallenge(challenge);
        creator.setUser(user);
        creator.setOwner(true);

        // 챌린지 participant에 생성자 추가
        challenge.getParticipants().add(creator);
        challenge.increaseNumOfParticipants();
        
        // category 설정 및 저장
        List<Category> categories = challengeCreateRequest.getCategoriesAsEntities();
        List<Category> savedCategories = categoryRepository.saveAll(categories);
        challenge.setCategories(savedCategories);
        
        // 챌린지 저장
        challengeRepository.save(challenge);

        return challenge;
    }
    
    public void joinChallenge(Long challengeId, Long userId) {
        Challenge challenge =validateExistChallenge(challengeId);
        User user = validateExistUser(userId);
        
        if (challenge.getParticipants().stream().anyMatch(p -> p.getUser().getId().equals(userId))) {
            throw new CustomException(ExceptionCode.ALREADY_JOINED_CHALLENGE);
        }
        Participant participant = new Participant();
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
            joinChallenge(challengeId, userId);
        } else {
            throw new CustomException(ExceptionCode.EXPIRED_INVITE_CODE);
        }
    }
    
    public ChallengeStatusResponse checkChallengeStatus(Long challengeId, Long userId) {
        Challenge challenge = validateExistChallenge(challengeId);

        Long countCertifications = postRepository.countCertification(challengeId, userId);

        return ChallengeMapper.INSTANCE.toChallengeStatusResponse(challenge, countCertifications);
    }

    public List<Challenge> findChallengesByEndDate(Date endDate) {
        return challengeRepository.findByEndDate(endDate);
    }
    
    public void finishChallenge(Challenge challenge) {
        challenge.finishChallenge();
        challengeRepository.save(challenge);
    }

    public ChallengeInformationResponse getChallenge(Long challengeId) {
        Challenge challenge = validateExistChallenge(challengeId);
        return ChallengeMapper.INSTANCE.challengeToChallengeResponse(challenge);
    }

    public List<ChallengeSimpleResponse> getAllChallenge(Long cursorId, ChallengeFilter filter) {
        List<Challenge> challenges = challengeRepository.findByChallengeWithFilterAndPaging(cursorId, filter);

        return challenges.stream().map(challenge -> ChallengeMapper.INSTANCE.entityToSimpleResponse(challenge)).toList();
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
