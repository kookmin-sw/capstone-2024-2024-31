import 'package:flutter/material.dart';
import 'package:frontend/model/data/challenge/challenge_status.dart';
import 'package:frontend/screens/challenge/complete/challenge_complete_screen.dart';
import 'package:frontend/screens/challenge/detail/challenge_detail_screen.dart';
import 'package:frontend/screens/challenge/state/state_challenge_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:logger/logger.dart';

class MyRoutineUpCard extends StatefulWidget {
  final ChallengeSimple challengeSimple;
  final bool isIng;
  final bool isStarted;

  const MyRoutineUpCard({
    super.key,
    required this.isIng,
    required this.challengeSimple,
    required this.isStarted,
  });

  @override
  MyRoutineUpCardState createState() => MyRoutineUpCardState();
}

class MyRoutineUpCardState extends State<MyRoutineUpCard> {
  bool isLoading = true;
  late ChallengeStatus challengeStatus;
  final Logger logger = Logger();

  @override
  void initState() {
    super.initState();
    _fetchChallengeStatus();
  }

  Future<void> _fetchChallengeStatus() async {
    try {
      challengeStatus = await ChallengeService.fetchChallengeStatus(widget.challengeSimple.id);
      setState(() {
        isLoading = false;
      });
    } catch (error) {
      logger.e('Failed to fetch challenge status: $error');
      setState(() {
        isLoading = false;
      });
    }
  }


  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    final int challengeId = widget.challengeSimple.id;
    final int challengePeriod = widget.challengeSimple.challengePeriod;
    final DateTime startDate = widget.challengeSimple.startDate;
    final DateTime endDate = startDate.add(Duration(days: challengePeriod * 7));

    return GestureDetector(
      onTap: () {
        ChallengeService.fetchChallenge(challengeId).then((challenge) {
          if (widget.challengeSimple.status == "진행중") {
            Get.to(() => ChallengeStateScreen(
              challenge: challenge,
              isFromJoinScreen: false,
            ));
          } else if (widget.challengeSimple.status == "진행완료") {
            Get.to(() => ChallengeCompleteScreen(challenge: challenge));
          } else {
            Get.to(() => ChallengeDetailScreen(challenge: challenge, isFromMypage: true));
          }
        });
      },
      child: SizedBox(
        width: screenSize.width * 0.95,
        child: isLoading
            ? const  SizedBox(
            width: 20.0, // 원하는 크기로 설정
            height: 20.0, // 원하는 크기로 설정
            child: Center(
              child: CircularProgressIndicator(color: Palette.mainPurple),
          ),
        )
            : Card(
          elevation: 5.0,
          color: widget.isIng ? Colors.white : Colors.grey[80],
          child: Opacity(
            opacity: widget.isIng ? 1.0 : 0.5,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(9),
                    child: Image.network(
                      widget.challengeSimple.imageUrl,
                      width: 60,
                      height: 60,
                      fit: BoxFit.fitWidth,
                    ),
                  ),
                  const SizedBox(width: 5),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: screenSize.width * 0.52,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                widget.challengeSimple.challengeName,
                                overflow: TextOverflow.clip,
                                maxLines: 1,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                  fontFamily: "Pretender",
                                  color: widget.isIng ? Palette.mainPurple : Palette.purPle200,
                                ),
                              ),
                            ),
                            Text(
                              '${challengeStatus.currentAchievementRate.toInt()}%',
                              style: const TextStyle(fontSize: 11, fontFamily: 'Pretender'),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),
                      mainStatusBar(screenSize.width, challengeStatus.currentAchievementRate),
                      const SizedBox(height: 8),
                      SizedBox(
                        width: screenSize.width * 0.52,
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "${DateFormat("M월 d일 (E)", "ko_KR").format(startDate)} - ${DateFormat("M월 d일 (E)", "ko_KR").format(endDate)}",
                              style: const TextStyle(
                                color: Palette.grey200,
                                fontSize: 9,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.normal,
                              ),
                            ),
                            Text(
                              ' ${widget.challengeSimple.challengePeriod}주',
                              style: const TextStyle(
                                fontSize: 10,
                                color: Palette.grey500,
                                fontFamily: "Pretendard",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 10),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget mainStatusBar(double screenWidth, double percent) {
    return Container(
      decoration: BoxDecoration(
        color: Palette.grey500,
        borderRadius: BorderRadius.circular(5),
      ),
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
