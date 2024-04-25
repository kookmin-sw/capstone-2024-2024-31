package km.cd.backend.challenge.dto;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;
import org.springframework.web.multipart.MultipartFile;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class CertificationReceivedDto {

    @Schema(description = "챌린지 인증 이미지")
    private MultipartFile certificationImage;
}
