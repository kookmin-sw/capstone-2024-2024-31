import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_challenge_recommend_box.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_challenge_state_box.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:get/get.dart';

class ChallengeTopStack extends StatefulWidget {
  const ChallengeTopStack({Key? key}) : super(key: key);

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
          Container(
            child: ChallengeRecommendBox(name: userController.user.name),
          ),
          Container(height: 100, color: Palette.mainPurple),
          Container(height: 80, color: Colors.transparent),
        ]),
        Positioned(
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
