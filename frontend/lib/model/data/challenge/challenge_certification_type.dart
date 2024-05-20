enum ChallengeCertificationType {
  handGesture('제스쳐'),
  github('깃허브');

  final String name;

  const ChallengeCertificationType(this.name);

  factory ChallengeCertificationType.fromJson(String name) {
    try {
      return ChallengeCertificationType.values
          .firstWhere((e) => e.name == name);
    } catch (e) {
      throw Exception('Invalid certification type name: $name');
    }
  }

  String toJson() {
    return name;
  }
}
