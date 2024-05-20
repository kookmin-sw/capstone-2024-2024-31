import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:frontend/screens/community/create_posting_screen.dart';
import 'package:frontend/screens/main/main_screen.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:get/get.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'package:intl/intl.dart';
import '../../../model/config/palette.dart';
import '../../../model/data/challenge/challenge.dart';
import '../../../model/data/challenge/challenge_status.dart';
import '../../../model/package/pie_chart/src/chart_values_options.dart';
import '../../../model/package/pie_chart/src/legend_options.dart';
import '../../../model/package/pie_chart/src/pie_chart.dart';

class ChallengeWidgets {
  static AppBar buildAppBar(final bool isFromJoinScreen) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      leading: isFromJoinScreen
          ? IconButton(
              onPressed: () => Get.offAll(const MainScreen(
                    tabNumber: 0,
                  )),
              icon: const Icon(
                Icons.home,
                color: Colors.white,
              ))
          : IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                color: Colors.white,
              ),
              onPressed: () {
                Get.back();
              },
            ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(
            Icons.ios_share,
            color: Colors.white,
          ),
        ),
      ],
    );
  }

  static Widget buildBottomNavigationBar(Challenge challenge) {
    return Container(
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
      height: 80,
      color: Colors.transparent,
      width: double.infinity,
      child: InkWell(
        onTap: () {
          Get.to(CreatePostingScreen(
            challenge: challenge,
          ));
        },
        child: SvgPicture.asset(
          'assets/svgs/certification_bottom_btn.svg',
        ),
      ),
    );
  }

  static Widget photoes(double screenHeight, Challenge thisChallenge) {
    return Stack(
      children: <Widget>[
        Container(
          height: screenHeight * 0.3,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/challenge_image.png'),
              fit: BoxFit.fitWidth,
            ),
          ),
        ),
        Positioned(
          top: (screenHeight * 0.3) - 80,
          left: 10,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              frequeuncyAndPeriod(thisChallenge),
              const SizedBox(height: 3),
              Text(
                thisChallenge.challengeName,
                style: const TextStyle(
                  fontSize: 19,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600,
                  color: Palette.white,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget frequeuncyAndPeriod(Challenge thisChallenge) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Palette.purPle700,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        " ${thisChallenge.certificationFrequency} | ${thisChallenge.challengePeriod}주 ",
        style: const TextStyle(
          fontSize: 10,
          fontFamily: "Pretendard",
          color: Palette.white,
          fontWeight: FontWeight.normal,
        ),
      ),
    );
  }

  static Widget informationChallenge(DateTime startDate, DateTime endDate,
      Challenge thisChallenge, ChallengeStatus challengeStatus) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        challengeExplanation(thisChallenge),
        const SizedBox(height: 5),
        Container(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
          decoration: BoxDecoration(
            color: const Color(0xFFF5F5F5),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "기간",
                    style: TextStyle(
                      color: Palette.grey200,
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${DateFormat("M월 d일(E)", "ko_KR").format(startDate)}-${DateFormat("M월 d일(E)", "ko_KR").format(endDate)}  ${thisChallenge.challengePeriod}주",
                    style: const TextStyle(
                      color: Palette.grey300,
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "시작일",
                    style: TextStyle(
                      color: Palette.grey200,
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    DateFormat("yyyy년 M월 d일 (E)", "ko_KR").format(startDate),
                    style: const TextStyle(
                      color: Palette.grey300,
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 3),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "인증 빈도",
                    style: TextStyle(
                      color: Palette.grey200,
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    challengeStatus.certificationFrequency,
                    style: const TextStyle(
                      color: Palette.grey300,
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "인증 가능 시간",
                    style: TextStyle(
                      color: Palette.grey200,
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${challengeStatus.certificationStartTime}시 ~ ${challengeStatus.certificationEndTime}",
                    style: const TextStyle(
                      color: Palette.grey300,
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "현재 참여 인원",
                    style: TextStyle(
                      color: Palette.grey200,
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  Text(
                    "${challengeStatus.totalParticipants}명",
                    style: const TextStyle(
                      color: Palette.grey300,
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget challengeExplanation(Challenge thisChallenge) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text(
            "챌린지 상세 정보",
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Pretendard",
              color: Palette.grey500,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            thisChallenge.challengeName,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: "Pretendard",
              color: Palette.grey300,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  static Widget certificationState(double screenWidth, double screenHeight,
      ChallengeStatus challengeStatus) {
    int totalCertificationCount =
        challengeStatus.totalCertificationCount; //챌린지 총 인증횟수
    int myCertificationNum = challengeStatus.numberOfCertifications; //내가 한 인증횟수
    int failNum = 0;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "내 인증 현황",
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    "$myCertificationNum회",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Palette.purPle400,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    " / $totalCertificationCount회  |  남은 인증 : ${totalCertificationCount - myCertificationNum}회",
                    style: const TextStyle(
                      fontSize: 10,
                      color: Palette.grey300,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
              Text(
                "실패 횟수 : $failNum회",
                style: const TextStyle(
                  fontSize: 9,
                  color: Palette.grey300,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          certificationStateBar(screenWidth, challengeStatus),
          const SizedBox(height: 15),
          Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 5),
            width: screenWidth,
            color: Colors.transparent,
            child: InkWell(
              onTap: () {},
              child: SvgPicture.asset(
                'assets/svgs/go_Certification_btn.svg',
              ),
            ),
          ),
        ],
      ),
    );
  }

  static Widget certificationStateBar(
      double screenWidth, ChallengeStatus challengeStatus) {
    int myCertificationNumber =
        challengeStatus.numberOfCertifications; //내가 한 인증 횟수
    String percent =
        (myCertificationNumber / challengeStatus.totalCertificationCount * 100)
            .toStringAsFixed(1);

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F5F5),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "현재 달성률",
                style: TextStyle(
                  color: Palette.grey500,
                  fontSize: 10,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                "${challengeStatus.currentAchievementRate} %",
                style: const TextStyle(
                  color: Palette.grey500,
                  fontSize: 10,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Palette.grey500,
              borderRadius: BorderRadius.circular(5),
            ),
            child: ProgressBar(
              width: screenWidth * 0.9,
              height: 4,
              value: double.parse(percent) * 0.01,
              backgroundColor: Palette.grey50,
              gradient: const LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Palette.purPle200, Palette.mainPurple],
              ),
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            "예상 달성률 : 100%",
            style: TextStyle(
              color: Palette.grey200,
              fontSize: 9,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  static Widget entireCertificationStatus(double screenWidth,
      double screenHeight, ChallengeStatus challengeStatus) {
    final dataMap = <String, double>{
      "100%": challengeStatus.fullAchievementCount.toDouble(),
      "80% 이상": challengeStatus.highAchievementCount.toDouble(),
      "80% 미만": challengeStatus.lowAchievementCount.toDouble()
    };
    final colorList = <Color>[
      Palette.purPle500,
      Palette.purPle300,
      Palette.purPle100,
    ];
    return Container(
      padding: const EdgeInsets.only(top: 20, left: 15, right: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "전체 현황",
            style: TextStyle(
              fontSize: 15,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Text(
                    "총 참여인원 :",
                    style: TextStyle(
                      fontSize: 10,
                      color: Palette.grey300,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "  ${challengeStatus.totalParticipants}명",
                    style: const TextStyle(
                      fontSize: 11,
                      color: Palette.purPle400,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          certificationStateBar(screenWidth, challengeStatus),
          const SizedBox(height: 15),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 15),
            child: PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              ringStrokeWidth: 20,
              chartRadius: screenWidth * 0.35,
              baseChartColor: Colors.grey[50]!.withOpacity(0.15),
              colorList: colorList,
              chartValuesOptions: const ChartValuesOptions(
                showChartValues: true,
                showChartValuesInPercentage: true,
                showChartValuesOutside: true,
                showChartValueBackground: true,
                chartValueStyle: TextStyle(
                  fontSize: 9,
                  color: Palette.grey300,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600,
                ),
              ),
              totalValue: challengeStatus.totalParticipants.toDouble(),
              legendOptions: const LegendOptions(
                legendValueTextStyle: TextStyle(
                  fontSize: 10,
                  color: Palette.grey500,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600,
                ),
                showLegendsInRow: true,
                legendPosition: LegendPosition.bottom,
                showLegends: true,
                legendShape: BoxShape.rectangle,
                legendTextStyle: TextStyle(
                  fontSize: 9,
                  color: Palette.grey300,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600,
                ),
              ),
              centerWidget: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "평균 예상 달성률",
                      style: TextStyle(
                        fontSize: 10,
                        color: Palette.grey200,
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    Text(
                      "${challengeStatus.overallAverageAchievementRate}",
                      style: const TextStyle(
                        fontSize: 20,
                        color: Palette.grey500,
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
