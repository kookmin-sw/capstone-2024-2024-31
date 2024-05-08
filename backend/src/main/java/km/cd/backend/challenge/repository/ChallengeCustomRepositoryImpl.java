package km.cd.backend.challenge.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.PageImpl;
import org.springframework.data.domain.PageRequest;
import org.springframework.data.domain.Pageable;
import org.springframework.stereotype.Repository;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQuery;
import com.querydsl.jpa.impl.JPAQueryFactory;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.QChallenge;
import km.cd.backend.challenge.dto.request.ChallengeFilter;
import km.cd.backend.challenge.dto.response.ChallengeInformationResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;

@Repository
@RequiredArgsConstructor
public class ChallengeCustomRepositoryImpl implements ChallengeCustomRepository {

  private final JPAQueryFactory queryFactory;

  private static final int DEFAULT_PAGE_SIZE = 10;

  @Override
  public List<Challenge> findByChallengeWithFilterAndPaging(Long cursorId, ChallengeFilter filter) {
    QChallenge challenge = QChallenge.challenge;
    BooleanExpression predicate = challenge.isNotNull();

    if (cursorId != 0) {
      predicate = challenge.id.lt(cursorId);
    }

    if (StringUtils.hasText(filter.name())) {
      predicate = challenge.challengeName.startsWith(filter.name());
    }

    predicate = predicate.and(challenge.isPrivate.eq(filter.isPrivate()));

    if (filter.category() != null) {
      predicate = predicate.and(challenge.category.eq(filter.category()));
    }

    return queryFactory
      .selectFrom(challenge)
      .where(predicate)
      .limit(DEFAULT_PAGE_SIZE)
      .fetch();
  }
  
}
