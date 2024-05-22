import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:frontend/screens/main/bottom_tabs/myRoutineUp/widget/my_routine_widget.dart';
import 'package:frontend/screens/main/bottom_tabs/myRoutineUp/widget/progress_widget.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class MyRoutineUpScreen extends StatefulWidget {
  const MyRoutineUpScreen({super.key});

  @override
  State<MyRoutineUpScreen> createState() => _MyRoutineUpScreenState();
}

class _MyRoutineUpScreenState extends State<MyRoutineUpScreen> {
  final controller = Get.find<UserController>();

  List<ChallengeSimple> beforeChallenge = [];
  List<ChallengeSimple> ingChallenge = [];
  List<ChallengeSimple> endChallenge = [];

  Logger logger = Logger();

  List<int> _getProgressNumber() {
    return [beforeChallenge.length, ingChallenge.length, endChallenge.length];
  }

  @override
  void initState() {
    super.initState();

    // 상태바 스타일 설정
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Palette.mainPurple,
        statusBarIconBrightness: Brightness.light,
      ),
    );

    for (var challenge in controller.myChallenges) {
      if (challenge.status == "진행전") {
        beforeChallenge.add(challenge);
      } else if (challenge.status == "진행중") {
        ingChallenge.add(challenge);
      } else {
        endChallenge.add(challenge);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Palette.mainPurple,
        title: const Text(
          '나의 루틴업 현황',
          style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              color: Palette.white,
              fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Palette.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 10),
            ChallengeProgressWidget(
                challengeProgressNumberList: _getProgressNumber()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ChallengeWidget(
                  //진행중 챌린지
                  isIng: true,
                  isStarted: true,
                  challenges: ingChallenge),
            ),
            const Divider(
              height: 10,
              thickness: 3,
              indent: 20,
              endIndent: 20,
              color: Palette.grey50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ChallengeWidget(
                isIng: false,
                isStarted: false,
                challenges: beforeChallenge,
              ),
            ),
            const Divider(
              height: 10,
              thickness: 3,
              indent: 20,
              endIndent: 20,
              color: Palette.grey50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ChallengeWidget(
                  isIng: false, isStarted: true, challenges: endChallenge),
            )
          ],
        ),
      ),
    );
  }
}
