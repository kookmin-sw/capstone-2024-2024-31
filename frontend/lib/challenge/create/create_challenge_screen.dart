import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/create/create_body_part1.dart';
import 'package:frontend/challenge/create/create_body_part2.dart';
import 'package:frontend/challenge/create/create_body_part3.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';

class CreateChallenge extends StatefulWidget {
  const CreateChallenge({Key? key});

  @override
  State<CreateChallenge> createState() => _CreateChallengeState();
}

class _CreateChallengeState extends State<CreateChallenge> {
  late Challenge newChallenge = Challenge(isPrivate: false,
      privateCode: '',
      challengeName: '',
      challengeExplanation: '',
      challengePeriod: '',
      startDate: '',
      certificationFrequency: '',
      certificationStartTime: 88,
      certificationEndTime: '',
      certificationExplanation: '',
      isGalleryPossible: false, maximumPeople: 0, participants: []);

  bool? isPrivateSelected;

  bool showAdditionalWidgets =
  false; // Added state to control the visibility of additional widgets

  bool showPart1 = true;
  bool showPart2 = false;
  bool showPart3 = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

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
                print(isPrivateSelected);
                print("```````````${newChallenge.privateCode}");
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
        isPrivateSelected: isPrivateSelected,
        onPrivateButtonPressed: (bool isPrivate, String _privateCode) {
          setState(() {
            isPrivateSelected = isPrivate;
            newChallenge.isPrivate = isPrivate;
            if (isPrivate) {
              newChallenge.privateCode = _privateCode;
            } else {
              newChallenge.privateCode = "";
            }
          });
        },
      )
          : (showPart1 == false && showPart2)
          ? BodyPart2()
          : (showPart1 == false && showPart2 == false && showPart3)
        ? BodyPart3()
          :SizedBox(height: 10)
    );
  }

}
