class User {
  int id;
  String email;
  String avatar;
  String name;
  int level;
  int xp;
  int point;

  User({
    required this.id,
    required this.email,
    required this.avatar,
    required this.name,
    required this.level,
    required this.xp,
    required this.point,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      avatar: json['avatar'],
      name: json['name'],
      level: json['level'],
      xp: json['xp'],
      point: json['point'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['email'] = this.email;
    data['avatar'] = this.avatar;
    data['name'] = this.name;
    data['level'] = this.level;
    data['xp'] = this.xp;
    data['point'] = this.point;
    return data;
  }
}
