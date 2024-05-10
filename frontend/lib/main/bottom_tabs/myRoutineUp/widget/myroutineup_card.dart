import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:frontend/challenge/complete/challenge_complete_screen.dart';
import 'package:frontend/challenge/state/state_challenge_screen.dart';
import 'package:frontend/community/tab_community_screen.dart';
import 'package:frontend/model/config/image_from_file.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class MyRoutineUpCard extends StatelessWidget {
  const MyRoutineUpCard(
      {super.key, required this.isIng, required this.challenge});

  final bool isIng;
  final Challenge challenge;

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final DateTime startDate = DateTime.parse(challenge.startDate);
    final int challengePeriod =
        int.parse(challenge.challengePeriod); // Challenge 기간, ex: 주 단위
    final DateTime endDate = startDate.add(Duration(days: challengePeriod * 7));

    return GestureDetector(
        onTap: () {
          isIng
              ? Get.to(() => const TabCommunityScreen())
              : Get.to(() => ChallengeCompleteScreen(challenge: challenge));
        },
        child: SizedBox(
            width: screenSize.width * 0.95,
            child: Card(
                color: Colors.grey[90],
                child: Opacity(
                    opacity: isIng ? 1.0 : 0.5, // 불투명도 조절
                    child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 20),
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              ClipRRect(
                                borderRadius: BorderRadius.circular(9),
                                child: Image.asset(
                                  'assets/images/image.png', // 이미지 경로
                                  width: 60, // 이미지 너비
                                  height: 60, // 이미지 높이
                                  fit: BoxFit.fitWidth,
                                ),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  SizedBox(
                                      width: screenSize.width * 0.52,
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            challenge.challengeName, // 챌린지 이름
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              fontSize: 10,
                                            ),
                                          ),
                                          const Text(
                                            '50%',
                                            style: TextStyle(
                                                fontSize: 11), // 진행 상태
                                          ),
                                        ],
                                      )),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  mainStatusBar(screenSize.width, 50.0),
                                  const SizedBox(
                                    height: 8,
                                  ),
                                  SizedBox(
                                      width: screenSize.width * 0.52,
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                              "${DateFormat("M월 d일 (E)", "ko_KR").format(startDate)} - ${DateFormat("M월 d일 (E)", "ko_KR").format(endDate)}",
                                              style: const TextStyle(
                                                  color: Palette.grey200,
                                                  fontSize: 9,
                                                  fontFamily: "Pretendard",
                                                  fontWeight:
                                                      FontWeight.normal)),
                                          Text(
                                            ' ${challenge.challengePeriod}주',
                                            style: const TextStyle(
                                              fontSize: 10,
                                              color: Palette.grey500,
                                              fontFamily: "Pretendard",
                                            ), // 진행 상태
                                          ),
                                        ],
                                      )),
                                ],
                              ),
                              const SizedBox(width: 10),
                            ]))))));
  }

  Widget mainStatusBar(double screenWidth, double percent) {
    return Container(
      decoration: BoxDecoration(
          color: Palette.grey500, // 배경색 설정
          borderRadius: BorderRadius.circular(5)),
      child: ProgressBar(
        width: screenWidth * 0.52,
        height: 6,
        value: percent * 0.01,
        backgroundColor: Palette.grey50,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Palette.purPle200, Palette.mainPurple],
        ),
      ),
    );
  }
}
