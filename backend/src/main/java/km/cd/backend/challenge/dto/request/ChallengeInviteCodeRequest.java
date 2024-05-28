package km.cd.backend.challenge.dto.request;

import jakarta.validation.constraints.NotBlank;

public record ChallengeInviteCodeRequest(
    @NotBlank(message = "초대코드를 입력해주세요.")
    String code
) {
}
