package km.cd.backend.challenge.dto.enums;

import lombok.Getter;

@Getter
public enum ChallengeFrequency {
  EVERY_WEEKDAY("평일 매일", 5),
  EVERY_WEEKEND("주말 매일", 2),
  EVERY_DAY("매일",7),
  EVERY_WEEK("주 1회",1),
  EVERY_2ND_WEEK("주 2회",2),
  EVERY_3RD_WEEK("주 3회",3),
  EVERY_4TH_WEEK("주 4회",4),
  EVERY_5TH_WEEK("주 5회",5),
  EVERY_6TH_WEEK("주 6회",6);
  
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
