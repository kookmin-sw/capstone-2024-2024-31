package km.cd.backend.challenge.service;

import java.time.LocalDate;
import java.util.Date;
import java.util.List;
import java.util.NoSuchElementException;
import java.util.Optional;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.mapper.ChallengeMapper;
import km.cd.backend.challenge.domain.Participant;
import km.cd.backend.challenge.dto.CertificationReceivedDto;
import km.cd.backend.challenge.dto.ChallengeReceivedDto;
import km.cd.backend.challenge.dto.ChallengeStatusResponseDto;
import km.cd.backend.challenge.dto.enums.FilePathEnum;
import km.cd.backend.challenge.repository.ChallengeRepository;
import km.cd.backend.challenge.repository.ParticipantRepository;
import km.cd.backend.common.utils.S3Uploader;
import km.cd.backend.user.User;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@AllArgsConstructor
public class ChallengeService {
    
    private final ChallengeRepository challengeRepository;
    
    private final ParticipantRepository participantRepository;
    
    private final S3Uploader s3Uploader;

    @Transactional
    public Challenge createChallenge(ChallengeReceivedDto challengeReceivedDTO, User user) {
        // 프론트로부터 넘겨받은 챌린지 데이터
        Challenge challenge = challengeReceivedDTO.toEntity(s3Uploader);
        
        System.out.println(challenge);
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
    public void joinChallenge(Long challengeId, User user) {
        Challenge challenge = challengeRepository.findById(challengeId).orElseThrow();

        Participant participant = new Participant();
        participant.setChallenge(challenge);
        participant.setUser(user);

        challenge.getParticipants().add(participant);

        challengeRepository.save(challenge);
    }
    
    @Transactional
    public String certificateChallenge(CertificationReceivedDto certificationReceivedDto, User user) {
        Optional<Challenge> foundChallenge = challengeRepository.findById(certificationReceivedDto.getChallengeId());
        if (foundChallenge.isEmpty()) {
            throw new NoSuchElementException("Challenge를 찾을 수 없습니다.");
        }
        
        Challenge challenge = foundChallenge.get();
        Participant participant = participantRepository.findByChallengeAndUser(challenge, user);
        if (participant == null) {
            throw new NoSuchElementException("참가자를 찾을 수 없습니다.");
        }
        
        MultipartFile certificationImage = certificationReceivedDto.getCertificationImage();
        if (certificationImage == null || certificationImage.isEmpty()) {
            throw new IllegalArgumentException("인증 이미지를 제대로 입력하세요.");
        }
        
        String certificationImageUrl = s3Uploader.uploadFileToS3(certificationImage, FilePathEnum.PARTICIPANTS.getPath());
        participant.getCertificationImages().put(LocalDate.now(), certificationImageUrl);
        participant.increaseNumOfCertifications();
        
        return "성공";
    }
    
    @Transactional
    public ChallengeStatusResponseDto checkChallengeStatus(Long challenge_id, User user) {
        Challenge challenge = challengeRepository.findById(challenge_id).orElseThrow();
        Participant participant = participantRepository.findByChallengeAndUser(challenge, user);
        
        return ChallengeMapper.INSTANCE.toChallengeStatusResponseDto(challenge, participant);
    }
    @Transactional
    public List<Challenge> findChallengesByEndDate(Date endDate) {
        return challengeRepository.findByEndDate(endDate);
    }
    
    @Transactional
    public void finishChallenge(Challenge challenge) {
        challenge.setIsEnded(true);
        challengeRepository.save(challenge);
    }
}
