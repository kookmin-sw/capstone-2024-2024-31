import 'package:frontend/model/data/freind.dart';

class User {
  final int id;
  final String email;
  final String? password;
  final String provider;
  final String providerId;
  final String name;
  final String? avatar;
  final String role;
  final DateTime createdDate;
  final int point;
  final List<Friend> following;
  final List<Friend> followers;

  User({
    required this.id,
    required this.email,
    this.password,
    required this.provider,
    required this.providerId,
    required this.name,
    this.avatar,
    this.role = 'ROLE_USER',
    required this.createdDate,
    this.point = 0,
    required this.following,
    required this.followers,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      provider: json['provider'],
      providerId: json['providerId'],
      name: json['name'],
      avatar: json['avatar'] ,
      role: json['role'] ?? 'ROLE_USER',
      createdDate: DateTime.parse(json['createdDate']),
      point: json['point'] ?? 0,
      following: List<Friend>.from(json['following'].map((model) => Friend.fromJson(model))),
      followers: List<Friend>.from(json['followers'].map((model) => Friend.fromJson(model))),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'password': password,
      'provider': provider,
      'providerId': providerId,
      'name': name,
      'avatar': avatar,
      'role': role,
      'createdDate': createdDate.toIso8601String(),
      'point': point,
      'following': following.map((e) => e.toJson()).toList(),
      'followers': followers.map((e) => e.toJson()).toList(),
    };
  }
}
