package km.cd.backend.certification.dto;

import java.util.List;
import km.cd.backend.certification.domain.GitHubEvent.Payload.Commit;

public record GithubCommitResponse(
    Boolean isCommited,
    
    List<Commit> commits
    
) {

}
