import 'package:logger/logger.dart';

enum ChallengeCategory {
  exercise('운동'),
  eating('식습관'),
  hobby('취미'),
  nature('환경'),
  study('공부');

  final String name;

  const ChallengeCategory(this.name);

  // JSON에서 객체로 변환
  factory ChallengeCategory.fromJson(String name) {
    try {
      return ChallengeCategory.values.firstWhere((e) => e.name == name);
    } catch (e) {
      // Log the error and return a default value or handle it appropriately
      Logger().e('Invalid category name: $name');
      throw Exception('Invalid category name: $name');
    }
  }

  // 객체에서 JSON으로 변환
  String toJson() {
    return name;
  }
}

// List<ChallengeCategory>를 List<String>으로 변환하는 확장 메소드
extension ChallengeCategoryListExtension on List<ChallengeCategory> {
  List<String> toNameList() {
    return this.map((category) => category.name).toList();
  }
}
