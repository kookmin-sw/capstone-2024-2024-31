import 'package:dio/dio.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:frontend/env.dart';
import 'package:frontend/screens/main/main_screen.dart';
import 'package:frontend/service/dio_service.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginService {
  static final Logger logger = Logger();
  static final Dio dio = DioService().dio;

  static Future<void> googleLogin() async {
    const callbackUrlScheme = "web-auth-callback";

    final url = Uri.parse("${Env.serverUrlNip}/oauth2/authorization/google");

    final result = await FlutterWebAuth2.authenticate(
        url: url.toString(), callbackUrlScheme: callbackUrlScheme);

    final accessToken = Uri.parse(result).queryParameters["access_token"];
    logger.d("access_token: $accessToken \n url : $url");

    if (accessToken != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("access_token", accessToken);
      DioService.updateAccessToken(accessToken);
      logger.d(' 구글 로그인 성공 👋');
      return;
    }

    return Future.error("구글 로그인 실패");
  }
}
