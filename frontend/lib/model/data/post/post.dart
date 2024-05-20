class Post {
  final int id;
  final String title;
  final String content;
  final String author;
  final int authorId;
  final String avatar;
  final String image;
  final String createdDate;
  final List<Comment> comments;
  final List<Like> likes;

  Post(
      {required this.id,
      required this.title,
      required this.content,
      required this.author,
      required this.authorId,
      required this.avatar,
      required this.image,
      required this.createdDate,
      required this.comments,
      required this.likes});

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      authorId: json['authorId'] as int,
      author: json['author'] as String,
      avatar: json['avatar'] as String,
      image: json['image'] as String,
      createdDate: json['createdDate'] as String,
      comments: (json['comments'] as List<dynamic>)
          .map((commentJson) =>
              Comment.fromJson(commentJson as Map<String, dynamic>))
          .toList(),
      likes: (json['likes'] as List<dynamic>)
          .map((likeJson) => Like.fromJson(likeJson as Map<String, dynamic>))
          .toList(),
    );
  }

  @override
  String toString() {
    return 'Post{id: $id, title: $title, content:  $content, author:  $authorId, $author, createdDate: $createdDate, image: $image, comments: $comments, likes: $likes}';
  }
}

class Comment {
  final int id;
  final int? parentId;
  final String author;
  final String avatar;
  final String content;
  final String createdDate;
  final List<Comment> children;

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.avatar,
    required this.children,
    required this.createdDate,
    this.parentId,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'] as int,
        parentId: json['parentId'] as int?,
        author: json['author'] as String,
        content: json['content'] as String,
        avatar: json['avatar'] as String,
        children: json['children'] == null
            ? []
            : (json['children'] as List<dynamic>)
                .map((commentJson) =>
                    Comment.fromJson(commentJson as Map<String, dynamic>))
                .toList(),
        createdDate: json['createdDate'] as String);
  }
}

class Like {
  final int userId;

  Like({required this.userId});

  factory Like.fromJson(Map<String, dynamic> json) {
    return Like(
      userId: json['userId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
    };
  }
}
