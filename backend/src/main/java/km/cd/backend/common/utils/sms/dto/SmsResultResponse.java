package km.cd.backend.common.utils.sms.dto;

import lombok.Data;
import lombok.RequiredArgsConstructor;

@Data
@RequiredArgsConstructor
public class SmsResultResponse {
    
    private Boolean isSuccesed;
    
    private String message;
    
    public SmsResultResponse(boolean success, String message) {
        this.isSuccesed = success;
        this.message = message;
    }
}
