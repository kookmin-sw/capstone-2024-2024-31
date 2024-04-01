import 'package:flutter/material.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/chal_ingBox.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_appBar.dart';
import 'package:frontend/model/config/palette.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
          preferredSize: Size.fromHeight(80), // 이미지의 높이에 맞춰서 설정
          child: home_appBar,),
      body:
          Column(children: [
            ChallengeIngBox(),
            SizedBox(height: 10,)
          ],)

    );
  }
}
