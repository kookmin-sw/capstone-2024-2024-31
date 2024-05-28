package km.cd.backend.challenge.repository;

import java.util.List;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.dto.request.ChallengeFilter;

public interface ChallengeCustomRepository {

  /**
   * 필터를 통한 챌린지 목록 조회
   * @param cursorId 현재 페이지의 마지막 챌린지 ID
   * @param filter {@see ChallengeFilter} 검색 조건
   * @return 필터링 및 페이징 된 챌린지 목록
   */
  List<Challenge> findByChallengeWithFilterAndPaging(Long cursorId, int size, ChallengeFilter filter);
  
}
