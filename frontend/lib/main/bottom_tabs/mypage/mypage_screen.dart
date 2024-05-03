import 'package:flutter/material.dart';
import 'package:frontend/login/login_screen.dart';
import 'package:frontend/main/bottom_tabs/mypage/mypage_pupleBtnBox.dart';
import 'package:frontend/main/bottom_tabs/mypage/widget/mypage_user_inform.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyPageScreen extends StatefulWidget {
  const MyPageScreen({super.key});

  @override
  State<MyPageScreen> createState() => _MyPageScreenState();
}

class _MyPageScreenState extends State<MyPageScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.transparent,
            // AppBar를 투명하게 설정
            elevation: 0,
            // 그림자 없애기
            title: const Text(
              '마이페이지',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                fontFamily: 'Pretendard',
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
