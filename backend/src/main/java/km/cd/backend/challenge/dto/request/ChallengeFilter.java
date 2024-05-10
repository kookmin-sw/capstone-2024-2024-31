package km.cd.backend.challenge.dto.request;

import km.cd.backend.challenge.domain.ChallengeCategory;

public record ChallengeFilter(
  String name,
  boolean isPrivate,
  ChallengeCategory category
) {}
