import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_information.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_photoes.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';

class JoinChallengeScreen extends StatefulWidget {
  final Challenge challenge;
  const JoinChallengeScreen({super.key, required this.challenge});

  @override
  State<JoinChallengeScreen> createState() => _JoinChallengeScreenState();
}

class _JoinChallengeScreenState extends State<JoinChallengeScreen> {


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
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
            child: Column(
            children: [
              PhotoesWidget(screenHeight: screenSize.height, imageUrl: widget.challenge.challengeImage1.toString()),
              InformationWidget(challenge: widget.challenge),
              Divider(thickness: 10, color: Palette.greySoft)
            ],
          )),
        )
    );

  }
}