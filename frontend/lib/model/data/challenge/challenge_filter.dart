import 'challenge_category.dart';

class ChallengeFilter {
  String? name;
  bool? isPrivate;
  ChallengeCategory? category;

  ChallengeFilter({
    this.name,
    this.isPrivate,
    this.category,
  });

  // JSON에서 객체로 변환
  factory ChallengeFilter.fromJson(Map<String, dynamic> json) {
    return ChallengeFilter(
      name: json['name'],
      isPrivate: json['isPrivate'],
      category: json['category'] != null ? ChallengeCategory.fromJson(json['category']) : null,
    );
  }

  // 객체에서 JSON으로 변환
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isPrivate': isPrivate,
      'category': category?.toJson(),
    };
  }
}
