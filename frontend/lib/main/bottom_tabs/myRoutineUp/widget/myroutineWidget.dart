import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/community/community_screen.dart';
import 'package:frontend/main/bottom_tabs/myRoutineUp/widget/myroutineup_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';

class ChallengeWidget extends StatefulWidget {
  final bool isIng;
  final bool isStarted;

  const ChallengeWidget(
      {super.key, required this.isIng, required this.isStarted});

  @override
  _ChallengeWidgetState createState() => _ChallengeWidgetState();
}

class _ChallengeWidgetState extends State<ChallengeWidget> {
  late List<Map<String, dynamic>> viewChallengeList;
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

  Challenge challenge = Challenge.getDummyData();

  int viewChallengeLength = 3;
  int additionalChallengesToShow = 3;

  @override
  void initState() {
    super.initState();
    if (widget.isIng) {
      viewChallengeList = ing_challengeList;
    } else {
      viewChallengeList = complete_challengeList;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        widget.isStarted
            ? widget.isIng
                ? Text(
                    "진행중 ${ing_challengeList.length}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 10,
                      color: Palette.grey500,
                      fontWeight: FontWeight.bold,
                    ),
                  )
                : Text(
                    "완료 ${complete_challengeList.length}",
                    textAlign: TextAlign.start,
                    style: const TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 10,
                      color: Palette.grey500,
                      fontWeight: FontWeight.bold,
                    ),
                  )
            : Text(
                "진행 전 ${complete_challengeList.length}",
                textAlign: TextAlign.start,
                style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  color: Palette.grey500,
                  fontWeight: FontWeight.bold,
                ),
              ),
        const SizedBox(height: 10),
        SizedBox(
          width: double.infinity,
          child: viewChallengeList.length == 0
              ? Container(
                  // If there are no challenges to display, show a placeholder.
                  child: widget.isStarted
                      ? widget.isIng
                          ? SvgPicture.asset(
                              "assets/svgs/no_challenge_state_card.svg")
                          : SvgPicture.asset(
                              "assets/svgs/no_complete_challenge_card.svg")
                      : SvgPicture.asset(
                          "assets/svgs/no_plan_challenge_card.svg"))
              : ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: List.generate(
                    viewChallengeLength,
                    (index) {
                      return MyRoutineUpCard(
                        isIng: widget.isIng,
                        isStarted: widget.isStarted,
                        challenge: challenge,
                      );
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
                    print(viewChallengeLength);
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
