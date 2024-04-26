import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:frontend/model/config/palette.dart';

import 'package:logger/logger.dart';
import 'package:flutter_web_auth_2/flutter_web_auth_2.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late BuildContext scaffoldContext;

  final logger = Logger();
  final API_SERVER_URL = "http://3.34.14.45.nip.io:8080";

  Future<void> _pressGoogleLoginButton() async {
    const callbackUrlScheme = "web-auth-callback";

    final url = Uri.parse("$API_SERVER_URL/oauth2/authorization/google");

    final result = await FlutterWebAuth2.authenticate(url: url.toString(), callbackUrlScheme: callbackUrlScheme);

    final accessToken = Uri.parse(result).queryParameters["access_token"];
    logger.d("access_token: $accessToken");

    if (accessToken != null) {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      prefs.setString("access_token", accessToken);

      logger.d("saved access_token!");
    }

    // TODO: 메인 화면으로 이동
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
