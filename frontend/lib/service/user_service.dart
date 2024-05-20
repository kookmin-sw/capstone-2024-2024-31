import 'package:dio/dio.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/user.dart';
import 'package:frontend/service/dio_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserService {
  static final Dio dio = DioService().dio;
  static final Logger logger = Logger();

  static Future<User> fetchUser() async {
    final prefs = await SharedPreferences.getInstance();
    final userController = Get.find<UserController>();
    const String uri = '/users/me';

    try {
      final response = await dio.get(uri);

      if (response.statusCode == 200) {
        logger.d("유저 조회 성공: ${response.data}");
        final User user = User.fromJson(response.data);
        userController.saveUser(user);

        const nxtUri = '/users/me/challenges';
        final responseMyChallenges = await dio.get(nxtUri);

        if (responseMyChallenges.statusCode == 200) {
          logger.d("나의 챌린지 조회 성공: ${responseMyChallenges.data}");
          userController.updateMyChallenges(responseMyChallenges.data);
        }
        return userController.user;
      }
    } catch (err) {
      throw Exception("유저 조회 실패: $err");
    }

    await prefs.remove("access_token");
    throw Exception("유저 조회 실패");
  }
}
