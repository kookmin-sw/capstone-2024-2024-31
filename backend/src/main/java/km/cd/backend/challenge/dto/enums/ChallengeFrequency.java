package km.cd.backend.challenge.dto.enums;

import lombok.Getter;

@Getter
public enum ChallengeFrequency {
  EVERY_DAY("매일", 7),
  EVERY_WEEKDAY("평일매일", 5),
  EVERY_WEEKEND("주말매일", 2),
  WEEKDAYS("평일",5),
  EVERY_WEEK("주1일",1),
  EVERY_2ND_WEEK("주2일",2),
  EVERY_3RD_WEEK("주3일",3),
  EVERY_4TH_WEEK("주4일",4),
  EVERY_5TH_WEEK("주5일",5),
  EVERY_6TH_WEEK("주6일",6);

  private final String frequency;
  private final int daysPerWeek;

  ChallengeFrequency(String frequency, int daysPerWeek) {
    this.frequency = frequency;
    this.daysPerWeek = daysPerWeek;
  }
  
  public static ChallengeFrequency findByFrequency(String frequency) {
    for (ChallengeFrequency challengeFrequency : ChallengeFrequency.values()) {
      if (challengeFrequency.frequency.equals(frequency)) {
        return challengeFrequency;
      }
    }
    
    throw new IllegalArgumentException("No enum constant with frequency: " + frequency);
  }
}
