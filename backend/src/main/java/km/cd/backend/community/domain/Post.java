package km.cd.backend.community.domain;

import jakarta.persistence.*;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.common.domain.BaseTimeEntity;
import km.cd.backend.user.User;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "posts")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Post extends BaseTimeEntity {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  private String title;
  private String content;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "challenge_id")
  private Challenge challenge;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "author_id")
  private User author;

  private String picture;

  @OneToMany(mappedBy = "post", orphanRemoval = true)
  private List<Comment> comments = new ArrayList<>();

  public Post(String title, String content, Challenge challenge, User author) {
    this.title = title;
    this.content = content;
    this.challenge = challenge;
    this.author = author;
  }

  private boolean isVerified = false;

  public boolean isAuthor(Long userId) {
    return this.author.getId().equals(userId);
  }
}
