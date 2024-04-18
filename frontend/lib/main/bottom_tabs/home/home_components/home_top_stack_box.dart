import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_challenge_recommend_box.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_challenge_state_box.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallengeTopStack extends StatefulWidget {
  const ChallengeTopStack({Key? key}) : super(key: key);

  @override
  State<ChallengeTopStack> createState() => _ChallengeTopStackState();
}

class _ChallengeTopStackState extends State<ChallengeTopStack> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      children: [
        Column(mainAxisSize: MainAxisSize.min, children: [
          Container(
            child: ChallengeRecommendBox(name: '신혜은'),
          ),
          Container(height: 85, color: Palette.mainPurple),
          Container(height: 80, color: Colors.transparent),
        ]),
        Positioned(
          right: 0,
          left: 0,
          top: 130,
          child: ChallengeStateBox(),
        ),
      ],
    );
  }
}
