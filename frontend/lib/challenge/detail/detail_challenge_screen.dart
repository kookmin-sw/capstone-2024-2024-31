import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ChallengeDetailScreen extends StatelessWidget {
  ChallengeDetailScreen({super.key});

  Challenge challenge = Challenge(
      isPrivate: false,
      privateCode: 'privateCode',
      challengeName: '조깅 3KM 하기',
      challengeExplanation:
          '챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라 챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라',
      challengePeriod: '8주',
      startDate: '2024-04-08',
      certificationFrequency: '평일 매일',
      certificationStartTime: 1,
      certificationEndTime: '24시',
      certificationExplanation:
          '인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~',
      isGalleryPossible: true,
      maximumPeople: 100,
      participants: []);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    initializeDateFormatting('ko_KR', 'en_US');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // AppBar를 투명하게 설정
        elevation: 0,
        // 그림자 없애기
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.ios_share)),
        ],
        title: const Text(
          '챌린지 상세정보',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            photoes(screenHeight),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                child: information_challenge()),
            SvgPicture.asset(
              'assets/svgs/divider.svg',
              fit: BoxFit.contain,
            ),
            ChallengeExplanation(),
            SvgPicture.asset(
              'assets/svgs/divider.svg',
              fit: BoxFit.contain,
            ),
            certificationMethod()
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        color: Colors.transparent,
        width: double.infinity,
        child: InkWell(
          onTap: () {},
          child: SvgPicture.asset(
            'assets/svgs/join_challenge_btn.svg',
            // width: double.infinity,
            // height: 30,
          ),
        ),
      ),
    );
  }

  Widget photoes(double screenHeight) {
    return Container(
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/challenge_image.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget information_challenge() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 5),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue, // 동그라미의 배경색
                ),
                child: Image.asset(
                  'assets/images/24.png', // 동그라미 이미지의 경로
                  fit: BoxFit.cover, // 이미지가 동그라미 안에 맞도록 설정
                ),
              ),
              SizedBox(width: 5),
              Text(
                "루틴업",
                style: TextStyle(
                    fontSize: 13,
                    fontFamily: "Pretendard",
                    color: Palette.grey500,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          SizedBox(height: 3),
          Text(challenge.challengeName,
              style: TextStyle(
                  fontSize: 20,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w700,
                  color: Palette.grey500)),
          SizedBox(height: 3),
          Row(children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/svgs/detail_user_icon.svg',
                fit: BoxFit.cover,
                // 이미지가 동그라미 안에 맞도록 설정
              ),
            ),
            SizedBox(width: 5),
            Text("${challenge.participants.length}명의 루티너가 참여중",
                style: TextStyle(
                    color: Palette.purPle200,
                    fontSize: 10,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500))
          ]),
          SizedBox(height: 8),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5), // 배경색 설정
                  borderRadius: BorderRadius.circular(10)), // 컨테이너를 둥글게 만듭니다.
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("기간",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(
                            "${DateFormat("M월 d일 (E)", "ko_KR").format(DateTime.parse(challenge.startDate))}-*월 *일 ${challenge.challengePeriod}",
                            style: TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("시작일",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(
                            "${DateFormat("YYYY년 M월 d일 (E)", "ko_KR").format(DateTime.parse(challenge.startDate))}",
                            style: TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("인증 빈도",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text("${challenge.certificationFrequency}",
                            style: TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    )
                  ]))
        ]);
  }

  Widget ChallengeExplanation() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("챌린지 소개",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          Text(challenge.challengeExplanation,
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w500))
        ],
      ),
    );
  }

  Widget certificationMethod() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("인증 방식",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          SizedBox(height: 10),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5), // 배경색 설정
                  borderRadius: BorderRadius.circular(10)), // 컨테이너를 둥글게 만듭니다.
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("인증 가능 시간",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(
                            "${challenge.certificationStartTime}시 - ${challenge.certificationEndTime}",
                            style: TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("인증 횟수",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(challenge.certificationFrequency,
                            style: TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                    SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("수단",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(challenge.isGalleryPossible ? "카메라+갤러리" : "카메라",
                            style: TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    )
                  ])),
          SizedBox(height: 10),
          Text(challenge.certificationExplanation,
              style: TextStyle(
                  fontSize: 10,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w500)),
          // Row(
          //   children: [
          //     buildImageContainer(challenge.successfulVerificationImage, Palette.green, true),
          //     SizedBox(width: 20),
          //     buildImageContainer(challenge.failedVerificationImage, Palette.red, false),
          //   ],
          // ),
        ],
      ),
    );
  }

  Widget buildImageContainer(XFile? file, Color color, bool isSuccess) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              isSuccess
                  ? 'assets/icons/check_green.png'
                  : 'assets/icons/check_red.png',
              color: color,
            ),
            SizedBox(width: 5),
            Text(
              isSuccess ? "성공 예시" : "실패 예시",
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: Palette.grey200),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Palette.greySoft,
            borderRadius: BorderRadius.circular(33.0),
            border: Border.all(
              color: file != null ? color : Palette.greySoft,
              width: 2.0,
            ),
          ),
          height: 120,
          width: 120,
          child: file != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                  ),
                )
              : Icon(
                  Icons.image,
                  size: 35,
                  color: Palette.grey300,
                ),
        ),
        SizedBox(height: 5),
      ],
    );
  }
}
