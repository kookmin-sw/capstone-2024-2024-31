import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/community/community_screen.dart';
import 'package:frontend/main/bottom_tabs/myRoutineUp/widget/myroutineup_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';

class MyRoutineUpScreen extends StatefulWidget {
  const MyRoutineUpScreen({super.key});

  @override
  State<MyRoutineUpScreen> createState() => _MyRoutineUpScreenState();
}

class _MyRoutineUpScreenState extends State<MyRoutineUpScreen> {
  int viewChallengeLength = 3;
  int additionalChallengesToShow =
      3; // Number of additional challenges to show when more_view_btn is tapped

  Challenge challenge = Challenge(
      isPrivate: false,
      privateCode: 'privateCode',
      challengeName: '조깅 3KM 진행하고 상금받자!',
      challengeExplanation:
          '챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라',
      challengePeriod: '8',
      startDate: '2024-04-08',
      certificationFrequency: '평일 매일',
      certificationStartTime: 1,
      certificationEndTime: '24시',
      certificationExplanation:
          '인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~',
      successfulVerificationImage: File("assets/images/image.png"),
      failedVerificationImage:
          File("C:/Users/82103/Pictures/Screenshots/image.png"),
      challengeImage1: File("C:/Users/82103/Pictures/Screenshots/image.png"),
      challengeImage2: File("C:/Users/82103/Pictures/Screenshots/image.png"),
      isGalleryPossible: true,
      maximumPeople: 100,
      participants: []);

  List<Map<String, dynamic>> ing_challengeList = [
    // {'name': '매일 커밋하기', 'percent': '50', 'image': 'assets/images/image.png'},
    // {'name': '매일 운동하기', 'percent': '10', 'image': 'assets/images/image.png'},
    // {'name': '매일 먹기', 'percent': '30', 'image': 'assets/images/image.png'},
    // {'name': '매일 커밋하기', 'percent': '50', 'image': 'assets/images/image.png'},
    // {'name': '매일 운동하기', 'percent': '10', 'image': 'assets/images/image.png'},
    // {'name': '매일 먹기', 'percent': '30', 'image': 'assets/images/image.png'},
  ];

  List<Map<String, dynamic>> complete_challengeList = [
    // {'name': '매일 커밋하기', 'percent': '50', 'image': 'assets/images/image.png'},
    // {'name': '매일 운동하기', 'percent': '10', 'image': 'assets/images/image.png'},
    // {'name': '매일 먹기', 'percent': '30', 'image': 'assets/images/image.png'},
  ];

  @override
  Widget build(BuildContext context) {
    if (ing_challengeList.length < viewChallengeLength) {
      viewChallengeLength = ing_challengeList.length;
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.greyBG,
        title: Text(
          '나의 루틴업',
          style: TextStyle(
            fontFamily: 'Pretendard',
            fontSize: 16,
          ),
        ),
      ),
      backgroundColor: Palette.greyBG,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ChallengeWidget(true),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
              child: ChallengeWidget(false),
            )
          ],
        ),
      ),
    );
  }

  Widget ChallengeWidget(bool isIng) {
    bool _isCompleted;
    List<Map<String, dynamic>> viewChallengeList = [];
    if (isIng) {
      viewChallengeList = ing_challengeList;
      _isCompleted = false;
    } else {
      viewChallengeList = complete_challengeList;
      _isCompleted = true;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isIng
            ? Text(
                "진행중 ${ing_challengeList.length}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10,
                    color: Palette.grey500,
                    fontWeight: FontWeight.bold),
              )
            : Text(
                "완료 ${complete_challengeList.length}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10,
                    color: Palette.grey200,
                    fontWeight: FontWeight.bold),
              ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: viewChallengeList.length == 0
              ? Container(
                  // decoration: BoxDecoration(
                  //   border: Border.all(
                  //     color: Palette.grey50, // 테두리 색상 설정
                  //     width: 1.0, // 테두리 너비 설정
                  //   ),
                  //   borderRadius: BorderRadius.circular(12)
                  // ),
                  child: _isCompleted
                      ? SvgPicture.asset(
                          "assets/svgs/no_complete_challenge.svg")
                      : SvgPicture.asset("assets/svgs/no_challenge_box.svg"),
                )
              : ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                    viewChallengeLength,
                    (index) {
                      return MyRoutineUpCard(
                          isCompleted: _isCompleted, challenge: challenge);
                    },
                  ),
                ),
        ),
        if (viewChallengeLength < viewChallengeList.length)
          Container(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            color: Colors.transparent,
            width: double.infinity,
            child: InkWell(
              onTap: () {
                setState(() {
                  if (viewChallengeLength + additionalChallengesToShow <=
                      viewChallengeList.length) {
                    viewChallengeLength += additionalChallengesToShow;
                  } else {
                    viewChallengeLength = viewChallengeList.length;
                  }
                });
              },
              child: SvgPicture.asset(
                'assets/svgs/more_view_btn.svg',
              ),
            ),
          ),
      ],
    );
  }
}
