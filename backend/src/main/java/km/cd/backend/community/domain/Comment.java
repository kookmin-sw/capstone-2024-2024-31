package km.cd.backend.community.domain;

import jakarta.persistence.*;
import km.cd.backend.user.User;
import lombok.AccessLevel;
import lombok.Getter;
import lombok.NoArgsConstructor;

import java.util.ArrayList;
import java.util.List;

@Entity
@Table(name = "comments")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Comment {

  @Id
  @GeneratedValue(strategy = GenerationType.IDENTITY)
  private Long id;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "post_id")
  private Post post;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "author_id")
  private User author;

  private String content;

  @ManyToOne(fetch = FetchType.LAZY)
  @JoinColumn(name = "parent_id")
  private Comment parent;

  @OneToMany(mappedBy = "parent", orphanRemoval = true)
  private List<Comment> children = new ArrayList<>();

  private boolean isDeleted = false;

  public Comment(Post post, User author, String content) {
    this.post = post;
    this.author = author;
    this.content = content;
  }

  public void setParent(Comment comment) {
    this.parent = comment;
    comment.children.add(this);
  }

  public boolean hasParent() {
    return parent != null;
  }

  public void updateContent(String content) {
    this.content = content;
  }

  public void deleteComment() {
    this.isDeleted = true;
  }

}
