package km.cd.backend.challenge.certification.domain;

import com.fasterxml.jackson.annotation.JsonCreator;
import com.fasterxml.jackson.annotation.JsonValue;
import km.cd.backend.challenge.certification.strategy.CertificationStrategy;
import km.cd.backend.challenge.certification.strategy.GestureRecognitionCertificationStrategy;

/**
 * 인증 방식을 나타내는 enum class입니다.
 * {@link CertificationStrategy} 인증 전략을 가지고 있어 각기 다른 인증 방식을 채택할 수 있습니다.
 * 인증 전략은 자주 사용될 것으로 예측되어 싱글톤 처리했습니다.
 */
public enum CertificationType {
    GESTURE_RECOGNITION(GestureRecognitionCertificationStrategy.getInstance());

    public final CertificationStrategy strategy;

    CertificationType(CertificationStrategy strategy) {
        this.strategy = strategy;
    }

    /**
     * enum 값을 request로 받기 위해 구현한 함수
     * @param name enum class의 소문자 이름
     * @return name에 대문자에 해당하는 {@link CertificationStrategy} class의 인스턴스가 나옵니다.
     * 예를들어, {@link org.springframework.web.bind.annotation.RequestBody}를 통해 type을 "gesture_recognition"이란 값을 받았다면 UpperCase 처리되어 GESTURE_RECOGNITION 으로 튀어나오게 됩니다.
     */
    @JsonCreator
    public static CertificationType fromCode(String name) {
        return CertificationType.valueOf(name.toUpperCase());
    }

    @JsonValue
    public String toString() {
        return this.name().toLowerCase();
    }

}
