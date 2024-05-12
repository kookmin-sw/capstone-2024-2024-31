package km.cd.backend.common.utils.sms;

import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.common.utils.RandomUtil;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional(readOnly = true)
@RequiredArgsConstructor
public class SmsService {
    private final SmsUtil smsUtil;
    private final SmsCertificationDao smsCertificationDao;
    private final String SMS_CREATE_SUCCESS_MESSAGE = "메시지 전송에 성공하였습니다.";
    private final String SMS_VERIFY_SUCCESS_MESSAGE = "메시지 인증에 성공하였습니다.";
    
    public String sendSms(SmsCertificationRequest requestDto){
        String to = requestDto.getPhone();
        String certificationNumber = RandomUtil.generateRandomCode('0', '9',6);
        smsUtil.sendCertificateSMS(to, certificationNumber);
        smsCertificationDao.createSmsCertification(to,certificationNumber);
        return SMS_CREATE_SUCCESS_MESSAGE;
    }
    
    public String verifySms(SmsCertificationRequest requestDto) {
        if (isVerify(requestDto)) {
            throw new CustomException(ExceptionCode.WRONG_AUTHENTICATION_CODE);
        }
        smsCertificationDao.removeSmsCertification(requestDto.getPhone());
        return SMS_VERIFY_SUCCESS_MESSAGE;
    }
    
    public boolean isVerify(SmsCertificationRequest requestDto) {
        return !(smsCertificationDao.hasKey(requestDto.getPhone()) &&
            smsCertificationDao.getSmsCertification(requestDto.getPhone())
                .equals(requestDto.getCertificationNumber()));
    }
    
}
