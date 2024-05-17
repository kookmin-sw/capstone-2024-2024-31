class CreatedpostPost {
  final int id;
  final String title;
  final String content;
  final Author author;
  final String image;
  final DateTime createdDate;
  final List<Comment> comments;

  CreatedpostPost({
    required this.id,
    required this.title,
    required this.content,
    required this.author,
    required this.image,
    required this.createdDate,
    required this.comments,
  });

  factory CreatedpostPost.fromJson(Map<String, dynamic> json) {
    return CreatedpostPost(
      id: json['id'] as int,
      title: json['title'] as String,
      content: json['content'] as String,
      author: Author.fromJson(json['author'] as Map<String, dynamic>),
      image: json['image'] as String,
      createdDate: DateTime.parse(json['createdDate'] as String),
      comments: (json['comments'] as List<dynamic>)
          .map((commentJson) => Comment.fromJson(commentJson as Map<String, dynamic>))
          .toList(),
    );
  }
}

class Author {
  final int id;
  final String email;
  final String avatar;
  final String name;
  final int point;
  final List<String> categories;

  Author({
    required this.id,
    required this.email,
    required this.avatar,
    required this.name,
    required this.point,
    required this.categories,
  });

  factory Author.fromJson(Map<String, dynamic> json) {
    return Author(
      id: json['id'] as int,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      name: json['name'] as String,
      point: json['point'] as int,
      categories: (json['categories'] as List<dynamic>).map((category) => category as String).toList(),
    );
  }
}

class Comment {
  final int id;
  final String author;
  final String content;
  final UserResponse userResponse;

  Comment({
    required this.id,
    required this.author,
    required this.content,
    required this.userResponse,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'] as int,
      author: json['author'] as String,
      content: json['content'] as String,
      userResponse: UserResponse.fromJson(json['userResponse'] as Map<String, dynamic>),
    );
  }
}

class UserResponse {
  final int id;
  final String email;
  final String avatar;
  final String name;
  final int point;
  final List<String> categories;

  UserResponse({
    required this.id,
    required this.email,
    required this.avatar,
    required this.name,
    required this.point,
    required this.categories,
  });

  factory UserResponse.fromJson(Map<String, dynamic> json) {
    return UserResponse(
      id: json['id'] as int,
      email: json['email'] as String,
      avatar: json['avatar'] as String,
      name: json['name'] as String,
      point: json['point'] as int,
      categories: (json['categories'] as List<dynamic>).map((category) => category as String).toList(),
    );
  }
}
