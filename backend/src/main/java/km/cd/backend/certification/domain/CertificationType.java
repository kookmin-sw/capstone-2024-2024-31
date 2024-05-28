package km.cd.backend.certification.domain;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;

/**
 * 인증 방식을 나타내는 enum class입니다.
 */
public enum CertificationType {
    NONE(),
    HAND_GESTURE(),
    GITHUB_COMMIT();

    @JsonCreator
    public static CertificationType fromCode(String name) {
        return CertificationType.valueOf(name.toUpperCase());
    }

    @JsonValue
    public String toString() {
        return this.name().toLowerCase();
    }

}
