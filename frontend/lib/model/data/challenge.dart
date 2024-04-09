import 'dart:convert';
import 'dart:io';

class Challenge {
  late bool isPrivate;
  late String privateCode;
  late String challengeName;
  late String challengeExplanation;
  late File? challengeImage1;
  late File? challengeImage2;
  late File? challengeImage3;
  late File? challengeImage4;
  late File? challengeImage5;
  late String challengePeriod;
  late String startDate;
  late String certificationFrequency;
  late int certificationStartTime;
  late String certificationEndTime;
  late String certificationExplanation;
  late bool isGalleryPossible;
  late File? failedVerificationImage;
  late File? successfulVerificationImage;
  late int maximumPeople;
  late List<Participant> participants;

  Challenge({
    required this.isPrivate,
    required this.privateCode,
    required this.challengeName,
    required this.challengeExplanation,
    this.challengeImage1,
    this.challengeImage2,
    this.challengeImage3,
    this.challengeImage4,
    this.challengeImage5,
    required this.challengePeriod,
    required this.startDate,
    required this.certificationFrequency,
    required this.certificationStartTime,
    required this.certificationEndTime,
    required this.certificationExplanation,
    required this.isGalleryPossible,
    this.failedVerificationImage,
    this.successfulVerificationImage,
    required this.maximumPeople,
    required this.participants,
  });

  factory Challenge.fromJson(Map<String, dynamic> json) {
    return Challenge(
      isPrivate: json['is_private'],
      privateCode: json['private_code'],
      challengeName: json['challenge_name'],
      challengeExplanation: json['challenge_explanation'],
      challengePeriod: json['challenge_period'],
      startDate: json['start_date'],
      certificationFrequency: json['certification_frequency'],
      certificationStartTime: json['certification_start_time'],
      certificationEndTime: json['certification_end_time'],
      certificationExplanation: json['certification_explanation'],
      isGalleryPossible: json['is_gallery_possible'],
      maximumPeople: json['maximum_people'],
      participants: (json['participants'] as List<dynamic>)
          .map((e) => Participant.fromJson(e))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_private': isPrivate,
      'private_code': privateCode,
      'challenge_name': challengeName,
      'challenge_explanation': challengeExplanation,
      'challenge_period': challengePeriod,
      'start_date': startDate,
      'certification_frequency': certificationFrequency,
      'certification_start_time': certificationStartTime,
      'certification_end_time': certificationEndTime,
      'certification_explanation': certificationExplanation,
      'is_gallery_possible': isGalleryPossible,
      'maximum_people': maximumPeople,
      'participants': participants.map((e) => e.toJson()).toList(),
    };
  }
}

class Participant {
  late int participantId;
  late Challenge challenge;

  Participant({
    required this.participantId,
    required this.challenge,
  });

  factory Participant.fromJson(Map<String, dynamic> json) {
    return Participant(
      participantId: json['participant_id'],
      challenge: Challenge.fromJson(json['challenge']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'participant_id': participantId,
      'challenge': challenge.toJson(),
    };
  }
}
