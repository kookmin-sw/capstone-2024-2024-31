package km.cd.backend.common.utils.sms;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class SmsResultRequest {
    
    @Schema(description = "수신 번호")
    private String receiverNumber;
    
    @Schema(description = "유저 이름")
    private String userName;
    
    @Schema(description = "챌린지 이름")
    private String challengeName;
}
