import 'package:frontend/model/data/challenge/challenge_category.dart';

class User {
  final int id;
  final String email;
  final String? password;
  final String? provider;
  final String? providerId;
  final String name;
  final String? avatar;
  final String role;
  final DateTime? createdDate;
  final int point;
  final List<Friend> following;
  final List<Friend> followers;
  final Set<ChallengeCategory> categories;

  User({
    required this.id,
    required this.email,
    this.password,
    this.provider,
    this.providerId,
    required this.name,
    this.avatar,
    this.role = 'ROLE_USER',
    this.createdDate,
    this.point = 0,
    required this.following,
    required this.followers,
    required this.categories,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      password: json['password'],
      provider: json['provider'],
      providerId: json['providerId'],
      name: json['name'] ?? '',
      avatar: json['avatar'],
      role: json['role'] ?? 'ROLE_USER',
      createdDate: json['createdDate'] != null ? DateTime.parse(json['createdDate']) : null,
      point: json['point'] ?? 0,
      following: json['following'] != null ? List<Friend>.from(json['following'].map((x) => Friend.fromJson(x))) : [],
      followers: json['followers'] != null ? List<Friend>.from(json['followers'].map((x) => Friend.fromJson(x))) : [],
      categories: json['categories'] != null ? (json['categories'] as List).map((e) => ChallengeCategory.values.firstWhere((element) => element.toString() == 'ChallengeCategory.$e')).toSet() : {},
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
      'createdDate': createdDate?.toIso8601String(),
      'point': point,
      'following': following.map((e) => e.toJson()).toList(),
      'followers': followers.map((e) => e.toJson()).toList(),
      'categories': categories.map((e) => e.toString().split('.').last).toList(),
    };
  }
}
class Friend {
  final int id;
  final String name;

  Friend({required this.id, required this.name});

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}
