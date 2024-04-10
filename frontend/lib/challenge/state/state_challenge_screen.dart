import 'package:flutter/material.dart';

import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/challenge/detail/detail_imageDetail_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:pie_chart/pie_chart.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';

class ChallengeStateScreen extends StatelessWidget {
  ChallengeStateScreen({super.key});

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
      successfulVerificationImage:
          File("C:\Users\82103\Pictures\Screenshots\image.png"),
      failedVerificationImage:
          File("C:\Users\82103\Pictures\Screenshots\image.png"),
      challengeImage1: File("C:\Users\82103\Pictures\Screenshots\image.png"),
      challengeImage2: File("C:\Users\82103\Pictures\Screenshots\image.png"),
      isGalleryPossible: true,
      maximumPeople: 100,
      participants: []);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final DateTime startDate = DateTime.parse(challenge.startDate);
    final int challengePeriod =
        int.parse(challenge.challengePeriod); // Challenge 기간, ex: 주 단위
    final DateTime endDate = startDate.add(Duration(days: challengePeriod * 7));

    initializeDateFormatting('ko_KR', 'en_US');

    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // AppBar를 투명하게 설정
        elevation: 0,
        // 그림자 없애기
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios,
            color: Colors.white,
          ),
          onPressed: () {},
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: Icon(
                Icons.ios_share,
                color: Colors.white,
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            photoes(screenHeight),
            Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child: information_challenge(startDate, endDate)),
            SvgPicture.asset(
              'assets/svgs/divider.svg',
              fit: BoxFit.contain,
            ),
            certificationState(screenWidth, screenHeight),
            SvgPicture.asset(
              'assets/svgs/divider.svg',
              fit: BoxFit.contain,
            ),
            EntireCertificationStatus(screenWidth, screenHeight)
          ],
        ),
      ),
      bottomNavigationBar: Container(
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        height: 80,
        color: Colors.transparent,
        width: double.infinity,
        child: InkWell(
          onTap: () {},
          child: SvgPicture.asset(
            'assets/svgs/certification_bottom_btn.svg',
          ),
        ),
      ),
    ));
  }

  Widget photoes(double screenHeight) {
    return Stack(children: <Widget>[
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
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            FrequeuncyAndPeriod(),
            const SizedBox(height: 3),
            Text(challenge.challengeName,
                style: const TextStyle(
                    fontSize: 19,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w600,
                    color: Palette.white)),
          ])),
    ]);
  }

  Widget FrequeuncyAndPeriod() {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
              fontSize: 10,
              fontFamily: "Pretendard",
              color: Palette.white,
              fontWeight: FontWeight.normal),
        ));
  }

  Widget information_challenge(DateTime startDate, DateTime endDate) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChallengeExplanation(),
          const SizedBox(height: 5),
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
                        const Text("기간",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(
                            "${DateFormat("M월 d일(E)", "ko_KR").format(startDate)}-${DateFormat("M월 d일(E)", "ko_KR").format(endDate)}  ${challenge.challengePeriod}주",
                            style: const TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("시작일",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(
                            "${DateFormat("yyyy년 M월 d일 (E)", "ko_KR").format(startDate)}",
                            style: const TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("인증 빈도",
                              style: TextStyle(
                                  color: Palette.grey200,
                                  fontSize: 10,
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w500)),
                          Text("${challenge.certificationFrequency}",
                              style: const TextStyle(
                                  color: Palette.grey300,
                                  fontSize: 10,
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w700)),
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("인증 가능 시간",
                              style: TextStyle(
                                  color: Palette.grey200,
                                  fontSize: 10,
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w500)),
                          Text(
                              "${challenge.certificationStartTime}시 ~ ${challenge.certificationEndTime}",
                              style: const TextStyle(
                                  color: Palette.grey300,
                                  fontSize: 10,
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w700))
                        ]),
                    Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("현재 참여 인원",
                              style: TextStyle(
                                  color: Palette.grey200,
                                  fontSize: 10,
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w500)),
                          Text("${challenge.participants.length}명",
                              style: const TextStyle(
                                  color: Palette.grey300,
                                  fontSize: 10,
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w700))
                        ])
                  ]))
        ]);
  }

  Widget ChallengeExplanation() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const Text("챌린지 상세 정보",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(
            challenge.challengeName,
            style: const TextStyle(
                fontSize: 12,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget certificationState(double screenWidth, double screenHeight) {
    int my_certification_number = 13;
    int entire_certification_number = 15;
    int fail_num = 0;
    int participant_number = 1000;
    int participant_100 = 100;
    int participant_80 = 300;
    int participant_under = 600;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("내 인증 현황",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text("${my_certification_number}회",
                  style: TextStyle(
                      fontSize: 10,
                      color: Palette.purPle400,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600)),
              Text(
                  " / ${entire_certification_number}회  |  남은 인증 : ${entire_certification_number - my_certification_number}회",
                  style: TextStyle(
                      fontSize: 10,
                      color: Palette.grey300,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600))
            ]),
            Text("실패 횟수 : ${fail_num}회",
                style: TextStyle(
                    fontSize: 9,
                    color: Palette.grey300,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w400))
          ]),
          const SizedBox(height: 20),
          certificationStateBar(screenWidth),
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

  Widget certificationStateBar(double screenWidth) {
    int my_certification_number = 13;
    int entire_certification_number = 15;
    String percent =
        (my_certification_number / entire_certification_number * 100)
            .toStringAsFixed(1);

    print(percent);
    int fail_num = 0;
    int participant_number = 1000;
    int participant_100 = 100;
    int participant_80 = 300;
    int participant_under = 600;

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            color: Color(0xFFF5F5F5), // 배경색 설정
            borderRadius: BorderRadius.circular(10)), // 컨테이너를 둥글게 만듭니다.
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("현재 달성률",
                      style: TextStyle(
                          color: Palette.grey500,
                          fontSize: 10,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w500)),
                  Text(
                      "${(my_certification_number / entire_certification_number * 100).toStringAsFixed(1)} %",
                      style: const TextStyle(
                          color: Palette.grey500,
                          fontSize: 10,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w700))
                ],
              ),
              const SizedBox(height: 10),
              Container(
                child: ProgressBar(
                  width: screenWidth * 0.9,
                  height: 4,
                  value: double.parse(percent) * 0.01,
                  backgroundColor: Palette.grey50,
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [Palette.purPle200, Palette.mainPurple],
                  ),
                ),
                decoration: BoxDecoration(
                    color: Palette.grey500, // 배경색 설정
                    borderRadius: BorderRadius.circular(5)),
              ),
              const SizedBox(height: 5),
              const Text("예상 달성률 : 100%",
                  style: TextStyle(
                      color: Palette.grey200,
                      fontSize: 9,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w500)),
            ]));
  }

  Widget EntireCertificationStatus(double screenWidth, double screenHeight) {
    double participant_number = 1000;
    final dataMap = <String, double>{"100%": 100, "80% 이상": 300, "80% 미만": 600};
    final colorList = <Color>[
      Palette.purPle500,
      Palette.purPle300,
      Palette.purPle200,
    ];
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("전체 현황",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              Text("총 참여인원 :",
                  style: TextStyle(
                      fontSize: 10,
                      color: Palette.grey300,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600)),
              Text("  ${participant_number}명",
                  style: TextStyle(
                      fontSize: 11,
                      color: Palette.purPle400,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600))
            ]),
          ]),
          const SizedBox(height: 20),
          certificationStateBar(screenWidth),
          const SizedBox(height: 15),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            child: PieChart(
              dataMap: dataMap,
              chartType: ChartType.ring,
              ringStrokeWidth: 20,
              chartRadius: 150,
              baseChartColor: Colors.grey[50]!.withOpacity(0.15),
              colorList: colorList,
              chartValuesOptions: ChartValuesOptions(showChartValues: false),
              totalValue: (participant_number),
              legendOptions: LegendOptions(
                showLegendsInRow: true,
                legendPosition: LegendPosition.bottom,
                showLegends: true,
                legendShape: BoxShape.rectangle,
                legendTextStyle: TextStyle(
                    fontSize: 9,
                    color: Palette.grey300,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w600),
              ),
              centerWidget: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "평균 예상 달성률",
                      style: TextStyle(
                          fontSize: 10,
                          color: Palette.grey200,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w600),
                    ),
                    Text(
                      "88.5%",
                      style: TextStyle(
                          fontSize: 20,
                          color: Palette.grey500,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w600),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}
