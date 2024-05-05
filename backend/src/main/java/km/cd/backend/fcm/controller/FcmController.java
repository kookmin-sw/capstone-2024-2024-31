package km.cd.backend.fcm.controller;

import java.io.IOException;
import km.cd.backend.fcm.dto.FcmRequest;
import km.cd.backend.fcm.service.FcmService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@Slf4j
@RestController
@RequestMapping("/fcm")
@RequiredArgsConstructor
public class FcmController {
    
    private final FcmService fcmService;
    @PostMapping("/send")
    public ResponseEntity pushMessage(@RequestBody @Validated FcmRequest fcmRequest) throws IOException {
        int result = fcmService.sendMessageTo(fcmRequest);
        return ResponseEntity.ok().build();
    }
}
