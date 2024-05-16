import 'dart:convert';

class Challenge {
  final int id;
  final bool isPrivate;
  final String? privateCode;
  final String challengeName;
  final String? challengeExplanation;
  final int? challengePeriod;
  final DateTime? startDate;
  final DateTime? endDate;
  final String? certificationFrequency;
  final int? certificationStartTime;
  final int? certificationEndTime;
  final String? certificationExplanation;
  final bool isGalleryPossible;
  final int? maximumPeople;
  final List<Participant> participants;
  final List<String>? challengeImagePaths;
  final String? failedVerificationImage;
  final String? successfulVerificationImage;
  final String? status;
  final int totalParticipants;
  final CertificationType certificationType;
  final ChallengeCategory? challengeCategory;
  final int? totalCertificationCount;

  Challenge({
    required this.id,
    required this.isPrivate,
    this.privateCode,
    required this.challengeName,
    this.challengeExplanation,
    this.challengePeriod,
    this.startDate,
    this.endDate,
    this.certificationFrequency,
    this.certificationStartTime,
    this.certificationEndTime,
    this.certificationExplanation,
    required this.isGalleryPossible,
    this.maximumPeople,
    required this.participants,
    this.challengeImagePaths,
    this.failedVerificationImage,
    this.successfulVerificationImage,
    this.status,
    this.totalParticipants = 0,
    this.certificationType = CertificationType.HAND_GESTURE,
    this.challengeCategory,
    this.totalCertificationCount,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'] ?? 0,
      isPrivate: json['isPrivate'] ?? false,
      privateCode: json['privateCode'],
      challengeName: json['challengeName'] ?? '',
      challengeExplanation: json['challengeExplanation'],
      challengePeriod: json['challengePeriod'],
      startDate: json['startDate'] != null ? DateTime.parse(json['startDate']) : null,
      endDate: json['endDate'] != null ? DateTime.parse(json['endDate']) : null,
      certificationFrequency: json['certificationFrequency'],
      certificationStartTime: json['certificationStartTime'],
      certificationEndTime: json['certificationEndTime'],
      certificationExplanation: json['certificationExplanation'],
      isGalleryPossible: json['isGalleryPossible'] ?? false,
      maximumPeople: json['maximumPeople'],
      participants: (json['participants'] as List<dynamic>).map((e) => Participant.fromJson(e)).toList(),
      challengeImagePaths: (json['challengeImagePaths'] as List<dynamic>?)?.map((e) => e as String).toList(),
      failedVerificationImage: json['failedVerificationImage'],
      successfulVerificationImage: json['successfulVerificationImage'],
      status: json['status'],
      totalParticipants: json['totalParticipants'] ?? 0,
      certificationType: CertificationTypeExtension.fromJson(json['certificationType']),
      challengeCategory: ChallengeCategoryExtension.fromJson(json['challengeCategory']),
      totalCertificationCount: json['totalCertificationCount'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isPrivate': isPrivate,
      'privateCode': privateCode,
      'challengeName': challengeName,
      'challengeExplanation': challengeExplanation,
      'challengePeriod': challengePeriod,
      'startDate': startDate?.toString(),
      'endDate': endDate?.toString(),
      'certificationFrequency': certificationFrequency,
      'certificationStartTime': certificationStartTime,
      'certificationEndTime': certificationEndTime,
      'certificationExplanation': certificationExplanation,
      'isGalleryPossible': isGalleryPossible,
      'maximumPeople': maximumPeople,
      'participants': participants.map((e) => e.toJson()).toList(),
      'challengeImagePaths': challengeImagePaths,
      'failedVerificationImage': failedVerificationImage,
      'successfulVerificationImage': successfulVerificationImage,
      'status': status,
      'totalParticipants': totalParticipants,
      'certificationType': certificationType.toJson(),
      'challengeCategory': challengeCategory?.toJson(),
      'totalCertificationCount': totalCertificationCount,
    };
  }

  static Challenge getDummyData(){
    return   Challenge(
      id: 1,
      isPrivate: false,
      privateCode: null,
      challengeName: 'Fitness Challenge',
      challengeExplanation: 'A challenge to stay fit',
      challengePeriod: 30,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
      certificationFrequency: 'daily',
      certificationStartTime: 6,
      certificationEndTime: 22,
      certificationExplanation: 'Upload your fitness activity',
      isGalleryPossible: true,
      maximumPeople: 100,
      participants: [Participant(id: 1, name: 'John Doe')],
      challengeImagePaths: ['path/to/image1.jpg', 'path/to/image2.jpg'],
      failedVerificationImage: 'path/to/failed_image.jpg',
      successfulVerificationImage: 'path/to/successful_image.jpg',
      status: 'active',
      totalParticipants: 10,
      certificationType: CertificationType.HAND_GESTURE,
      challengeCategory: ChallengeCategory.CATEGORY_ONE,
      totalCertificationCount: 10,
    );
  }

  static List<Challenge> getDummyDataList() {
    return [
      Challenge(
        id: 1,
        isPrivate: false,
        privateCode: null,
        challengeName: 'Fitness Challenge',
        challengeExplanation: 'A challenge to stay fit',
        challengePeriod: 30,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 30)),
        certificationFrequency: 'daily',
        certificationStartTime: 6,
        certificationEndTime: 22,
        certificationExplanation: 'Upload your fitness activity',
        isGalleryPossible: true,
        maximumPeople: 100,
        participants: [Participant(id: 1, name: 'John Doe')],
        challengeImagePaths: ['path/to/image1.jpg', 'path/to/image2.jpg'],
        failedVerificationImage: 'path/to/failed_image.jpg',
        successfulVerificationImage: 'path/to/successful_image.jpg',
        status: 'active',
        totalParticipants: 10,
        certificationType: CertificationType.HAND_GESTURE,
        challengeCategory: ChallengeCategory.CATEGORY_ONE,
        totalCertificationCount: 10,
      ),
      Challenge(
        id: 2,
        isPrivate: true,
        privateCode: '123ABC',
        challengeName: 'Reading Challenge',
        challengeExplanation: 'Read a book every week',
        challengePeriod: 60,
        startDate: DateTime.now(),
        endDate: DateTime.now().add(Duration(days: 60)),
        certificationFrequency: 'weekly',
        certificationStartTime: 8,
        certificationEndTime: 20,
        certificationExplanation: 'Upload a picture of the book',
        isGalleryPossible: false,
        maximumPeople: 50,
        participants: [Participant(id: 2, name: 'Jane Doe')],
        challengeImagePaths: ['path/to/image3.jpg'],
        failedVerificationImage: 'path/to/failed_reading.jpg',
        successfulVerificationImage: 'path/to/successful_reading.jpg',
        status: 'active',
        totalParticipants: 5,
        certificationType: CertificationType.PHOTO,
        challengeCategory: ChallengeCategory.CATEGORY_TWO,
        totalCertificationCount: 8,
      ),
    ];
  }

}

class Participant {
  final int id;
  final String name;

  Participant({
    required this.id,
    required this.name,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
    };
  }
}

enum CertificationType {
  HAND_GESTURE,
  PHOTO,
}

extension CertificationTypeExtension on CertificationType {
  static CertificationType fromJson(String json) {
    switch (json) {
      case 'HAND_GESTURE':
        return CertificationType.HAND_GESTURE;
      case 'PHOTO':
        return CertificationType.PHOTO;
      default:
        throw ArgumentError('Invalid CertificationType: $json');
    }
  }

  String toJson() {
    return toString().split('.').last;
  }
}

enum ChallengeCategory {
  CATEGORY_ONE,
  CATEGORY_TWO,
  CATEGORY_THREE,
}

extension ChallengeCategoryExtension on ChallengeCategory {
  static ChallengeCategory fromJson(String? json) {
    switch (json) {
      case 'CATEGORY_ONE':
        return ChallengeCategory.CATEGORY_ONE;
      case 'CATEGORY_TWO':
        return ChallengeCategory.CATEGORY_TWO;
      case 'CATEGORY_THREE':
        return ChallengeCategory.CATEGORY_THREE;
      default:
        return ChallengeCategory.CATEGORY_ONE;
    }
  }

  String toJson() {
    return toString().split('.').last;
  }
}
