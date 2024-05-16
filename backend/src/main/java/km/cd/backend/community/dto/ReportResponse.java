package km.cd.backend.community.dto;

public record ReportResponse(
    Integer reportingCount,
    Boolean isRejected
) {
}
