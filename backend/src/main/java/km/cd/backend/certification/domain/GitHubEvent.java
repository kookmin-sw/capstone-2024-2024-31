package km.cd.backend.certification.domain;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Getter
@Setter
public class GitHubEvent {
    private String id;
    private String type;
    private Actor actor;
    private Repo repo;
    private Payload payload;
    private boolean is_public;
    private String created_at;
    private Org org;
    
    public LocalDate getCreatedAtAsLocalDate() {
        if (created_at == null || created_at.isEmpty()) {
            return null;
        }
        return LocalDateTime.parse(created_at, DateTimeFormatter.ISO_DATE_TIME).toLocalDate();
    }
    
    @Getter
    @Setter
    public static class Actor {
        private long id;
        private String login;
        private String display_login;
        private String gravatar_id;
        private String url;
        private String avatar_url;
    }
    
    @Getter
    @Setter
    public static class Repo {
        private long id;
        private String name;
        private String url;
    }
    
    @Getter
    @Setter
    public static class Payload {
        private long repository_id;
        private long push_id;
        private int size;
        private int distinct_size;
        private String ref;
        private String head;
        private String before;
        private List<Commit> commits;
        
        @Getter
        @Setter
        public static class Commit {
            private String sha;
            private Author author;
            private String message;
            private boolean distinct;
            private String url;
            
            @Getter
            @Setter
            public static class Author {
                private String email;
                private String name;
            }
        }
    }
    
    @Getter
    @Setter
    public static class Org {
        private long id;
        private String login;
        private String gravatar_id;
        private String url;
        private String avatar_url;
    }
}
