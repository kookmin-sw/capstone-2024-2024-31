package km.cd.backend.common;


import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.CustomExceptionHandler;
import km.cd.backend.common.error.ErrorResponse;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.common.jwt.JwtTokenInvalidException;
import org.junit.jupiter.api.DisplayName;
import org.junit.jupiter.api.Test;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.servlet.NoHandlerFoundException;
import org.springframework.security.access.AccessDeniedException;

import static org.junit.jupiter.api.Assertions.assertEquals;

class CustomExceptionHandlerTest {
    
    private final CustomExceptionHandler exceptionHandler = new CustomExceptionHandler();
    
    @Test
    @DisplayName("404 에러 핸들링")
    void handle404() {
        NoHandlerFoundException exception = new NoHandlerFoundException("GET", "/example", null);
        ResponseEntity<ErrorResponse> responseEntity = exceptionHandler.handle404(exception);
        
        assertEquals(HttpStatus.NOT_FOUND, responseEntity.getStatusCode());
        assertEquals(ExceptionCode.NOT_FOUND_ERROR.getCode(), responseEntity.getBody().getCode());
        assertEquals(ExceptionCode.NOT_FOUND_ERROR.getMessage(), responseEntity.getBody().getMessage());
    }
    
    @Test
    @DisplayName("403 에러 핸들링")
    void handleAccessDeniedException() {
        String message = "이 리소스에 접근할 권한이 없습니다.";
        ResponseEntity<ErrorResponse> responseEntity = exceptionHandler.handleAccessDeniedHandler(new AccessDeniedException(message));
        
        assertEquals(HttpStatus.FORBIDDEN, responseEntity.getStatusCode());
        assertEquals(ExceptionCode.FORBIDDEN_ERROR.getCode(), responseEntity.getBody().getCode());
        assertEquals(message, responseEntity.getBody().getMessage());
    }
    
    @Test
    @DisplayName("401 에러 핸들링")
    void handleJwtTokenInvalidException() {
        String message = "인증되지 않았습니다. 접근 권한이 없습니다.";
        ResponseEntity<ErrorResponse> responseEntity = exceptionHandler.handlerTokenNotValidateException(JwtTokenInvalidException.INSTANCE);
        
        assertEquals(HttpStatus.UNAUTHORIZED, responseEntity.getStatusCode());
        assertEquals(ExceptionCode.UNAUTHORIZED_ERROR.getCode(), responseEntity.getBody().getCode());
        assertEquals(message, responseEntity.getBody().getMessage());
    }
    
    @Test
    @DisplayName("비즈니스 로직 예외 처리 핸들링")
    void handleCustomException() {
        CustomException exception = new CustomException(ExceptionCode.INTERNAL_SERVER_ERROR);
        ResponseEntity<ErrorResponse> responseEntity = exceptionHandler.handleCustomException(exception);
        
        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, responseEntity.getStatusCode());
        assertEquals(ExceptionCode.INTERNAL_SERVER_ERROR.getCode(), responseEntity.getBody().getCode());
        assertEquals(ExceptionCode.INTERNAL_SERVER_ERROR.getMessage(), responseEntity.getBody().getMessage());
    }
    
    @Test
    @DisplayName("NullPointerException 핸들링")
    void handleNullPointerException() {
        NullPointerException exception = new NullPointerException("NullPointerException 발생");
        ResponseEntity<ErrorResponse> responseEntity = exceptionHandler.handleNullPointerException(exception);
        
        assertEquals(HttpStatus.NOT_FOUND, responseEntity.getStatusCode());
        assertEquals(ExceptionCode.NULL_POINT_ERROR.getCode(), responseEntity.getBody().getCode());
        assertEquals(exception.getMessage(), responseEntity.getBody().getMessage());
    }
    
    @Test
    @DisplayName("기타 예외 핸들링")
    void handleUnExpectedException() {
        Exception exception = new Exception("서버 내부 오류가 발생했습니다.");
        ResponseEntity<ErrorResponse> responseEntity = exceptionHandler.handleUnExpectedException(exception);
        
        assertEquals(HttpStatus.INTERNAL_SERVER_ERROR, responseEntity.getStatusCode());
        assertEquals(ExceptionCode.INTERNAL_SERVER_ERROR.getCode(), responseEntity.getBody().getCode());
        assertEquals(exception.getMessage(), responseEntity.getBody().getMessage());
    }
}