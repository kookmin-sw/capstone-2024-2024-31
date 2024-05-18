class ChallengeStatus {
  late int id;
  late String challengeName;
  late int challengePeriod;
  late String startDate;
  late String endDate;
  late int certificationStartTime;
  late int certificationEndTime;
  late String certificationFrequency;
  late int totalParticipants;
  late int numberOfCertifications;
  late int totalCertificationCount;

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
  });

  // From JSON
  ChallengeStatus.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    challengeName = json['challengeName'];
    challengePeriod = json['challengePeriod'];
    startDate = json['startDate'];
    endDate = json['endDate'];
    certificationStartTime = json['certificationStartTime'];
    certificationEndTime = json['certificationEndTime'];
    certificationFrequency = json['certificationFrequency'];
    totalParticipants = json['totalParticipants'];
    numberOfCertifications = json['numberOfCertifications'];
    totalCertificationCount = json['totalCertificationCount'];
  }

  // To JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'challengeName': challengeName,
      'challengePeriod': challengePeriod,
      'startDate': startDate,
      'endDate': endDate,
      'certificationStartTime': certificationStartTime,
      'certificationEndTime': certificationEndTime,
      'certificationFrequency': certificationFrequency,
      'totalParticipants': totalParticipants,
      'numberOfCertifications': numberOfCertifications,
      'totalCertificationCount': totalCertificationCount,
    };
  }
}
