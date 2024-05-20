import 'package:flutter/material.dart';
import 'package:frontend/screens/main/bottom_tabs/home/home_list_widgets/home_challenge_recommend_box.dart';
import 'package:frontend/screens/main/bottom_tabs/home/home_top_box_widgets/home_challenge_state_box.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:get/get.dart';

class ChallengeTopStack extends StatefulWidget {
  const ChallengeTopStack({super.key});

  @override
  State<ChallengeTopStack> createState() => _ChallengeTopStackState();
}

class _ChallengeTopStackState extends State<ChallengeTopStack> {
  final UserController userController = Get.find<UserController>();

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          ChallengeRecommendBox(name: userController.user.name),
          Container(height: 110, color: Palette.mainPurple),
          Container(height: 100, color: Colors.transparent),
        ]),
        const Positioned(
          right: 0,
          left: 0,
          top: 150,
          child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: ChallengeStateBox()),
        ),
      ],
    );
  }
}
