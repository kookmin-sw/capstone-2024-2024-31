import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/service/post_service.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

import '../../../../../model/controller/user_controller.dart';
import '../../../../../model/data/challenge/challenge_simple.dart';
import '../../../../challenge/state/state_challenge_screen.dart';
import '../../../../community/create_posting_screen.dart';

class HomeChallengeStateCard extends StatefulWidget {
  final double screenWidth;
  final ChallengeSimple challengeSimple;

  const HomeChallengeStateCard({
    super.key,
    required this.screenWidth,
    required this.challengeSimple,
  });

  @override
  HomeChallengeStateCardState createState() => HomeChallengeStateCardState();
}

class HomeChallengeStateCardState extends State<HomeChallengeStateCard> {
  bool isLoading = false;
  late UserController _userController;
  late bool isPossibleButtonClick = false; // 초기값 설정

  @override
  void initState() {
    super.initState();
    _userController = Get.find<UserController>();
    _checkButtonClickPossibility(); // 비동기 작업을 별도의 함수에서 호출
  }

  Future<void> _checkButtonClickPossibility() async {
    isPossibleButtonClick = await PostService.checkPossibleCertification(
        widget.challengeSimple.id, _userController.user.id);
    setState(() {}); // 상태 업데이트
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        setState(() {
          isLoading = true;
        });

        try {
          Challenge challenge = await ChallengeService.fetchChallenge(
              widget.challengeSimple.id, null);
          Get.to(() => ChallengeStateScreen(
              isFromJoinScreen: false, challenge: challenge, isPossibleCertification :isPossibleButtonClick));
        } finally {
          setState(() {
            isLoading = false;
          });
        }
      },
      child: SizedBox(
        width: widget.screenWidth * 0.95,
        child: Card(
          color: Palette.greySoft,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(15),
                  child: Image.network(
                    widget.challengeSimple.imageUrl, // 이미지 경로
                    width: 60, // 이미지 너비
                    height: 60, // 이미지 높이
                    fit: BoxFit.fitWidth,
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: widget.screenWidth * 0.35,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              widget.challengeSimple.challengeName, // 챌린지 이름
                              maxLines: 1,
                              overflow: TextOverflow.clip,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: "Pretender",
                                fontSize: 10,
                              ),
                            ),
                          ),
                          Text(
                            ' ${getProgressPercent(widget.challengeSimple).toInt()}%',
                            style: const TextStyle(
                              fontSize: 11,
                              fontFamily: "Pretender",
                            ), // 진행 상태
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    stateBar(widget.screenWidth,
                        getProgressPercent(widget.challengeSimple)),
                  ],
                ),
                const SizedBox(width: 10),
                Container(
                  width: 1,
                  height: 40,
                  color: Colors.grey[300],
                ),
                const SizedBox(width: 5),
                ElevatedButton(
                  onPressed: isPossibleButtonClick ? () async {
                    setState(() {
                      isLoading = true;
                    });

                    try {
                      Challenge challenge =
                      await ChallengeService.fetchChallenge(
                          widget.challengeSimple.id);
                      Get.to(() => CreatePostingScreen(challenge: challenge));
                    } finally {
                      setState(() {
                        isLoading = false;
                      });
                    }
                  } : null,
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size(40, 40),
                    shape: RoundedRectangleBorder(
                      borderRadius:
                      BorderRadius.circular(10.0), // 테두리를 둥글게 만드는 부분
                    ),
                    padding: EdgeInsets.zero,
                    backgroundColor: isPossibleButtonClick ? Palette.purPle50 : Palette.grey50,
                    foregroundColor: Palette.purPle700,
                  ),
                  child: Text(
                    isPossibleButtonClick ? '인증': '✔️',
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      fontFamily: 'Pretendard',
                    ),
                  ), // 버튼 텍스트
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget stateBar(double screenWidth, double percent) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.grey500, // 배경색 설정
        borderRadius: BorderRadius.circular(5),
      ),
      child: ProgressBar(
        width: screenWidth * 0.35,
        height: 4,
        value: percent * 0.01,
        backgroundColor: CupertinoColors.systemGrey4,
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Palette.purPle200, Palette.mainPurple],
        ),
      ),
    );
  }

  double getProgressPercent(ChallengeSimple thisChallengeSimple) {
    DateTime now = DateTime.now();
    DateTime start = thisChallengeSimple.startDate;
    DateTime end =
    start.add(Duration(days: thisChallengeSimple.challengePeriod * 7));
    return now.difference(start).inDays / end.difference(start).inDays * 100;
  }
}
