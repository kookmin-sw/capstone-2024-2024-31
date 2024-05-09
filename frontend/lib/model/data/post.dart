class Author {
  final int id;
  final String email;
  final String avatar;
  final String name;
  final int point;

  Author({
    required this.id,
    required this.email,
    required this.avatar,
    required this.name,
    required this.point,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'],
      email: json['email'],
      avatar: json['avatar'],
      name: json['name'],
      point: json['point'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'avatar': avatar,
      'name': name,
      'point': point,
    };
  }
}

class Comment {
  final int id;
  final String author;
  final String content;

  Comment({
    required this.id,
    required this.author,
    required this.content,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      author: json['author'],
      content: json['content'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'author': author,
      'content': content,
    };
  }
}

class Article {
  final int id;
  final String title;
  final String content;
  final Author author;
  final String image;
  final DateTime createdDate;
  final List<Comment> comments;

  Article({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.image,
    required this.createdDate,
    required this.comments,
  });

  factory Article.fromJson(Map<String, dynamic> json) {
    return Article(
      id: json['id'],
      title: json['title'],
      content: json['content'],
      author: Author.fromJson(json['author']),
      image: json['image'],
      createdDate: DateTime.parse(json['createdDate']),
      comments: (json['comments'] as List<dynamic>)
          .map((comment) => Comment.fromJson(comment))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
      'author': author.toJson(),
      'image': image,
      'createdDate': createdDate.toIso8601String(),
      'comments': comments.map((comment) => comment.toJson()).toList(),
    };
  }
}
