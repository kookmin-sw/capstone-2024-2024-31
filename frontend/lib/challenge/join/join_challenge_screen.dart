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
  bool showVerificationInput = false;

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
            onTap: () {},
            child: SvgPicture.asset(
              'assets/svgs/join_challenge_btn.svg',
              // width: double.infinity,
              // height: 30,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                children: [
                  PhotoesWidget(
                      screenHeight: screenSize.height,
                      imageUrl: widget.challenge.challengeImage1.toString()),
                  InformationWidget(challenge: widget.challenge),
                  Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      child: Divider(thickness: 4, color: Palette.purPle100)),
                  inputPenaltyName(screenSize),
                  if (showVerificationInput) ...[
                    SizedBox(height: 5),
                    verificationInput(screenSize),
                  ],
                ],
              )),
        ));
  }

  Widget inputPenaltyName(Size screenSize) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Form(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "패널티 알림 받을 전화번호 입력해 주세요.",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Pretendard',
                color: Palette.grey300),
          ),
          Text(
            "(성공을 가장 알리고 싶은 or 실패를 가장 숨기고 싶은)",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                fontFamily: 'Pretendard',
                color: Palette.grey200),
          ),
          SizedBox(height: 15),
          Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                    child: TextFormField(
                  maxLength: 11,
                  // 휴대폰 번호는 보통 11자리입니다.
                  keyboardType: TextInputType.phone,
                  // 키보드 타입을 전화번호로 설정합니다.
                  style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                      fontFamily: 'Pretendard'),
                  decoration: InputDecoration(
                      hintText: "010-1234-5678",
                      // 예시 번호를 힌트로 표시합니다.
                      hintStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Palette.grey200,
                      ),
                      counterStyle: TextStyle(
                          fontSize: 9,
                          color: Palette.grey200,
                          fontFamily: 'Pretendard'),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      filled: true,
                      fillColor: Palette.greySoft,
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(color: Palette.greySoft)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide:
                              BorderSide(color: Palette.mainPurple, width: 2))),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return '휴대폰 번호를 입력하세요.';
                    }
                    return null;
                  },
                  onSaved: (value) {
                    // _submittedPhoneNumber = value;
                  },
                )),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        showVerificationInput = true;
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/number_auth_btn.svg',
                      // width: double.infinity,
                      // height: 30,
                    ),
                  ),
                )
              ])
        ])));
  }

  Widget verificationInput(Size screenSize) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 5),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              "패널티 전화번호 휴대폰 인증",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'Pretendard',
                color: Palette.grey300,
              ),
            ),
            SizedBox(height: 3),
            Text(
              "인증 완료시, 본 전화번호 소유자 개인정보 수집에 동의합니다.",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                  fontFamily: 'Pretendard',
                  color: Palette.grey200),
            ),
            SizedBox(height: 3),
            Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                      fontFamily: 'Pretendard',
                    ),
                    decoration: InputDecoration(
                      hintText: "4자리 입력",
                      hintStyle: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Palette.grey200,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      filled: true,
                      fillColor: Palette.greySoft,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Palette.greySoft),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            BorderSide(color: Palette.mainPurple, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '인증번호를 입력하세요.';
                      }
                      return null;
                    },
                    onSaved: (value) {
                      // _submittedVerificationCode = value;
                    },
                  ),
                ),
                SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        showVerificationInput = true;
                      });
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/auth_check_btn.svg',
                      // width: double.infinity,
                      // height: 30,
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }
}
