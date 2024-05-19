import 'package:frontend/model/data/challenge/challenge_category.dart';
import 'package:frontend/model/data/challenge/challenge_certification_type.dart';
import 'package:intl/intl.dart';

class Challenge {
  final int id;
  final String challengeName;
  final String challengeExplanation;
  final String startDate;
  final String endDate;
  final String certificationFrequency;
  final String certificationExplanation;
  final int challengePeriod;
  final int certificationStartTime;
  final int certificationEndTime;
  final int maximumPeople;
  final List<String> challengeImagePaths;
  final String failedVerificationImage;
  final String successfulVerificationImage;
  final String status;
  final ChallengeCertificationType certificationType;
  final ChallengeCategory challengeCategory;
  final int totalParticipants;
  final int? totalCertificationCount;
  final bool isPrivate;
  final bool isGalleryPossible;

  Challenge({
    required this.id,
    required this.isPrivate,
    required this.challengeName,
    required this.challengeExplanation,
    required this.startDate,
    required this.endDate,
    required this.challengePeriod,
    required this.certificationFrequency,
    required this.certificationStartTime,
    required this.certificationEndTime,
    required this.certificationExplanation,
    required this.isGalleryPossible,
    required this.maximumPeople,
    required this.challengeImagePaths,
    required this.failedVerificationImage,
    required this.successfulVerificationImage,
    required this.status,
    required this.totalParticipants,
    required this.certificationType,
    required this.challengeCategory,
    this.totalCertificationCount,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      id: json['id'],
      isPrivate: json['private'],
      challengeName: json['challengeName'] as String,
      challengeExplanation: json['challengeExplanation'] as String,
      startDate: json['startDate'] as String,
      endDate: json['endDate'] as String,
      challengePeriod: json['challengePeriod'],
      certificationFrequency: json['certificationFrequency'] as String,
      certificationStartTime: json['certificationStartTime'],
      certificationEndTime: json['certificationEndTime'],
      certificationExplanation: json['certificationExplanation'] as String,
      isGalleryPossible: json['galleryPossible'],
      maximumPeople: json['maximumPeople'],
      challengeImagePaths: (json['challengeImagePaths'] as List<dynamic>)
          .map((val) => val.toString())
          .toList(),
      failedVerificationImage: json['failedVerificationImage'] as String,
      successfulVerificationImage:
          json['successfulVerificationImage'] as String,
      status: json['status'] as String,
      totalParticipants: json['totalParticipants'],
      certificationType: ChallengeCertificationType.handGesture,
      challengeCategory:
          ChallengeCategory.fromJson(json['challengeCategory'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'isPrivate': isPrivate,
      'challengeName': challengeName,
      'challengeExplanation': challengeExplanation,
      'startDate': startDate,
      'endDate': endDate,
      'challengePeriod': challengePeriod,
      'certificationFrequency': certificationFrequency,
      'certificationStartTime': certificationStartTime,
      'certificationEndTime': certificationEndTime,
      'certificationExplanation': certificationExplanation,
      'isGalleryPossible': isGalleryPossible,
      'maximumPeople': maximumPeople,
      'challengeImagePaths': challengeImagePaths,
      'failedVerificationImage': failedVerificationImage,
      'successfulVerificationImage': successfulVerificationImage,
      'status': status,
      'totalParticipants': totalParticipants,
      'certificationType': certificationType.toJson(),
      'challengeCategory': challengeCategory.toJson(),
      'totalCertificationCount': totalCertificationCount,
    };
  }

  // Dummy data generator
  static Challenge getDummyData() {
    return Challenge(
      id: 1,
      isPrivate: false,
      challengeName: "Dummy Challenge",
      challengeExplanation: "This is a dummy challenge for testing purposes.",
      challengePeriod: 30,
      startDate: DateFormat("yyyy-MM-dd").format(DateTime.now()),
      endDate: DateFormat("yyyy-MM-dd")
          .format(DateTime.now().add(const Duration(days: 30))),
      certificationFrequency: "daily",
      certificationStartTime: 6,
      certificationEndTime: 22,
      certificationExplanation: "Please upload your daily certification.",
      isGalleryPossible: true,
      maximumPeople: 100,
      challengeImagePaths: ["path/to/image1.jpg", "path/to/image2.jpg"],
      failedVerificationImage: "path/to/failed_image.jpg",
      successfulVerificationImage: "path/to/successful_image.jpg",
      status: "active",
      totalParticipants: 2,
      certificationType: ChallengeCertificationType.handGesture,
      challengeCategory: ChallengeCategory.eating,
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
