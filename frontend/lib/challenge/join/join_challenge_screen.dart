import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/detail/widgets/build_image_container.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_information.dart';
import 'package:frontend/challenge/detail/widgets/detail_widget_photoes.dart';
import 'package:frontend/challenge/join/join_challenge_screen_sec.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:get/get.dart';

class JoinChallengeScreen extends StatefulWidget {
  final Challenge challenge;

  const JoinChallengeScreen({super.key, required this.challenge});

  @override
  State<JoinChallengeScreen> createState() => _JoinChallengeScreenState();
}

class _JoinChallengeScreenState extends State<JoinChallengeScreen> {
  bool showVerificationInput = false;
  bool isCheckedAll = false;
  List<bool> isCheckList = [false, false, false];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            '루틴업 참가하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pretendard',
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              child: Column(
                children: [
                  PhotoesWidget(
                      screenHeight: screenSize.height,
                      imageUrl: widget.challenge.challengeImagePaths![0]),
                  InformationWidget(challenge: widget.challenge),
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      child: Divider(thickness: 10, color: Palette.grey50)),
                  ExampleMsg(screenSize),
                  const Padding(
                      padding:
                          EdgeInsets.symmetric(vertical: 10, horizontal: 2),
                      child: Divider(thickness: 10, color: Palette.grey50)),
                  AgreeCheckWidget(),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                    color: Colors.transparent,
                    width: double.infinity,
                    child: isCheckList.every((element) => element == true)
                        ? InkWell(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) =>
                                      JoinChallengeSecScreen(challengeId: widget.challenge.id),
                                ),
                              );
                            },
                            child: SvgPicture.asset(
                              'assets/svgs/next_btn_checked.svg',
                              // width: double.infinity,
                              // height: 30,
                            ))
                        : SvgPicture.asset(
                            'assets/svgs/next_btn_unchecked.svg',
                            // width: double.infinity,
                            // height: 30,
                          ),
                  ),
                  // inputPenaltyName(screenSize),
                  // if (showVerificationInput) ...[
                  //   SizedBox(height: 5),
                  //   verificationInput(screenSize),
                  // ],
                  // Container(
                  //   padding: const EdgeInsets.symmetric(vertical: 0, horizontal: 15),
                  //   color: Colors.transparent,
                  //   width: double.infinity,
                  //   child: InkWell(
                  //     onTap: () {},
                  //     child: SvgPicture.asset(
                  //       'assets/svgs/join_challenge_btn.svg',
                  //       // width: double.infinity,
                  //       // height: 30,
                  //     ),
                  //   ),
                  // )
                ],
              )),
        ));
  }

  Widget ExampleMsg(Size _screenSize) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgs/check_green.svg',
                  width: 30,
                ),
                const SizedBox(width: 5),
                const Text(
                  "루틴업 성공 시",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Palette.grey500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "수신자에게 나의 성공 소식이 전해져요.\n나의 갓생을 자랑할 수 있어요!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Palette.grey500),
            ),
            const SizedBox(height: 10),
            BuildImageContainer(
              path: 'assets/images/success_msg.jpg',
              color: Palette.white,
              isSuccess: true,
              screenSize: _screenSize * 0.7,
              isJoinScreen: true,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset(
                  'assets/svgs/check_red.svg',
                  width: 30,
                ),
                const SizedBox(width: 5),
                const Text(
                  "루틴업 실패 시",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: Palette.grey500),
                ),
              ],
            ),
            const SizedBox(height: 10),
            const Text(
              "수신자에게 나의 실패 소식이 전해져요.\n채찍의 한마디로 갓생을 향해 나아가요!",
              textAlign: TextAlign.center,
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: Palette.grey500),
            ),
            const SizedBox(height: 10),
            BuildImageContainer(
                path: 'assets/images/fail_msg.jpg',
                color: Palette.white,
                isSuccess: false,
                screenSize: _screenSize * 0.7,
                isJoinScreen: true),
          ],
        ));
  }

  Widget inputPenaltyName(Size screenSize) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
        child: Form(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text(
            "결과 알림 받을 전화번호 입력해 주세요.",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Pretendard',
                color: Palette.grey300),
          ),
          const Text(
            "(성공을 가장 알리고 싶은 or 실패를 가장 숨기고 싶은)",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 9,
                fontFamily: 'Pretendard',
                color: Palette.grey200),
          ),
          const SizedBox(height: 15),
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
                  style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                      fontFamily: 'Pretendard'),
                  decoration: InputDecoration(
                      hintText: "010-1234-5678",
                      // 예시 번호를 힌트로 표시합니다.
                      hintStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Palette.grey200,
                      ),
                      counterStyle: const TextStyle(
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
                          borderSide: const BorderSide(
                              color: Palette.mainPurple, width: 2))),
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
    return Container(
        // margin: EdgeInsets.only(left: 20, right: 20),
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            // border: Palette.greySoft, // 배경색 설정
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            const Text(
              "패널티 휴대폰 인증",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'Pretendard',
                color: Palette.grey300,
              ),
            ),
            SizedBox(height: 3),
            const Text(
              "인증 완료시, 본 전화번호 소유자 개인정보 수집에 동의합니다.",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                  fontFamily: 'Pretendard',
                  color: Palette.grey200),
            ),
            SizedBox(height: 10),
            Row(
              children: [
                SizedBox(
                  width: screenSize.width * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                      fontFamily: 'Pretendard',
                    ),
                    decoration: InputDecoration(
                      hintText: "4자리 입력",
                      hintStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Palette.grey200,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      filled: true,
                      fillColor: Palette.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Palette.greySoft),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: Palette.mainPurple, width: 2),
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
                const SizedBox(width: 10),
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

  Widget AgreeCheckWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          "확인해주세요",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 20,
            fontFamily: 'Pretendard',
            color: Palette.grey300,
          ),
        ),
        const SizedBox(height: 10),
        checkBoxWidget("타인의 개인정보(이름, 전화번호)를 입력하실 때는\n 반드시 해당 분의 동의 여부를 확인해주세요.",
            isCheckList[0], (value) {
          setState(() {
            isCheckList[0] = value!;
          });
        }),
        checkBoxWidget("루틴업 챌린지에 관한 안내사항을 확인했습니다.", isCheckList[1], (value) {
          setState(() {
            isCheckList[1] = value!;
          });
        }),
        checkBoxWidget("루틴업 챌린지를 통해 갓생성장을 원해요!", isCheckList[2], (value) {
          setState(() {
            isCheckList[2] = value!;
          });
        })
      ],
    );
  }

  Widget checkBoxWidget(
      String text, bool isChecked, void Function(bool?) onChanged) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      width: double.infinity,
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Text(
          text,
          style: const TextStyle(
              fontWeight: FontWeight.w600,
              fontSize: 10,
              fontFamily: 'Pretendard',
              color: Palette.grey200),
        ),
        Checkbox(
          value: isChecked,
          checkColor: Colors.white,
          activeColor: Palette.purPle300,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(5),
          ),
          onChanged: onChanged,
        ),
      ]),
    );
  }
}
