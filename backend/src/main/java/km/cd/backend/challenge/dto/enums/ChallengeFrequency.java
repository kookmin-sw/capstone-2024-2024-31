package km.cd.backend.challenge.dto.enums;

import lombok.Getter;

@Getter
public enum ChallengeFrequency {
  EVERY_WEEKDAY("평일매일"),
  EVERY_WEEKEND("주말매일"),
  WEEKDAYS("평일"),
  EVERY_WEEK("주1일"),
  EVERY_2ND_WEEK("주2일"),
  EVERY_3RD_WEEK("주3일"),
  EVERY_4TH_WEEK("주4일"),
  EVERY_5TH_WEEK("주5일"),
  EVERY_6TH_WEEK("주6일");

  private final String frequency;

  ChallengeFrequency(String frequency) {
    this.frequency = frequency;
  }
}
