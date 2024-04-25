package km.cd.backend.challenge.dto.enums;

import lombok.Getter;

@Getter
public enum FilePathEnum {
  CHALLENGES("challenges"),
  PARTICIPANTS("participants"),
  COMMUNITY("community");
  
  private final String path;
  
  FilePathEnum(String path) {
    this.path = path;
  }
}
