import 'package:flutter/material.dart';
import 'package:frontend/screens/challenge/detail/challenge_detail_screen.dart';
import 'package:frontend/screens/main/main_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:get/get.dart';

class CreateCompleteScreen extends StatelessWidget {
  final int challengeId;

  const CreateCompleteScreen({super.key, required this.challengeId});

  TextStyle buttonTextStyle(Color? textColor) => TextStyle(
      fontWeight: FontWeight.w500, fontFamily: "Pretender", color: textColor);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Center(
            child: Icon(Icons.check_circle_rounded,
                color: Palette.mainPurple, size: 100)),
        const SizedBox(height: 20),
        const Text(
          "성공적으로 챌린지가 \n생성됐어요!",
          textAlign: TextAlign.center,
          style: TextStyle(
              fontFamily: "Pretender",
              fontSize: 25,
              color: Palette.grey300,
              fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 50),
        GestureDetector(
            onTap: () {
              ChallengeService.fetchChallenge(challengeId).then((challenge) {
                Get.offAll(ChallengeDetailScreen(
                  challenge: challenge,
                ));
              });
            },
            child: Container(
                alignment: Alignment.center,
                width: screenSize.width * 0.6,
                height: 55,
                decoration: BoxDecoration(
                    color: Palette.mainPurple,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Palette.white)),
                child:
                    Text("챌린지 자세히 보기", style: buttonTextStyle(Palette.white)))),
        const SizedBox(height: 10),
        GestureDetector(
            onTap: () {
              Get.offAll(const MainScreen(
                tabNumber: 0,
              ));
            },
            child: Container(
                width: screenSize.width * 0.6,
                height: 55,
                decoration: BoxDecoration(
                    color: Palette.grey200,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Palette.white)),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.home, color: Palette.white, size: 30),
                    const SizedBox(width: 5),
                    Text("홈으로", style: buttonTextStyle(Palette.white))
                  ],
                )))
      ],
    ));
  }
}
