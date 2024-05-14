import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:frontend/main/main_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:logger/logger.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/env.dart';

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
      logger.d(' 구글 로그인 성공 👋');
      Get.offAll(() => MainScreen());
      return;
    }

    logger.d(' 구글 로그인 실패 😭');
    Get.snackbar('로그인 실패', '다시 시도해주세요',
        backgroundColor: Colors.red, colorText: Colors.white);
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
