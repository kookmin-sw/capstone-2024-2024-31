package km.cd.backend.common.error;

import lombok.Getter;

@Getter
public class CustomException extends RuntimeException {

    private final ExceptionCode exceptionCode;

    public CustomException(ExceptionCode exceptionCode) {
        this.exceptionCode = exceptionCode;
    }
    
    /**
     * 현재 예외 객체를 반환하도록 하여 스택 트레이스 정보를 채우지 않도록 오버라이드
     * @author sukjuhong
     */
    @Override
    public synchronized Throwable fillInStackTrace() {
        return this;
    }

}
