import 'package:flutter/material.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_challenge_list.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_top_stack_box.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_category_component.dart';
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
          preferredSize: const Size.fromHeight(60), // 이미지의 높이에 맞춰서 설정
          child: home_appBar,
        ),
        body: SingleChildScrollView(
            child: Column(
          children: [
            const ChallengeTopStack(),
            const SizedBox(height: 35),
            Home_Category(),
            const SizedBox(height: 10),
            ChallengeItemList()
          ],
        )));
  }
}
