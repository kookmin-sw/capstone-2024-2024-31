class User {
  int id;
  String email;
  String avatar;
  String name;
  int point;

  User({
    required this.id,
    required this.email,
    required this.avatar,
    required this.name,
    required this.point,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      avatar: json['avatar'],
      name: json['name'],
      point: json['point'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['email'] = email;
    data['avatar'] = avatar;
    data['name'] = name;
    data['point'] = point;
    return data;
  }
}
