class ChallengeStatus {
  final int id;
  final String challengeName;
  final int challengePeriod;
  final DateTime startDate;
  final DateTime endDate;
  final int certificationStartTime;
  final int certificationEndTime;
  final String certificationFrequency;
  final int totalParticipants;
  final int numberOfCertifications;
  final int totalCertificationCount;
  final double currentAchievementRate;
  final int fullAchievementCount;
  final int highAchievementCount;
  final int lowAchievementCount;
  final double overallAverageAchievementRate;

  ChallengeStatus({
    required this.id,
    required this.challengeName,
    required this.challengePeriod,
    required this.startDate,
    required this.endDate,
    required this.certificationStartTime,
    required this.certificationEndTime,
    required this.certificationFrequency,
    required this.totalParticipants,
    required this.numberOfCertifications,
    required this.totalCertificationCount,
    required this.currentAchievementRate,
    required this.fullAchievementCount,
    required this.highAchievementCount,
    required this.lowAchievementCount,
    required this.overallAverageAchievementRate,
  });

  factory ChallengeStatus.fromJson(Map<String, dynamic> json) {
    return ChallengeStatus(
      id: json['id'],
      challengeName: json['challengeName'],
      challengePeriod: json['challengePeriod'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      certificationStartTime: json['certificationStartTime'],
      certificationEndTime: json['certificationEndTime'],
      certificationFrequency: json['certificationFrequency'],
      totalParticipants: json['totalParticipants'],
      numberOfCertifications: json['numberOfCertifications'],
      totalCertificationCount: json['totalCertificationCount'],
      currentAchievementRate: json['currentAchievementRate'],
      fullAchievementCount: json['fullAchievementCount'],
      highAchievementCount: json['highAchievementCount'],
      lowAchievementCount: json['lowAchievementCount'],
      overallAverageAchievementRate: json['overallAverageAchievementRate'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeName': challengeName,
      'challengePeriod': challengePeriod,
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
      'certificationStartTime': certificationStartTime,
      'certificationEndTime': certificationEndTime,
      'certificationFrequency': certificationFrequency,
      'totalParticipants': totalParticipants,
      'numberOfCertifications': numberOfCertifications,
      'totalCertificationCount': totalCertificationCount,
      'currentAchievementRate': currentAchievementRate,
      'fullAchievementCount': fullAchievementCount,
      'highAchievementCount': highAchievementCount,
      'lowAchievementCount': lowAchievementCount,
      'overallAverageAchievementRate': overallAverageAchievementRate,
    };
  }
}
