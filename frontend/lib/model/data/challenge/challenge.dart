import 'dart:convert';

class Challenge {
  final int id;
  final bool? isPrivate;
  final String? privateCode;
  final String challengeName;
  final String? challengeExplanation;
  final int? challengePeriod;
  final DateTime startDate;
  final DateTime endDate;
  final String? certificationFrequency;
  final int? certificationStartTime;
  final int? certificationEndTime;
  final String? certificationExplanation;
  final bool? isGalleryPossible;
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
    required this.startDate,
    required this.endDate,
    this.certificationFrequency,
    this.certificationStartTime,
    this.certificationEndTime,
    this.certificationExplanation,
    this.isGalleryPossible,
    this.maximumPeople,
    this.participants = const [],
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
      isPrivate: json['isPrivate'],
      privateCode: json['privateCode'],
      challengeName: json['challengeName'] ?? '',
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
      participants: (json['participants'] as List<dynamic>?)
          ?.map((e) => Participant.fromJson(e))
          .toList() ??
          [],
      challengeImagePaths: (json['challengeImagePaths'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      failedVerificationImage: json['failedVerificationImage'],
      successfulVerificationImage: json['successfulVerificationImage'],
      status: json['status'],
      totalParticipants: json['totalParticipants'] ?? 0,
      certificationType:
      CertificationTypeExtension.fromJson(json['certificationType']),
      challengeCategory:
      ChallengeCategoryExtension.fromJson(json['challengeCategory']),
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
      'startDate': startDate.toIso8601String(),
      'endDate': endDate.toIso8601String(),
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

  static Challenge getDummyData() {
    return Challenge(
      id: 1,
      isPrivate: false,
      privateCode: "123456",
      challengeName: "Dummy Challenge",
      challengeExplanation: "This is a dummy challenge for testing purposes.",
      challengePeriod: 30,
      startDate: DateTime.now(),
      endDate: DateTime.now().add(Duration(days: 30)),
      certificationFrequency: "daily",
      certificationStartTime: 6,
      certificationEndTime: 22,
      certificationExplanation: "Please upload your daily certification.",
      isGalleryPossible: true,
      maximumPeople: 100,
      participants: [
        Participant(id: 1, name: "John Doe"),
        Participant(id: 2, name: "Jane Doe")
      ],
      challengeImagePaths: ["path/to/image1.jpg", "path/to/image2.jpg"],
      failedVerificationImage: "path/to/failed_image.jpg",
      successfulVerificationImage: "path/to/successful_image.jpg",
      status: "active",
      totalParticipants: 2,
      certificationType: CertificationType.HAND_GESTURE,
      challengeCategory: ChallengeCategory.CATEGORY_ONE,
      totalCertificationCount: 30,
    );
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
