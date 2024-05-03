package km.cd.backend.challenge.domain;

import com.fasterxml.jackson.annotation.JsonCreator;

import lombok.AllArgsConstructor;

@AllArgsConstructor
public enum ChallengeCategory {
  EXCERCISE("운동"),
  EATING("식습관"),
  HOBBY("취미"),
  NATURE("환경"),
  STUDY("공부");

  String name;

}
