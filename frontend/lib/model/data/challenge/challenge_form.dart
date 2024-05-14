import 'dart:io';

class ChallengeForm {
  late bool isPrivate;
  late String? privateCode;
  late String challengeName;
  late String challengeExplanation;
  late List<File> challengeImages;
  late String challengePeriod;
  late String challengeCategory;
  late String startDate;
  late String certificationFrequency;
  late String certificationStartTime;
  late String certificationEndTime;
  late String certificationExplanation;
  late bool isGalleryPossible;
  late File? failedVerificationImage;
  late File? successfulVerificationImage;
  late int maximumPeople;

  ChallengeForm({
    required this.isPrivate,
    this.privateCode,
    required this.challengeName,
    required this.challengeExplanation,
    required this.challengeImages,
    required this.challengePeriod,
    required this.challengeCategory,
    required this.startDate,
    required this.certificationFrequency,
    required this.certificationStartTime,
    required this.certificationEndTime,
    required this.certificationExplanation,
    required this.isGalleryPossible,
    required this.failedVerificationImage,
    required this.successfulVerificationImage,
    required this.maximumPeople,
  });
}
