package km.cd.backend.challenge.repository;

import java.util.List;

import org.springframework.stereotype.Repository;

import com.querydsl.core.types.dsl.BooleanExpression;
import com.querydsl.jpa.impl.JPAQueryFactory;

import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.challenge.domain.QChallenge;
import km.cd.backend.challenge.dto.request.ChallengeFilter;
import lombok.RequiredArgsConstructor;
import org.springframework.util.StringUtils;

@Repository
@RequiredArgsConstructor
public class ChallengeCustomRepositoryImpl implements ChallengeCustomRepository {

    private final JPAQueryFactory queryFactory;

    @Override
    public List<Challenge> findByChallengeWithFilterAndPaging(Long cursorId, int size, ChallengeFilter filter) {
        QChallenge challenge = QChallenge.challenge;
        BooleanExpression predicate = challenge.isNotNull();

        if (cursorId != 0) {
            predicate = challenge.id.lt(cursorId);
        }

        if (StringUtils.hasText(filter.name())) {
            predicate = challenge.challengeName.startsWith(filter.name());
        }

        if (filter.isPrivate() != null) {
            predicate = predicate.and(challenge.isPrivate.eq(filter.isPrivate()));
        }

        if (filter.category() != null) {
            predicate = predicate.and(challenge.challengeCategory.eq(filter.category()));
        }

        return queryFactory
                .selectFrom(challenge)
                .where(predicate)
                .limit(size)
                .orderBy(challenge.id.desc())
                .fetch();
    }

}
