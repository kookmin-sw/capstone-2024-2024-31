import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_imformation.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_photoes.dart';
import 'package:frontend/model/data/challenge.dart';

class JoinChallengeScreen extends StatefulWidget {
  const JoinChallengeScreen({super.key});

  @override
  State<JoinChallengeScreen> createState() => _JoinChallengeScreenState();
}

class _JoinChallengeScreenState extends State<JoinChallengeScreen> {

  Challenge challenge = Challenge(
      isPrivate: false,
      privateCode: 'privateCode',
      challengeName: '조깅 3KM 하기',
      challengeExplanation:
      '챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라',
      challengePeriod: '8',
      startDate: '2024-04-08',
      certificationFrequency: '평일 매일',
      certificationStartTime: 1,
      certificationEndTime: '24시',
      certificationExplanation:
      '인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~',
      successfulVerificationImage:

      File("C:\Users\82103\Pictures\Screenshots\image.png"),
      failedVerificationImage:
      File("C:\Users\82103\Pictures\Screenshots\image.png"),
      challengeImage1: File("C:\Users\82103\Pictures\Screenshots\image.png"),
      challengeImage2: File("C:\Users\82103\Pictures\Screenshots\image.png"),
      isGalleryPossible: true,
      maximumPeople: 100,
      participants: []);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {},
          ),
          title: const Text(
            '챌린지 참여하기',
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

            },
            child: SvgPicture.asset(
              'assets/svgs/join_challenge_btn.svg',
              // width: double.infinity,
              // height: 30,
            ),
          ),
        ),
        body:
SingleChildScrollView(
  child: Column(
    children: [
      PhotoesWidget(screenHeight: screenSize.height, imageUrl: challenge.challengeImage1.toString()),
      InformationWidget(challenge: challenge)
    ],
  ),
)
    );

  }
}
