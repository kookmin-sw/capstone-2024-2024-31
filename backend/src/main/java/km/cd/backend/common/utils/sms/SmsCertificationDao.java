package km.cd.backend.common.utils.sms;

import java.time.Duration;
import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.StringRedisTemplate;
import org.springframework.stereotype.Repository;

@RequiredArgsConstructor
@Repository
public class SmsCertificationDao {
    
    private final String PREFIX = "sms:";
    private final int LIMIT_TIME = 5 * 60;
    
    private final StringRedisTemplate redisTemplate;
    
    public void createSmsCertification(String phone, String certificationNumber) {
        redisTemplate.opsForValue()
            .set(PREFIX + phone, certificationNumber, Duration.ofSeconds(LIMIT_TIME));
    }
    
    public String getSmsCertification(String phone) {
        return redisTemplate.opsForValue().get(PREFIX + phone);
    }
    
    public void removeSmsCertification(String phone) {
        redisTemplate.delete(PREFIX + phone);
    }
    
    public boolean hasKey(String phone) {
        return redisTemplate.hasKey(PREFIX + phone);
    }
}
