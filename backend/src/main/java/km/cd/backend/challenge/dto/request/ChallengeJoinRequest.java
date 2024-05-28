package km.cd.backend.challenge.dto.request;

public record ChallengeJoinRequest(
    String targetName,
    String receiverNumber,
    String determination
) {
}
