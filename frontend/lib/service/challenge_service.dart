import 'package:dio/dio.dart';
import 'package:frontend/model/controller/challenge_form_controller.dart';
import 'package:frontend/model/data/challenge/challenge_filter.dart';
import 'package:frontend/model/data/challenge/challenge_join.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:frontend/model/data/sms/sms_certification.dart';
import 'package:frontend/service/dio_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../model/data/challenge/challenge.dart';
import '../model/data/challenge/challenge_status.dart';

class ChallengeService {
  static final Dio dio = DioService().dio;
  static final Logger logger = Logger();

  static Future<Challenge> fetchChallenge(int id, [String? code]) async {
    final String uri = '/challenges/$id';

    try {
      final response = await dio.get(uri, queryParameters: {'code': code});

      if (response.statusCode == 200) {
        logger.d('챌린지 조회 성공: ${response.data}');
        return Challenge.fromJson(response.data);
      } else {
        throw Exception('챌린지 조회 실패: ${response.data}');
      }
    } catch (e) {
      throw Exception('챌린지 조회 실패: ${e.toString()}');
    }
  }

  static Future<List<ChallengeSimple>> fetchChallengeSimples(
      int cursorId, int size, ChallengeFilter filter) async {
    const String uri = '/challenges/list';

    try {
      final response = await dio.get(uri,
          queryParameters: {
            'cursorId': cursorId,
            'size': size,
          },
          data: filter.toJson());

      if (response.statusCode == 200) {
        logger.d('챌린지 목록 조회 성공: ${response.data}');
        return (response.data as List)
            .map((e) => ChallengeSimple.fromJson(e))
            .toList();
      } else {
        throw Exception('챌린지 목록 조회 실패: ${response.data}');
      }
    } catch (e) {
      throw Exception('챌린지 목록 조회 실패: ${e.toString()}');
    }
  }

  static Future<List<ChallengeSimple>> fetchMyChallengeSimples() async {
    const String uri = '/users/me/challenges';

    try {
      final response = await dio.get(uri);

      if (response.statusCode == 200) {
        logger.d('내 챌린지 목록 조회 성공: ${response.data}');
        return (response.data as List)
            .map((e) => ChallengeSimple.fromJson(e))
            .toList();
      } else {
        throw Exception('내 챌린지 목록 조회 실패: ${response.data}');
      }
    } catch (e) {
      throw Exception('내 챌린지 목록 조회 실패: ${e.toString()}');
    }
  }

  static Future<ChallengeStatus> fetchChallengeStatus(int id) async {
    final String uri = '/challenges/$id/status';

    try {
      final response = await dio.get(uri);
      if (response.statusCode == 200) {
        logger.d('챌린지 상태 조회 성공: ${response.data}');
        return ChallengeStatus.fromJson(response.data);
      } else {
        throw Exception("챌린지 상태 조회 실패: ${response.data}");
      }
    } catch (e) {
      throw Exception('챌린지 상태 조회 실패: ${e.toString()}');
    }
  }

  static Future<ChallengeSimple> createChallenge() async {
    final ChallengeFormController challengeFormController = Get.find();
    const String uri = '/challenges/create';

    final formData = challengeFormController.toFormData();

    try {
      final response = await dio.post(uri, data: formData);
      if (response.statusCode == 200) {
        logger.d('챌린지 생성 성공: ${response.data}');
        return ChallengeSimple.fromJson(response.data);
      } else {
        throw Exception('챌린지 생성 실패: ${response.data}');
      }
    } catch (err) {
      throw Exception('챌린지 생성 실패: $err');
    }
  }

  static Future<void> joinChallenge(
      int challengeId, ChallengeJoin challengeJoin) async {
    final String uri = '/challenges/$challengeId/join';

    try {
      final response = await dio.post(uri, data: challengeJoin.toJson());

      if (response.statusCode == 201) {
        logger.d('챌린지 참가 성공');
      } else {
        throw Exception('챌린지 참가 실패: ${response.data}');
      }
    } catch (err) {
      throw Exception('챌린지 참가 실패: $err');
    }
  }

  static Future<void> sendCode(String number) async {
    const String uri = '/sms/send';

    try {
      final response =
          await dio.post(uri, data: SmsCertification(phone: number).toJson());

      if (response.statusCode == 200) {
        logger.d('인증번호 전송 성공: ${response.data}');
      } else {
        throw Exception('인증번호 전송 실패: ${response.data}');
      }
    } catch (err) {
      throw Exception('인증번호 전송 실패: $err');
    }
  }

  static Future<void> verifyCode(String number, String code) async {
    const uri = '/sms/confirm';

    try {
      final response = await dio.post(uri,
          data: SmsCertification(phone: number, certificationNumber: code)
              .toJson());

      if (response.statusCode == 200) {
        logger.d('인증번호 확인 성공: ${response.data}');
      }
    } catch (err) {
      throw Exception('인증번호 확인 실패: $err');
    }
  }
}
