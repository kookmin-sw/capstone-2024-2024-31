import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../env.dart';
import 'challenge.dart';
import 'challenge_status.dart';

class ChallengeService {
  static Future<Challenge?> fetchChallenge(int id, Logger logger) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
    'Bearer ${prefs.getString('access_token')}';

    try {
      final response = await dio.get('${Env.serverUrl}/challenges/$id');
      if (response.statusCode == 200) {
        return Challenge.fromJson(response.data);
      } else {
        logger.e(response.data);
        return null;
      }
    } catch (e) {
      logger.e(e);
      return null;
    }
  }

  static Future<ChallengeStatus?> fetchChallengeStatus(int id, Logger logger) async {
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
        logger.e(response.data);
        return null;
      }
    } catch (e) {
      logger.e(e);
      return null;
    }
  }
}
