import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:frontend/screens/community/create_posting_screen.dart';
import 'package:frontend/screens/main/bottom_tabs/home/home_top_box_widgets/home_state_card.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:frontend/screens/challenge/state/state_challenge_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class ChallengeStateBox extends StatefulWidget {
  const ChallengeStateBox({super.key});

  @override
  State<ChallengeStateBox> createState() => _ChallengeStateBoxState();
}

class _ChallengeStateBoxState extends State<ChallengeStateBox> {
  final logger = Logger();
  final controller = Get.find<UserController>();
  final List<ChallengeSimple> challengeSimples = [];


  @override
  void initState() {
    super.initState();
    setState(() {
      challengeSimples.clear();
      challengeSimples.addAll(
          controller.myChallenges.where((c) => c.status == "진행중").toList());

    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 195,
      decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Palette.greyBG)),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // 내부 패딩을 없앰
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text("내 진행중인 챌린지",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  color: Palette.grey500,
                  fontSize: 14,
                )),
            onPressed: () {},
          ),
          const Text(
            "챌린지를 진행하고 인증을 완료해 주세요!",
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: Colors.grey),
          ),
          const SizedBox(height: 10),
          challengeSimples.isEmpty
              ? Center(child: SvgPicture.asset("assets/svgs/no_challenge_state_card.svg"))
              : Expanded(
                  child: Swiper(
                    loop: false,
                    itemCount: challengeSimples.length,
                    pagination: const SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.all(1.0),
                      builder: DotSwiperPaginationBuilder(
                          space: 3,
                          size: 9,
                          activeSize: 9,
                          color: Palette.softPurPle,
                          activeColor: Palette.purPle300),
                    ),
                    itemBuilder: (context, index) {
                      return Column(children: [
                        HomeChallengeStateCard(challengeSimple: challengeSimples[index], screenWidth: screenWidth),
                        const SizedBox(height: 15)
                      ]);
                    },
                  ),
                ),
        ],
      ),
    );
  }

}
