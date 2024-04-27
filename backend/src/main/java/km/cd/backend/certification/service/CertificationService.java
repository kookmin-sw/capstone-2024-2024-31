package km.cd.backend.certification.service;

import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class CertificationService {

    public boolean certifyHandGesture(MultipartFile image) {
        // TODO: image AI 서버로 전송 후 확인 받기
        throw new UnsupportedOperationException("Not supported yet.");
    }


}
