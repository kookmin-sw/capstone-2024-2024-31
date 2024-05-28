package km.cd.backend.common.utils.sms;

import km.cd.backend.common.error.CustomException;
import km.cd.backend.common.error.ExceptionCode;
import km.cd.backend.common.utils.RandomUtil;
import km.cd.backend.common.utils.sms.dto.SmsCertificationRequest;
import km.cd.backend.common.utils.sms.dto.SmsResultResponse;
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
    
    public SmsResultResponse sendSms(SmsCertificationRequest requestDto){
        String to = requestDto.getPhone();
        String certificationNumber = RandomUtil.generateRandomCode('0', '9',6);
        smsUtil.sendCertificateSMS(to, certificationNumber);
        smsCertificationDao.createSmsCertification(to,certificationNumber);
        return new SmsResultResponse(true, SMS_CREATE_SUCCESS_MESSAGE);
    }
    
    public SmsResultResponse verifySms(SmsCertificationRequest requestDto) {
        if (isVerify(requestDto)) {
            throw new CustomException(ExceptionCode.WRONG_AUTHENTICATION_CODE);
        }
        smsCertificationDao.removeSmsCertification(requestDto.getPhone());
        return new SmsResultResponse(true, SMS_VERIFY_SUCCESS_MESSAGE);
    }
    
    public boolean isVerify(SmsCertificationRequest requestDto) {
        return !(smsCertificationDao.hasKey(requestDto.getPhone()) &&
            smsCertificationDao.getSmsCertification(requestDto.getPhone())
                .equals(requestDto.getCertificationNumber()));
    }
    
}
