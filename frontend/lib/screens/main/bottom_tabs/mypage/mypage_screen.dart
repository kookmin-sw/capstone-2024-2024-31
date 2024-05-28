import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/screens/main/bottom_tabs/mypage/mypage_pupleBtnBox.dart';
import 'package:frontend/screens/main/bottom_tabs/mypage/widget/mypage_user_inform.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {

  @override
  void initState() {
    super.initState();
    // 상태바 스타일 설정
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Palette.white,
        statusBarIconBrightness: Brightness.dark,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Palette.white,
            // AppBar를 투명하게 설정
            elevation: 0,
            // 그림자 없애기
            title: const Text(
              '마이페이지',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                fontFamily: 'Pretendard',
                color: Colors.black
              ),
            )),
        body: SingleChildScrollView(
            child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [
              UserInformation(),
              const SizedBox(height: 5),
              PurpleThreeBox(),
              TextButton(
                onPressed: () async {
                  final SharedPreferences prefs =
                      await SharedPreferences.getInstance();
                  prefs.remove('access_token');
                  Get.offAll(const LoginScreen());
                },
                child: const Text(
                  '로그아웃',
                  selectionColor: Colors.black,
                ),
              ),
            ],
          ),
        )));
  }
}
