package km.cd.backend.common.utils;

import jakarta.annotation.PostConstruct;
import net.nurigo.sdk.NurigoApp;
import net.nurigo.sdk.message.model.Message;
import net.nurigo.sdk.message.request.SingleMessageSendingRequest;
import net.nurigo.sdk.message.response.SingleMessageSentResponse;
import net.nurigo.sdk.message.service.DefaultMessageService;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

@Component
public class SmsUtil {
    
    @Value("${coolsms.api.key}")
    private String apiKey;
    
    @Value("${coolsms.api.secret}")
    private String apiSecretKey;
    
    @Value("${coolsms.caller}")
    private String caller;
    private DefaultMessageService messageService;
    
    @PostConstruct
    private void init(){
        this.messageService = NurigoApp.INSTANCE.initialize(apiKey, apiSecretKey, "https://api.coolsms.co.kr");
    }
    
    // 단일 메시지 발송 예제
    public SingleMessageSentResponse sendOne(SmsRequestDto smsRequestDto) {
        Message message = new Message();
        
        // 발신번호 및 수신번호는 반드시 01012345678 형태로 입력되어야 합니다.
        String to = smsRequestDto.getReceiverNumber().replaceAll("-","");
        String challengeName = smsRequestDto.getChallengeName();
        String userName = smsRequestDto.getUserName();
        
        message.setFrom(caller);
        message.setTo(to);
        message.setText(userName + "님이 " + challengeName + "에 실패하셨습니다.");
        
        SingleMessageSentResponse response = this.messageService.sendOne(new SingleMessageSendingRequest(message));
        return response;
    }
    
}
