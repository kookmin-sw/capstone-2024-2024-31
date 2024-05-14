import 'package:frontend/model/data/challenge/challenge_category.dart';

class ChallengeFilter {
  late String? name;
  late bool? isPrivate;
  late ChallengeCategory? category;

  ChallengeFilter({
    this.name,
    this.isPrivate,
    this.category,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'isPrivate': isPrivate,
      'category': category?.name,
    };
  }
}
