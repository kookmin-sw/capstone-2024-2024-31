package km.cd.backend.community.domain;

import jakarta.persistence.*;
import km.cd.backend.challenge.domain.Challenge;
import km.cd.backend.common.domain.BaseTimeEntity;
import km.cd.backend.user.domain.User;
import lombok.*;

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

  @Setter
  private String image;

  private Boolean isRejected;

  @OneToMany(mappedBy = "post", orphanRemoval = true)
  private final List<Comment> comments = new ArrayList<>();

  @OneToMany(mappedBy = "post", orphanRemoval = true)
  private final List<Like> likes = new ArrayList<>();

  @Builder
  public Post(String title, String content, Challenge challenge, User author) {
    this.title = title;
    this.content = content;
    this.challenge = challenge;
    this.author = author;
    this.isRejected = false;
  }

  public boolean isAuthor(Long userId) {
    return this.author.getId().equals(userId);
  }

  public void rejectCertification() {
    this.isRejected = true;
  }

}
