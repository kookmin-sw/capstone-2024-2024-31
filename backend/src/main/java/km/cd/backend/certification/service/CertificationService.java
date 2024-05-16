package km.cd.backend.certification.service;

import java.time.LocalDate;
import java.util.ArrayList;

import java.util.List;
import km.cd.backend.certification.domain.GitHubEvent;
import km.cd.backend.certification.dto.GithubCommitResponse;
import km.cd.backend.user.UserService;
import km.cd.backend.user.domain.User;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.multipart.MultipartFile;

@Service
@AllArgsConstructor
@Transactional(readOnly = true)
public class CertificationService {
    
    private final UserService userService;
    private final RestTemplate restTemplate = new RestTemplate();
    
    private final String GITHUB_REQUEST_URL = "https://api.github.com/users/%s/events";

    public boolean certifyHandGesture(MultipartFile image) {
        // TODO: image AI 서버로 전송 후 확인 받기
        throw new UnsupportedOperationException("Not supported yet.");
    }
    
    public GithubCommitResponse certifyGitubCommit(Long userId) {
        User user = userService.findById(userId);
        String url = String.format(GITHUB_REQUEST_URL, user.getGithubUsername());
        
        GitHubEvent[] events = restTemplate.getForObject(url, GitHubEvent[].class);
        
        LocalDate today = LocalDate.now();
        List<GitHubEvent.Payload.Commit> commits = new ArrayList<>();
        for (GitHubEvent event : events) {
            if ("PushEvent".equals(event.getType())) {
                LocalDate eventDate = event.getCreatedAtAsLocalDate();
                if (eventDate == null) continue;
                if (!eventDate.equals(today)) break;
                if (event.getPayload() != null && event.getPayload().getCommits() != null) {
                    commits.addAll(event.getPayload().getCommits());
                }
            }
        }
        
        return new GithubCommitResponse(!commits.isEmpty(), commits);
    }
    
}
