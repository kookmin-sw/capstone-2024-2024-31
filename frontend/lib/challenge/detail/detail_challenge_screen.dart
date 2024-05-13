import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/challenge/detail/detail_imageDetail_screen.dart';
import 'package:frontend/challenge/detail/widgets/build_image_container.dart';
import 'package:frontend/challenge/detail/widgets/certification_method_widget.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_information.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_photoes.dart';
import 'package:frontend/challenge/join/join_challenge_screen.dart';
import 'package:frontend/main/main_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:get/get.dart';

class ChallengeDetailScreen extends StatelessWidget {
  final bool isFromMainScreen;

  ChallengeDetailScreen({super.key, required this.isFromMainScreen});

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
      successfulVerificationImage: File(
          '/data/user/0/com.routineUp.frontend/cache/992e048f-4ae7-4bf1-9a35-866086fbe0a4/1000009385.jpg'),
      failedVerificationImage: File(
          '/data/user/0/com.routineUp.frontend/cache/992e048f-4ae7-4bf1-9a35-866086fbe0a4/1000009385.jpg'),
      challengeImage1: File(
          '/data/user/0/com.routineUp.frontend/cache/992e048f-4ae7-4bf1-9a35-866086fbe0a4/1000009385.jpg'),
      challengeImage2: File(
          '/data/user/0/com.routineUp.frontend/cache/992e048f-4ae7-4bf1-9a35-866086fbe0a4/1000009385.jpg'),
      isGalleryPossible: true,
      maximumPeople: 100,
      participants: []);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    initializeDateFormatting('ko_KR', 'en_US');

    return Scaffold(
        appBar: AppBar(
          leading: isFromMainScreen
              ? IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Palette.grey300,
                  ),
                  onPressed: () {
                    Get.back();
                  })
              : IconButton(
                  icon: const Icon(
                    Icons.home,
                    color: Palette.grey300,
                  ),
                  onPressed: () {
                    Get.offAll(() => MainScreen());
                  }),
          title: const Text("챌린지 자세히 보기",
              style: TextStyle(
                  color: Palette.grey300,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  fontFamily: "Pretender")),
          actions: [
            IconButton(
                onPressed: () {},
                icon: const Icon(
                  Icons.ios_share,
                  color: Palette.grey300,
                )),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              PhotoesWidget(
                screenHeight: screenSize.height,
                imageUrl: challenge.challengeImage1.toString(),
              ),
              // screenHeight를 전달합니다.
              Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                  child: InformationWidget(challenge: challenge)),
              SvgPicture.asset(
                'assets/svgs/divider.svg',
                fit: BoxFit.contain,
              ),
              challengeExplanation(),
              ImageGridView(screenSize),
              SvgPicture.asset(
                'assets/svgs/divider.svg',
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 10),
              const Text("인증 방식",
                  style: TextStyle(
                      fontSize: 15,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600)),
              const SizedBox(height: 15),
              Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15),
                  child: CertificationMethod(challenge: challenge)),
              certificationExplainPicture(screenSize)
            ],
          ),
        ),
        bottomNavigationBar: Visibility(
            visible: isFromMainScreen,
            child: Stack(children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                height: 80,
                color: Colors.transparent,
                width: double.infinity,
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) =>
                            JoinChallengeScreen(challenge: challenge),
                      ),
                    );
                  },
                  child: SvgPicture.asset(
                    'assets/svgs/join_challenge_btn.svg',
                    // width: double.infinity,
                    // height: 30,
                  ),
                ),
              ),
              Positioned(
                  top: 5,
                  left: 20,
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Palette.purPle700,
                      // 배경색 설정
                      borderRadius: BorderRadius.circular(4),
                      // 테두리를 둥글게 설정
                    ),
                    child: Text(
                      " ${challenge.certificationFrequency} | ${challenge.challengePeriod}주 ",
                      style: const TextStyle(
                          fontSize: 11,
                          fontFamily: "Pretendard",
                          color: Palette.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ))
            ])));
  }

  Widget ImageGridView(Size screenSize) {
    final List<String> imagePaths = [
      'assets/images/image.png',
      'assets/images/image.png',
      'assets/images/image.png',
      'assets/images/image.png',
    ];

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        height: screenSize.width * 0.5 * (imagePaths.length ~/ 2),
        child: GridView.builder(
          padding: const EdgeInsets.symmetric(vertical: 4),
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: imagePaths.length,
          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ImageDetailPage(imagePath: imagePaths[index]),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  imagePaths[index],
                  width: screenSize.width * 0.4,
                  fit: BoxFit.fitWidth,
                ),
              ),
            );
          },
        ));
  }

  Widget challengeExplanation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("챌린지 소개",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 15),
          Text(
            challenge.challengeExplanation,
            style: const TextStyle(
                fontSize: 10,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget certificationExplainPicture(Size screenSize) {
    return Column(
      children: [
        Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
            child: Text(challenge.certificationExplanation,
                style: const TextStyle(
                    fontSize: 10,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500))),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            BuildImageContainer(
                path: challenge.successfulVerificationImage!.toString(),
                color: Palette.green,
                isSuccess: true,
                screenSize: screenSize),
            const SizedBox(width: 10),
            BuildImageContainer(
                path: challenge.failedVerificationImage!.toString(),
                color: Palette.red,
                isSuccess: false,
                screenSize: screenSize),
          ],
        ),
      ],
    );
  }
}
