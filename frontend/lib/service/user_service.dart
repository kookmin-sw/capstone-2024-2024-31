import 'package:dio/dio.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/challenge/challenge_category.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:frontend/model/data/user.dart';
import 'package:frontend/service/challenge_service.dart';
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

        List<ChallengeSimple> myChallengeSimples =
            await ChallengeService.fetchMyChallengeSimples();
        userController.updateMyChallenges(myChallengeSimples);
        return userController.user;
      }
    } catch (err) {
      throw Exception("유저 조회 실패: $err");
    }

    await prefs.remove("access_token");
    throw Exception("유저 조회 실패");
  }

  static Future<void> updateMyCategory(
      List<ChallengeCategory> categories) async {
    final userController = Get.find<UserController>();

    const uri = '/users/category';

    try {
      final response = await dio.post(uri, data: {
        'categories': categories.map((category) => category.name).toList(),
      });

      if (response.statusCode == 200) {
        logger.d("유저 관심 카테고리 업데이트 성공: ${response.data}");
        userController.updateCategories(categories);
        return;
      } else {
        throw Exception("유저 관심 카테고리 업데이트 실패: ${response.data}");
      }
    } catch (err) {
      throw Exception("유저 관심 카테고리 업데이트 실패: $err");
    }
  }
}
