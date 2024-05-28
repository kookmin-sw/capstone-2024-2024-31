package km.cd.backend.common.utils.sms.dto;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class SmsResultResponse {
    
    private Boolean isSuccess;
    
    private String message;
    
    public SmsResultResponse(boolean success, String message) {
        this.isSuccess = success;
        this.message = message;
    }
}
