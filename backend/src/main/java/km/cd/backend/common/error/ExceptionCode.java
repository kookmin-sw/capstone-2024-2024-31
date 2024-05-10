package km.cd.backend.common.error;

import lombok.Getter;

@Getter
public enum ExceptionCode { // 예외 발생시, body에 실어 날려줄 상태, code, message 커스텀
    
    CHALLENGE_NOT_FOUND(404,"CHALLENGE_001", "해당되는 id 의 챌린지를 찾을 수 없습니다."),
    ALREADY_JOINED_CHALLENGE(404, "CHALLENGE_002", "이미 챌린지에 가입되어 있습니다."),
    
    PARTICIPANT_NOT_FOUND_ERROR(404, "PARTICIPANT_001", "해당되는 참가자를 찾을 수 없습니다."),
    
    POST_NOT_FOUND(404, "POST_001", "해당되는 id 의 글을 찾을 수 없습니다."),
    
    REPLY_NOT_FOUND(404, "COMMENT_001", "해당되는 id의 댓글을 찾을 수 없습니다."),
    PARENT_COMMENT_NOT_FOUND(400, "COMMENT_002", "상위 댓글을 찾을 수 없습니다."),
    PERMISSION_UPDATE_COMMENT_DENIED(403, "COMMENT_003", "댓글 수정 권한이 없습니다."),
    PERMISSION_DELETE_COMMENT_DENIED(403, "COMMENT_004", "댓글 삭제 권한이 없습니다."),
    
    ALREADY_LIKED(400, "LIKE_001", "이미 '좋아요'를 누른 상태입니다."),
    LIKE_NOT_FOUND(400, "LIKE_003", "'좋아요'를 누르지 않은 상태입니다."),
    IMAGE_IS_NULL(400, "IMAGE_001", "이미지를 확인해주세요."),
    
    ALREADY_SIGNED_UP_ERROR(400, "SIGNUP_001", "이미 화원가입 된 이메일입니다."),
    INVALID_EMAIL_PASSWORD_ERROR(400, "AUTH_003", "유효하지 않은 이메일 또는 비밀번호입니다."),
    
    REDIS_KEY_NOT_FOUND(404, "REDIS_001", "Key에 해당하는 Value값이 없습니다"),
    REDIS_KEY_EXPIRED(400, "REDIS_001", "Key가 만료되었습니다"),
    INVALID_INVITE_CODE(404, "INVITE-001", "매칭되는 초대링크가 없습니다."),
    EXPIRED_INVITE_CODE(404, "INVITE-002", "만료된 초대링크입니다."),
    
    USER_NOT_FOUND(404, "USER_004", "해당 유저를 찾을 수 없습니다."),
    TOKEN_NOT_VALID(401, "TOKEN_001", "토큰이 만료되었습니다. 다시 로그인 해주세요."),
    USER_CAN_NOT_BE_NULL(400, "USER_005", "사용자는 null이 될 수 없습니다."),
    USER_ID_NOT_FOUND(404, "USER_006", "해당되는 id의 사용자를 찾을 수 없습니다."),
    
    
    UNAUTHORIZED_ERROR(401, "AUTH_001", "인증되지 않았습니다. 접근 권한이 없습니다."),
    FORBIDDEN_ERROR(403, "AUTH_002", "이 리소스에 접근할 권한이 없습니다."),
    NULL_POINT_ERROR(404, "G010", "NullPointerException 발생"),
    NOT_FOUND_ERROR(404, "NOTFOUND_001", "요청한 리소스를 찾을 수 없습니다."),
    // @RequestBody 및 @RequestParam, @PathVariable 값이 유효하지 않음
    NOT_VALID_ERROR(404, "G011", "Validation Exception 발생"),
    INTERNAL_SERVER_ERROR(500, "SERVER_001", "서버 내부 오류가 발생했습니다."),
    
    NOT_FOUND_CATEGORY(404, "CAT_001", "해당 카테고리를 찾을 수 없습니다."),
    NOT_FOUND_PARENT_CATEGORY(404, "CAT_002", "부모 카테고리를 찾을 수 없습니다."),
    INVALID_BRANCH_NAME(400, "CAT_003", "동일한 branch와 이름을 가진 카테고리가 이미 존재합니다.");
    
    
    
    // 1. status = 날려줄 상태코드
    // 2. code = 해당 오류가 어느부분과 관련있는지 카테고리화 해주는 코드. 예외 원인 식별하기 편하기에 추가
    // 3. message = 발생한 예외에 대한 설명.
    
    private final int status;
    private final String code;
    private final String message;
    
    ExceptionCode(int status, String code, String message) {
        this.status = status;
        this.code = code;
        this.message = message;
    }
}
