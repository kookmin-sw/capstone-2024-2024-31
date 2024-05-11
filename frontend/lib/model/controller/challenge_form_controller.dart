import 'dart:io';

import 'package:get/get.dart';
import 'package:frontend/model/data/challenge_form.dart';

class ChallengeFormController extends GetxController {
  final _form = ChallengeForm(
    isPrivate: false,
    challengeName: "",
    challengeExplanation: "",
    challengeImages: [],
    challengePeriod: "",
    challengeCategory: "",
    startDate: DateTime.now().toString(),
    certificationFrequency: "매일",
    certificationStartTime: "0",
    certificationEndTime: "24",
    certificationExplanation: "",
    isGalleryPossible: false,
    failedVerificationImage: null,
    successfulVerificationImage: null,
    maximumPeople: 0,
  ).obs;

  ChallengeForm get form => _form.value;

  void updateIsPrivate(bool isPrivate) {
    _form.update((val) {
      val?.isPrivate = isPrivate;
    });
  }

  void updatePrivateCode(String privateCode) {
    _form.update((val) {
      val?.privateCode = privateCode;
    });
  }

  void updateChallengeName(String challengeName) {
    _form.update((val) {
      val?.challengeName = challengeName;
    });
  }

  void updateChallengeExplanation(String challengeExplanation) {
    _form.update((val) {
      val?.challengeExplanation = challengeExplanation;
    });
  }

  void updateChallengeImages(List<File> challengeImages) {
    _form.update((val) {
      val?.challengeImages = challengeImages;
    });
  }

  void removeChallengeImageByIndex(int index) {
    _form.update((val) {
      val?.challengeImages.removeAt(index);
    });
  }

  void updateChallengePeriod(String challengePeriod) {
    _form.update((val) {
      val?.challengePeriod = challengePeriod;
    });
  }

  void updateChallengeCategory(String challengeCategory) {
    _form.update((val) {
      val?.challengeCategory = challengeCategory;
    });
  }

  void updateStartDate(String startDate) {
    _form.update((val) {
      val?.startDate = startDate;
    });
  }

  void updateCertificationFrequency(String certificationFrequency) {
    _form.update((val) {
      val?.certificationFrequency = certificationFrequency;
    });
  }

  void updateCertificationStartTime(String certificationStartTime) {
    _form.update((val) {
      val?.certificationStartTime = certificationStartTime;
    });
  }

  void updateCertificationEndTime(String certificationEndTime) {
    _form.update((val) {
      val?.certificationEndTime = certificationEndTime;
    });
  }

  void updateCertificationExplanation(String certificationExplanation) {
    _form.update((val) {
      val?.certificationExplanation = certificationExplanation;
    });
  }

  void updateIsGalleryPossible(bool isGalleryPossible) {
    _form.update((val) {
      val?.isGalleryPossible = isGalleryPossible;
    });
  }

  void updateFailedVerificationImage(File failedVerificationImage) {
    _form.update((val) {
      val?.failedVerificationImage = failedVerificationImage;
    });
  }

  void updateSuccessfulVerificationImage(File successfulVerificationImage) {
    _form.update((val) {
      val?.successfulVerificationImage = successfulVerificationImage;
    });
  }

  void updateMaximumPeople(int maximumPeople) {
    _form.update((val) {
      val?.maximumPeople = maximumPeople;
    });
  }
}
