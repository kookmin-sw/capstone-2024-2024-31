class ChallengeSimple {
  final int id;
  final String startDate;
  final String challengeName;
  final String certificationFrequency;
  final int challengePeriod;
  final int totalParticipants;
  final String imageUrl;

  ChallengeSimple({
    required this.id,
    required this.startDate,
    required this.challengeName,
    required this.certificationFrequency,
    required this.challengePeriod,
    required this.totalParticipants,
    required this.imageUrl,
  });

  factory ChallengeSimple.fromJson(Map<String, dynamic> json) {
    return ChallengeSimple(
      id: json['id'],
      startDate: json['startDate'],
      challengeName: json['challengeName'],
      certificationFrequency: json['certificationFrequency'],
      challengePeriod: json['challengePeriod'],
      totalParticipants: json['totalParticipants'],
      imageUrl: json['imageUrl'],
    );
  }
}
