package km.cd.backend.common.error;

import km.cd.backend.common.jwt.JwtTokenInvalidException;
import km.cd.backend.common.jwt.JwtTokenProvider;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.AccessDeniedException;
import org.springframework.validation.BindingResult;
import org.springframework.validation.FieldError;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.ResponseStatus;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.servlet.NoHandlerFoundException;

/**
 * Controller 단과 Filter 단에서 발생하는 모든 Exception을 Handling 합니다.
 *
 * @author Sukju Hong
 */
@Slf4j
@RestControllerAdvice
public class CustomExceptionHandler {

    @ExceptionHandler(NoHandlerFoundException.class)
    @ResponseStatus(HttpStatus.NOT_FOUND)
    public ResponseEntity<ErrorResponse> handle404(NoHandlerFoundException e) {
        log.error("Handler Not Found Error", e);
        final ErrorResponse errorResponse = ErrorResponse.of(ExceptionCode.NOT_FOUND_ERROR, e.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.NOT_FOUND);
    }

    /**
     * 인가 과정에 대한 ExceptionHandler
     * {@link CustomAccessDeniedHandler}에서
     * {@link org.springframework.web.servlet.HandlerExceptionResolver}에 의해 Error가 넘어옵니다.
     */
    @ExceptionHandler(AccessDeniedException.class)
    public ResponseEntity<ErrorResponse> handleAccessDeniedHandler(final AccessDeniedException e) {
        log.error("Access Denied Error", e);
        final ErrorResponse errorResponse = ErrorResponse.of(ExceptionCode.FORBIDDEN_ERROR, e.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.FORBIDDEN);
    }

    /**
     * 인증 과정에 대한 ExceptionHandler
     * {@link JwtTokenProvider#validateToken(String)}에서 발생한 오류가 try-catch 되어
     * {@link jakarta.servlet.http.HttpServletRequest#setAttribute(String, Object)}로 Exception이 binding 되고,
     * 해당 Exception이 {@link CustomAuthenticationEntryPoint}에서 받아져 {@link org.springframework.web.servlet.HandlerExceptionResolver}에 의해 Error가 넘어옵니다.
     */
    @ExceptionHandler(JwtTokenInvalidException.class)
    public ResponseEntity<ErrorResponse> handlerTokenNotValidateException(final JwtTokenInvalidException e) {
        log.error("JWT Token Invalid Error", e);
        final ErrorResponse errorResponse = ErrorResponse.of(ExceptionCode.UNAUTHORIZED_ERROR, e.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.UNAUTHORIZED);
    }
    
    //비즈니스 로직의 예외처리(Unchecked Exception 발생시 처리)
    @ExceptionHandler(CustomException.class) // 만들어준 커스텀익셉션 발생시 처리해주는 곳
    public ResponseEntity<ErrorResponse> handleCustomException(CustomException ex) {
        log.error("Business Exception Error", ex);
        final ErrorResponse errorResponse = ErrorResponse.of(ex.getExceptionCode(), ex.getMessage());
        return new ResponseEntity<>(errorResponse, HttpStatus.valueOf(errorResponse.getStatus()));
    }
    
    // 여기부턴 클라이언트 측의 잘못된 요청에 의한 에러를 처리해줌.
    @ExceptionHandler(NullPointerException.class) // nullPointerExceptiono발생시
    public ResponseEntity<ErrorResponse> handleNullPointerException(NullPointerException e) {
        log.error("handleNullPointerException", e);
        final ErrorResponse response = ErrorResponse.of(ExceptionCode.NULL_POINT_ERROR, e.getMessage());
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }
    
    // @valid 유효성 검증에 실패했을 경우 발생하는 예외 처리
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public ResponseEntity<ErrorResponse> handleMethodArgumentNotValidException(MethodArgumentNotValidException ex) {
        log.error("handleMethodArgumentNotValidException", ex);
        BindingResult bindingResult = ex.getBindingResult();
        StringBuilder stringBuilder = new StringBuilder();
        for (FieldError fieldError : bindingResult.getFieldErrors()) {
            stringBuilder.append(fieldError.getField()).append(":");
            stringBuilder.append(fieldError.getDefaultMessage());
            stringBuilder.append(", ");
        }
        final ErrorResponse response = ErrorResponse.of(ExceptionCode.NOT_VALID_ERROR, String.valueOf(stringBuilder));
        return new ResponseEntity<>(response, HttpStatus.valueOf(response.getStatus()));
    }

    /**
     * 처리되지 않은 오류가 여기에서 모두 잡힙니다.
     */
    @ExceptionHandler(Exception.class)
    public ResponseEntity<ErrorResponse> handleUnExpectedException(final Exception e) {
        log.error("Unexpected Exception", e);
        final ErrorResponse response = ErrorResponse.of(ExceptionCode.INTERNAL_SERVER_ERROR, e.getMessage());
        return new ResponseEntity<>(response, HttpStatus.INTERNAL_SERVER_ERROR);
    }


}
