package km.cd.backend.challenge.dto.enums;

import lombok.Getter;

@Getter
public enum FilePathEnum {
  CHALLENGES("challenges"),
  PARTICIPANTS("participants"),
  USER("user"),
  COMMUNITY("community");
  
  private final String path;
  
  FilePathEnum(String path) {
    this.path = path;
  }
}
