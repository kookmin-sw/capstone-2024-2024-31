import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  late BuildContext scaffoldContext;

  bool isLoading = false;
  bool isKakaoClicked = false;

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
                padding: const EdgeInsets.only(left: 20, right: 20, bottom: 20),
                child:  Column(
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
      onTap: () async {
        //  구글 로그인 버튼 클릭시
        print("구글 로그인 버튼 클릭");
        // Navigator.pushNamed(scaffoldContext, 'signUp');
      },
      child: Container(
        alignment: Alignment.center,
        width: 200,
        child: Image.asset(
          'assets/images/google_login_btn.png',
          height: 50,
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
        width: 200,
        child:  Image.asset(
          'assets/images/naver_login_btn.png',
          height: 50,
        ),
      ),
    );
  }
}
