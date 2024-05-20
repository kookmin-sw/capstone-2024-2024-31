import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../env.dart';
import '../data/challenge/challenge.dart';
import '../data/challenge/challenge_status.dart';

class ChallengeService {
  static final logger = Logger();

  static Future<Challenge?> fetchChallenge(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString('access_token')}';

    try {
      final response = await dio.get('${Env.serverUrl}/challenges/$id');
      if (response.statusCode == 200) {
        logger.d('챌린지 조회 성공: ${response.data}');
        return Challenge.fromJson(response.data);
      } else {
        logger.e('챌린지 조회 실패: ${response.data}');
      }
    } catch (e) {
      logger.e('챌린지 조회 실패: ${e.toString()}');
    }

    return null;
  }

  static Future<ChallengeStatus?> fetchChallengeStatus(int id) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString('access_token')}';

    try {
      final response = await dio.get('${Env.serverUrl}/challenges/$id/status');
      if (response.statusCode == 200) {
        return ChallengeStatus.fromJson(response.data);
      } else {
        logger.e("챌린지 상태 조회 실패: ${response.data}");
      }
    } catch (e) {
      logger.e(e);
    }

    return null;
  }
}
