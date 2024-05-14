class Challenge {
  late int id;
  late bool isPrivate;
  late String privateCode;
  late String challengeName;
  late String challengeExplanation;
  late List<String> challengeImageUrls;
  late int challengePeriod;
  late DateTime startDate;
  late DateTime endDate;
  late String certificationFrequency;
  late int certificationStartTime;
  late int certificationEndTime;
  late String certificationExplanation;
  late String failedVerificationImageUrl;
  late String successfulVerificationImageUrl;
  late bool isGalleryPossible;
  late int maximumPeople;
  late bool isEnded;
  late int totalParticipants;

  Challenge({
    required this.id,
    required this.isPrivate,
    required this.privateCode,
    required this.challengeName,
    required this.challengeExplanation,
    required this.challengePeriod,
    required this.challengeImageUrls,
    required this.startDate,
    required this.endDate,
    required this.certificationFrequency,
    required this.certificationStartTime,
    required this.certificationEndTime,
    required this.certificationExplanation,
    required this.isGalleryPossible,
    required this.failedVerificationImageUrl,
    required this.successfulVerificationImageUrl,
    required this.maximumPeople,
    required this.isEnded,
    required this.totalParticipants,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      isPrivate: json['isPrivate'],
      privateCode: json['privateCode'] ?? '',
      challengeName: json['challengeName'],
      challengeExplanation: json['challengeExplanation'],
      challengePeriod: json['challengePeriod'],
      startDate: DateTime.parse(json['startDate']),
      endDate: DateTime.parse(json['endDate']),
      certificationFrequency: json['certificationFrequency'],
      certificationStartTime: json['certificationStartTime'],
      certificationEndTime: json['certificationEndTime'],
      certificationExplanation: json['certificationExplanation'],
      isGalleryPossible: json['isGalleryPossible'],
      maximumPeople: json['maximumPeople'],
      challengeImageUrls:
          (json['challengeImagePaths'] as List<dynamic>).cast<String>(),
      failedVerificationImageUrl: json['failedVerificationImage'],
      successfulVerificationImageUrl: json['successfulVerificationImage'],
      isEnded: json['isEnded'],
      totalParticipants: json['totalParticipants'],
    );
  }

  static Challenge getDummyData() {
    return Challenge(
        id: 1,
        isPrivate: false,
        privateCode: 'privateCode',
        challengeName: '조깅 3KM 진행하고 상금받자!',
        challengeExplanation:
            '챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라',
        challengePeriod: 4,
        startDate: DateTime.parse('2024-04-08'),
        endDate: DateTime.parse('2024-05-08'),
        certificationFrequency: '평일 매일',
        certificationStartTime: 1,
        certificationEndTime: 24,
        certificationExplanation:
            '인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~',
        successfulVerificationImageUrl: "https://picsum.photos/250?image=9",
        failedVerificationImageUrl: "https://picsum.photos/250?image=9",
        challengeImageUrls: [
          "https://picsum.photos/250?image=9",
          "https://picsum.photos/250?image=9"
        ],
        isGalleryPossible: true,
        maximumPeople: 100,
        isEnded: false,
        totalParticipants: 50);
  }
}
