package km.cd.backend.fcm.service;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.google.auth.oauth2.GoogleCredentials;
import java.io.IOException;
import java.util.List;
import km.cd.backend.fcm.dto.FcmRequest;
import km.cd.backend.fcm.dto.FcmResponse;
import org.springframework.core.io.ClassPathResource;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

@Service
public class FcmService {
    
    /**
     * 푸시 메시지 처리를 수행하는 비즈니스 로직
     *
     * @param fcmRequest 모바일에서 전달받은 Object
     * @return 성공(1), 실패(0)
     */
    public int sendMessageTo(FcmRequest fcmRequest) throws IOException {
        
        String message = makeMessage(fcmRequest);
        RestTemplate restTemplate = new RestTemplate();
        
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.set("Authorization", "Bearer " + getAccessToken());
        
        HttpEntity entity = new HttpEntity<>(message, headers);
        
        String API_URL = "https://fcm.googleapis.com/v1/projects/routineup-966a5/messages:send";
        ResponseEntity response = restTemplate.exchange(API_URL, HttpMethod.POST, entity, String.class);
        
        System.out.println(response.getStatusCode());
        
        return response.getStatusCode() == HttpStatus.OK ? 1 : 0;
    }
    
    /**
     * Firebase Admin SDK의 비공개 키를 참조하여 Bearer 토큰을 발급 받습니다.
     *
     * @return Bearer token
     */
    private String getAccessToken() throws IOException {
        String firebaseConfigPath = "firebase/routineup-firebase-key.json";
        
        GoogleCredentials googleCredentials = GoogleCredentials
            .fromStream(new ClassPathResource(firebaseConfigPath).getInputStream())
            .createScoped(List.of("https://www.googleapis.com/auth/cloud-platform"));
        
        googleCredentials.refreshIfExpired();
        return googleCredentials.getAccessToken().getTokenValue();
    }
    
    /**
     * FCM 전송 정보를 기반으로 메시지를 구성합니다. (Object -> String)
     *
     * @param fcmRequest FcmSendDto
     * @return String
     */
    private String makeMessage(FcmRequest fcmRequest) throws JsonProcessingException {
        
        ObjectMapper om = new ObjectMapper();
        FcmResponse fcmResponse = FcmResponse.builder()
            .message(FcmResponse.Message.builder()
                .token(fcmRequest.getToken())
                .notification(FcmResponse.Notification.builder()
                    .title(fcmRequest.getTitle())
                    .body(fcmRequest.getBody())
                    .image(null)
                    .build()
                ).build()).validateOnly(false).build();
        
        return om.writeValueAsString(fcmResponse);
    }
}
