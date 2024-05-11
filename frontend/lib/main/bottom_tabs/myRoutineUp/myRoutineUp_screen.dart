import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/community/community_screen.dart';
import 'package:frontend/main/bottom_tabs/myRoutineUp/widget/myroutineWidget.dart';
import 'package:frontend/main/bottom_tabs/myRoutineUp/widget/myroutineup_card.dart';
import 'package:frontend/main/bottom_tabs/myRoutineUp/widget/progress_widget.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';

class MyRoutineUpScreen extends StatefulWidget {
  const MyRoutineUpScreen({super.key});

  @override
  State<MyRoutineUpScreen> createState() => _MyRoutineUpScreenState();
}

class _MyRoutineUpScreenState extends State<MyRoutineUpScreen> {

  // @override
  // void initState() {
  //   super.initState();
  //   if (_isCompleted) {
  //     _viewChallengeList = complete_challengeList;
  //     _isCompleted = true;
  //   } else {
  //     _viewChallengeList = ing_challengeList;
  //     _isCompleted = false;
  //   }
  // }

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
            fontWeight: FontWeight.w600
          ),
        ),
      ),
      backgroundColor: Palette.white,
      body: const SingleChildScrollView(
        child: Column(
          children: [
            ChallengeProgressWidget(challengeProgressNumberList: [0,6,3]),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ChallengeWidget(isIng: false, isStarted: false),
            ),
            Divider(height: 10,thickness: 3, indent: 20, endIndent: 20, color: Palette.grey50,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ChallengeWidget(isIng: true, isStarted: true),
            ),
            Divider(height: 10,thickness: 3, indent: 20, endIndent: 20, color: Palette.grey50,),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ChallengeWidget(isIng:false, isStarted: true),
            )
          ],
        ),
      ),
    );
  }

}
