package km.cd.backend.challenge.service;

import java.util.Date;
import java.util.List;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.dto.ChallengeReceivedDto;
import km.cd.backend.challenge.dto.ChallengeResponseDto;
import km.cd.backend.challenge.dto.ChallengeStatusResponseDto;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.challenge.repository.ParticipantRepository;
import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.utils.S3Uploader;
import km.cd.backend.community.repository.PostRepository;
import km.cd.backend.user.User;
import km.cd.backend.user.UserRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class ChallengeService {

    private final UserRepository userRepository;
    private final ChallengeRepository challengeRepository;
    private final ParticipantRepository participantRepository;
    private final PostRepository postRepository;
    private final S3Uploader s3Uploader;

    @Transactional
    public Challenge createChallenge(Long userId, ChallengeReceivedDto challengeReceivedDTO) {
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(400, "User not found."));

        // 프론트로부터 넘겨받은 챌린지 데이터
        Challenge challenge = challengeReceivedDTO.toEntity(s3Uploader);

        // participant 생성
        Participant creator = new Participant();
        creator.setChallenge(challenge);
        creator.setUser(user);
        creator.setOwner(true);

        // 챌린지 participant에 생성자 추가
        challenge.getParticipants().add(creator);
        challenge.increaseNumOfParticipants();
        
        // 챌린지 저장
        challengeRepository.save(challenge);

        return challenge;
    }

    @Transactional
    public void joinChallenge(Long challengeId, Long userId) {
        Challenge challenge = challengeRepository.findById(challengeId)
                .orElseThrow(() -> new CustomException(400, "Challenge not found."));
        User user = userRepository.findById(userId)
                .orElseThrow(() -> new CustomException(400, "User not found."));

        Participant participant = new Participant();
        participant.setChallenge(challenge);
        participant.setUser(user);

        challenge.getParticipants().add(participant);

        challengeRepository.save(challenge);
    }

    public ChallengeStatusResponseDto checkChallengeStatus(Long challengeId, Long userId) {
        Challenge challenge = challengeRepository.findById(challengeId)
                .orElseThrow(() -> new CustomException(400, "Challenge not found."));

        Long countCertifications = postRepository.countCertification(challengeId, userId);

        return ChallengeMapper.INSTANCE.toChallengeStatusResponseDto(challenge, countCertifications);
    }

    public List<Challenge> findChallengesByEndDate(Date endDate) {
        return challengeRepository.findByEndDate(endDate);
    }

    @Transactional
    public void finishChallenge(Challenge challenge) {
        challenge.finishChallenge();
        challengeRepository.save(challenge);
    }

    public ChallengeResponseDto getChallenge(Long challengeId) {
        Challenge challenge = challengeRepository.findById(challengeId)
                .orElseThrow(() -> new CustomException(400, "Challenge not found."));

        return ChallengeMapper.INSTANCE.challengeToChallengeResponse(challenge);
    }

    public void leaveChallenge(Long userId, Long challengeId) {
        Participant participant = participantRepository.findByChallengeIdAndUserId(challengeId, userId)
                .orElseThrow(() -> new CustomException(400, "Participant not found."));

        participantRepository.delete(participant);
    }
}
