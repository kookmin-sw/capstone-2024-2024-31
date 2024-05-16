import 'dart:io';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:frontend/model/data/challenge/challenge_form.dart';
import 'package:http_parser/http_parser.dart';
import 'package:intl/intl.dart';

class ChallengeFormController extends GetxController {
  final _form = ChallengeForm(
    isPrivate: false,
    privateCode: "",
    challengeName: "",
    challengeExplanation: "",
    challengeImages: [],
    challengePeriod: "",
    challengeCategory: "",
    startDate: DateFormat('yyyy-MM-dd').format(DateTime.now()),  // ISO 8601 형식으로 변환
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

  dio.FormData toFormData() {
    String jsonData = jsonEncode({
      "isPrivate": form.isPrivate,
      "privateCode" : form.privateCode,
      "challengeName": form.challengeName,
      "challengeExplanation": form.challengeExplanation,
      "challengePeriod": form.challengePeriod,
      "challengeCategory": form.challengeCategory,
      "startDate": form.startDate,
      "certificationFrequency": form.certificationFrequency,
      "certificationStartTime": form.certificationStartTime,
      "certificationEndTime": form.certificationEndTime,
      "certificationExplanation": form.certificationExplanation,
      "isGalleryPossible": form.isGalleryPossible,
      "maximumPeople": form.maximumPeople,
    });

    if (kDebugMode) {
      print('JSON Data: $jsonData');
    }

    return dio.FormData.fromMap({
      "json": jsonData,
      "images": form.challengeImages
          .map((image) => dio.MultipartFile.fromFileSync(image.path,
              contentType: MediaType('image', 'jpeg')))
          .toList(),
      "failedImage": form.failedVerificationImage != null
          ? dio.MultipartFile.fromFileSync(form.failedVerificationImage!.path,
              contentType: MediaType('image', 'jpeg'))
          : null,
      "successImage": form.successfulVerificationImage != null
          ? dio.MultipartFile.fromFileSync(
              form.successfulVerificationImage!.path,
              contentType: MediaType('image', 'jpeg'))
          : null,
    });
  }

  void printFormData() {
    final formData = toFormData();
    print('FormData:');
    for (var field in formData.fields) {
      print('Field: ${field.key} = ${field.value}');
    }
    for (var file in formData.files) {
      print('File: ${file.key} = ${file.value.filename}');
    }
  }
}
