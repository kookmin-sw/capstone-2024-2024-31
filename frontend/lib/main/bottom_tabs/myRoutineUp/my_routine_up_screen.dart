import 'package:flutter/material.dart';
import 'package:frontend/main/bottom_tabs/myRoutineUp/widget/my_routine_widget.dart';
import 'package:frontend/main/bottom_tabs/myRoutineUp/widget/progress_widget.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:get/get.dart';

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

  List<int> _getProgressNumber() {
    return [beforeChallenge.length, ingChallenge.length, endChallenge.length];
  }

  @override
  void initState() {
    super.initState();
    for (var challenge in controller.myChallenges) {
      DateTime now = DateTime.now();
      DateTime startDate = DateTime.parse(challenge.startDate);
      if (startDate.isAfter(now)) {
        beforeChallenge.add(challenge);
      } else if (challenge.isEnded == false) {
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
        backgroundColor: Palette.white,
        title: const Text(
          '나의 루틴업 현황',
          style: TextStyle(
              fontFamily: 'Pretendard',
              fontSize: 16,
              fontWeight: FontWeight.w600),
        ),
      ),
      backgroundColor: Palette.white,
      body: SingleChildScrollView(
        child: Column(
          children: [
            ChallengeProgressWidget(
                challengeProgressNumberList: _getProgressNumber()),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ChallengeWidget(
                  isIng: true, isStarted: true, challenges: ingChallenge),
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
