import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/create/create_body_part1.dart';
import 'package:frontend/challenge/create/create_body_part2.dart';
import 'package:frontend/model/config/palette.dart';

class CreateChallenge extends StatefulWidget {
  const CreateChallenge({Key? key});

  @override
  State<CreateChallenge> createState() => _CreateChallengeState();
}

class _CreateChallengeState extends State<CreateChallenge> {
  bool? isPublicSelected; // Changed to nullable bool
  bool showAdditionalWidgets =
      false; // Added state to control the visibility of additional widgets

  bool showPart1 = true;
  bool showPart2 = false;
  bool showPart3 = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {},
          ),
          title: const Text(
            '챌린지 생성하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          color: Colors.transparent,
          width: double.infinity,
          child: InkWell(
            onTap: () {
              setState(() {
                if (showPart1) {
                  showPart1 = false;
                  showPart2 = true;
                } else if (showPart2) {
                  showPart2 = false;
                  showPart3 = true;
                }
              });
            },
            child: SvgPicture.asset(
              'assets/svgs/create_challenge_btn.svg',
              // width: double.infinity,
              // height: 30,
            ),
          ),
        ),
        body: (showPart1)
            ? BodyPart1(
                isPublicSelected: isPublicSelected,
                showAdditionalWidgets: showAdditionalWidgets,
                onDisclosureButtonPressed: (bool isPublic, bool showWidgets) {
                  setState(() {
                    isPublicSelected = isPublic;
                    showAdditionalWidgets = showWidgets;
                  });
                },
              )
            : (showPart1 == false && showPart2)
                ? BodyPart2()
                : SizedBox(height: 10));
  }
}
