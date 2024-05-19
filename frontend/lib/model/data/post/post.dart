import 'package:frontend/model/data/user.dart';

class Post {
  final int id;
  final String title;
  final String content;
  final String createdDate;
  final String image;
  final List<Comment> comments;

  Post({
    required this.id,
    required this.title,
    required this.content,
    required this.image,
    required this.createdDate,
    required this.comments,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    return Post(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      image: json['image'] as String,
      createdDate: json['createdDate'] as String,
      comments: (json['comments'] as List<dynamic>)
          .map((commentJson) =>
              Comment.fromJson(commentJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Comment {
  final int id;
  final String author;
  final String image;
  final String content;
  final String createdDate;
  final List<Comment> children;

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.children,
    required this.createdDate,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
        id: json['id'] as int,
        author: json['author'] as String,
        content: json['content'] as String,
        children: json['children'] == null
            ? []
            : (json['children'] as List<dynamic>)
                .map((commentJson) =>
                    Comment.fromJson(commentJson as Map<String, dynamic>))
                .toList(),
        createdDate: json['createdDate'] as String);
  }
}
