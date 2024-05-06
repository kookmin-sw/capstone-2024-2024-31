package km.cd.backend.common.utils.sms;

import lombok.AllArgsConstructor;

import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@AllArgsConstructor
public class SmsController {
    
    private final SmsUtil smsUtil;
    
    @PostMapping("/sms")
    public ResponseEntity<?> sendSmsToTarget(SmsRequestDto smsRequestDto) {
        return ResponseEntity.ok(smsUtil.sendOne(smsRequestDto));
    }
}
