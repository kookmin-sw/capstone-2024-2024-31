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
    return ChallengeCategory.values.firstWhere((e) => e.name == name);
  }

  // 객체에서 JSON으로 변환
  String toJson() {
    return name;
  }
}
