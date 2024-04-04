package km.cd.backend.challenge.service;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.dto.ChallengeReceivedDto;
import km.cd.backend.challenge.dto.ChallengeResponseDto;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.user.User;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class ChallengeService {
    private final ChallengeRepository challengeRepository;

    public ChallengeService(ChallengeRepository challengeRepository) {
        this.challengeRepository = challengeRepository;
    }

    @Transactional
    public ChallengeResponseDto createChallenge(ChallengeReceivedDto challengeReceivedDTO, User user) {
        // 프론트로부터 넘겨받은 챌린지 데이터
        Challenge challenge = challengeReceivedDTO.toEntity();

        // participant 생성
        Participant creator = new Participant();
        creator.setChallenge(challenge);
        creator.setUser(user);
        creator.set_owner(true);

        // 챌린지 participant에 생성자 추가
        challenge.getParticipants().add(creator);

        // 챌린지 저장
        challengeRepository.save(challenge);

        return ChallengeResponseDto.toDto(challenge);
    }

    @Transactional(readOnly = true)
    public ChallengeResponseDto getChallenge(int id) {
        Challenge challenge = challengeRepository.findById(id).orElseThrow();
        return ChallengeResponseDto.toDto(challenge);
    }

    @Transactional
    public void joinChallenge(int challengeId, User user) {
        Challenge challenge = challengeRepository.findById(challengeId).orElseThrow();

        Participant participant = new Participant();
        participant.setChallenge(challenge);
        participant.setUser(user);

        challenge.getParticipants().add(participant);

        challengeRepository.save(challenge);
    }
}
