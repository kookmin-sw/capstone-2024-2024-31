import 'package:frontend/model/data/challenge/challenge_category.dart';

import 'freind.dart';

class User {
  final int id;
  final String email;
  final String name;
  final String avatar;
  final int point;
  final List<ChallengeCategory> categories;
  final List<Friend> following;
  final List<Friend> followers;

  User({
    required this.id,
    required this.email,
    required this.name,
    required this.avatar,
    required this.point,
    required this.categories,
    required this.following,
    required this.followers,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      email: json['email'] ?? '',
      name: json['name'] ?? '',
      avatar: json['avatar'],
      point: json['point'] ?? 0,
      categories: json['categories'] != null
          ? List<ChallengeCategory>.from(
              json['categories'].map((x) => ChallengeCategory.fromJson(x)))
          : [],
      following: json['following'] != null
          ? List<Friend>.from(json['following'].map((x) => Friend.fromJson(x)))
          : [],
      followers: json['followers'] != null
          ? List<Friend>.from(json['followers'].map((x) => Friend.fromJson(x)))
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'name': name,
      'avatar': avatar,
      'point': point,
      'categories': categories.map((e) => e.toJson()).toList(),
      'following': following.map((e) => e.toJson()).toList(),
      'followers': followers.map((e) => e.toJson()).toList(),
    };
  }
}
