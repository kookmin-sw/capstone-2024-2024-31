import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:frontend/main/main_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/env.dart';
import 'package:http/http.dart' as http;
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/user.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late BuildContext scaffoldContext;
  bool isPressGoogleLogin = false;
  bool isSuccessGoogleLogin = false;
  final logger = Logger();

  Future<void> _pressGoogleLoginButton() async {
    const callbackUrlScheme = "web-auth-callback";

    final url = Uri.parse("${Env.serverUrlNip}/oauth2/authorization/google");

    final result = await FlutterWebAuth2.authenticate(
        url: url.toString(), callbackUrlScheme: callbackUrlScheme);

    final accessToken = Uri.parse(result).queryParameters["access_token"];
    logger.d("access_token: $accessToken \n url : $url");

    if (accessToken != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("access_token", accessToken);
    }

    bool isLoginSuccess = await _getUserData();
    if (isLoginSuccess) {
      logger.d(' 구글 로그인 성공 👋');
      Get.offAll(() => const MainScreen());
    }
  }

  Future<bool> _getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    const String url = '${Env.serverUrl}/users/me';

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      UserController userController = Get.find<UserController>();
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      final User user = User.fromJson(data);
      userController.saveUser(user);
      return true;
    }

    Get.snackbar('로그인 실패', '다시 로그인해주세요');
    return false;
  }

  @override
  Widget build(BuildContext context) {
    scaffoldContext = context;

    return WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
            ),
            backgroundColor: Palette.mainPurple,
            body: Container(
              width: double.infinity,
              padding: const EdgeInsets.only(left: 30, right: 30, bottom: 20),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 100),
                    Image.asset(
                      'assets/images/logo/logo_white.png',
                      height: 220,
                    ),
                    const Spacer(),
                    _googleLoginButton(),
                    const SizedBox(
                      height: 20,
                    ),
                    _naverLoginButton(),
                    const SizedBox(
                      height: 40,
                    ),
                  ]),
            )));
  }

// UI: 구글 로그인 버튼
  Widget _googleLoginButton() {
    return GestureDetector(
      onTap: _pressGoogleLoginButton,
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
            color: const Color(0XFFFFFFFF),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/login_btn/google_symbol.png',
              height: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              '구글 로그인 ',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.black.withOpacity(0.85)),
            )
          ],
        ),
      ),
    );
  }

  // UI: 네이버 로그인 버튼
  Widget _naverLoginButton() {
    return GestureDetector(
      onTap: () async {
        //  네이버 로그인 버튼 클릭시
        print("네이버 로그인 버튼 클릭");
        // Navigator.pushNamed(scaffoldContext, 'signUp');
      },
      child: Container(
        alignment: Alignment.center,
        width: double.infinity,
        height: 45,
        decoration: BoxDecoration(
            color: const Color(0XFFFFFFFF),
            borderRadius: BorderRadius.circular(15)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/login_btn/naver_symbol.png',
              height: 30,
            ),
            const SizedBox(
              width: 10,
            ),
            Text(
              '네이버 로그인 ',
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 17,
                  color: Colors.black.withOpacity(0.85)),
            )
          ],
        ),
      ),
    );
  }
}
