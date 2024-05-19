class SimplePost {
  final int id;
  final String title;
  final String author;

  SimplePost({
    required this.id,
    required this.title,
    required this.author,
  });

  factory SimplePost.fromJson(Map<String, dynamic> json) {
    return SimplePost(
      id: json['id'] as int,
      title: json['title'] as String,
      author: json['author'] as String,
    );
  }
}
