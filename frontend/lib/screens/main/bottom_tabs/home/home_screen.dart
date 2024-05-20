import 'package:flutter/material.dart';
import 'package:frontend/screens/main/bottom_tabs/home/home_list_widgets/home_challenge_list.dart';
import 'package:frontend/screens/main/bottom_tabs/home/home_top_box_widgets/home_top_stack_box.dart';
import 'package:frontend/screens/main/bottom_tabs/home/home_category_widgets/home_category_component.dart';
import 'package:frontend/screens/main/bottom_tabs/home/home_top_box_widgets/home_appBar.dart';

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
          child: homeAppBar,
        ),
        body: const SingleChildScrollView(
            child: Column(
          children: [
            ChallengeTopStack(),
            SizedBox(height: 10),
            HomeCategory(),
            SizedBox(height: 10),
            ChallengeItemList()
          ],
        )));
  }
}
