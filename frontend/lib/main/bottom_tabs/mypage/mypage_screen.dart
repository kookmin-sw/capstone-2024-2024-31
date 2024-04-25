import 'package:flutter/material.dart';
import 'package:frontend/main/bottom_tabs/mypage/mypage_user_inform.dart';

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
          )
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              UserInformation()
            ],
          ),
        ));
  }
}
