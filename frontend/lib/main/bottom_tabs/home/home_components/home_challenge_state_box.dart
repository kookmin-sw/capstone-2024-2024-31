import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:frontend/challenge/state/state_challenge_screen.dart';
import 'package:frontend/community/create_posting_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class ChallengeStateBox extends StatefulWidget {
  const ChallengeStateBox({super.key});

  @override
  State<ChallengeStateBox> createState() => _ChallengeStateBoxState();
}

class _ChallengeStateBoxState extends State<ChallengeStateBox> {
  final logger = Logger();
  final controller = Get.find<UserController>();
  final List<ChallengeSimple> challenges = [];

  double getProgressPercent(int index){
    DateTime now = DateTime.now();
    DateTime start = challenges[index].startDate;
    DateTime end =
        start.add(Duration(days: challenges[index].challengePeriod * 7));
    return now.difference(start).inDays / end.difference(start).inDays * 100;
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      challenges.clear();
      challenges.addAll(
          controller.myChallenges.where((c) => c.status == "진행중").toList());
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      height: 195,
      // Specify a fixed height here
      decoration: BoxDecoration(
          color: Palette.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(width: 1, color: Palette.greyBG)),
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextButton(
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero, // 내부 패딩을 없앰
              splashFactory: NoSplash.splashFactory,
            ),
            child: const Text("내 진행중인 챌린지 >",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  color: Palette.grey500,
                  fontSize: 14,
                )),
            onPressed: () {},
          ),
          const Text(
            "챌린지를 진행하고 인증을 완료해 주세요!",
            style: TextStyle(
                fontFamily: 'Pretendard',
                fontWeight: FontWeight.w500,
                fontSize: 11,
                color: Colors.grey),
          ),
          const SizedBox(height: 10),
          challenges.isEmpty
              ? SvgPicture.asset("assets/svgs/no_challenge_state_card.svg")
              : Expanded(
                  child: Swiper(
                    loop: false,
                    itemCount: challenges.length,
                    pagination: const SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      margin: EdgeInsets.all(1.0),
                      builder: DotSwiperPaginationBuilder(
                          space: 3,
                          size: 9,
                          activeSize: 9,
                          color: Palette.softPurPle,
                          activeColor: Palette.purPle300),
                    ),
                    itemBuilder: (context, index) {
                      return Column(children: [
                        challengeStateCard(screenWidth, index),
                        const SizedBox(height: 15)
                      ]);
                    },
                  ),
                ),
        ],
      ),
    );
  }

  Widget challengeStateCard(double screenWidth, int index) {
    return GestureDetector(
        onTap: () {
          Get.to(() => ChallengeStateScreen(isFromJoinScreen: false, challengeSimple: challenges[index]));
        },
        child: SizedBox(
            width: screenWidth * 0.95,
            child: Card(
                color: Palette.greySoft,
                child: Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(15),
                            child: Image.network(
                              challenges[index].imageUrl, // 이미지 경로
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
                                  width: screenWidth * 0.35,
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Flexible(
                                          child: Text(
                                        challenges[index]
                                            .challengeName, // 챌린지 이름
                                        maxLines: 1,
                                        overflow: TextOverflow.fade,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontFamily: "Pretender",
                                          fontSize: 10,
                                        ),
                                      )),
                                      Text(
                                        '${getProgressPercent(index).toInt()}%',
                                        style: const TextStyle(
                                            fontSize: 11,
                                            fontFamily: "Pretender"), // 진행 상태
                                      ),
                                    ],
                                  )),
                              const SizedBox(
                                height: 5,
                              ),
                              stateBar(screenWidth, getProgressPercent(index))
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
                            onPressed: () {
                              Get.to(() => const CreatePostingScreen());
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: const Size(40, 40),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // 테두리를 둥글게 만드는 부분
                              ),
                              padding: EdgeInsets.zero,
                              backgroundColor: Palette.purPle50,
                              foregroundColor: Palette.purPle700,
                            ),
                            child: const Text('인증',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 11,
                                    fontFamily: 'Pretendard')), // 버튼 텍스트
                          )
                        ])))));
  }

  Widget stateBar(double screenWidth, double percent) {
    return Container(
      decoration: BoxDecoration(
          color: Palette.grey500, // 배경색 설정
          borderRadius: BorderRadius.circular(5)),
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
}
