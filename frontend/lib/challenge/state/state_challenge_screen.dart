import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:get/get.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import '../../env.dart';
import '../../model/package/pie_chart/src/chart_values_options.dart';
import '../../model/package/pie_chart/src/legend_options.dart';
import '../../model/package/pie_chart/src/pie_chart.dart';

class ChallengeStateScreen extends StatefulWidget {
  final Challenge? challenge;
  final int? challengeId;

  const ChallengeStateScreen({super.key, this.challenge, this.challengeId});

  @override
  _ChallengeStateScreenState createState() => _ChallengeStateScreenState();
}

class _ChallengeStateScreenState extends State<ChallengeStateScreen> {
  final Logger logger = Logger();
  late Future<Challenge> challengeFuture;

  @override
  void initState() {
    super.initState();

    if(widget.challenge == null){
    challengeFuture = _fetchChallenge(); }
    else{
      challengeFuture = widget.challenge as Future<Challenge>;
    }
  }

  Future<Challenge> _fetchChallenge() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();

    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString('access_token')}';
    //
    // try {
      final response =
          await dio.get('${Env.serverUrl}/challenges/${widget.challengeId}');

      if (response.statusCode == 200) {
        final challenge = Challenge.fromJson(response.data);
        return challenge;
      } else {
        logger.e(response.data);
        return Future.error(
            "서버 응답 상태 코드: ${response.statusCode}, ${response.data}");
      }
    // } catch (e) {
    //   logger.e(e);
    //   return Future.error("챌린지 정보를 불러오는데 실패했습니다.");
    // }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Challenge>(
      future: challengeFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        } else if (snapshot.hasError) {
          return Scaffold(
            body: Center(
              child: Text('오류: ${snapshot.error}'),
            ),
          );
        } else if (snapshot.hasData) {
          final thisChallenge = snapshot.data!;
          return buildChallengeScreen(context, thisChallenge);
        } else {
          return const Scaffold(
            body: Center(
              child: Text('챌린지 데이터를 불러올 수 없습니다.'),
            ),
          );
        }
      },
    );
  }

  Widget buildChallengeScreen(BuildContext context, Challenge thisChallenge) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final DateTime? startDate = thisChallenge.startDate;
    final int? challengePeriod = thisChallenge.challengePeriod;
    final DateTime? endDate =
        startDate?.add(Duration(days: challengePeriod! * 7));

    initializeDateFormatting('ko_KR', 'en_US');

    return SafeArea(
        child: Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
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
              )),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            photoes(screenHeight, thisChallenge),
            Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                child:
                    information_challenge(startDate!, endDate!, thisChallenge)),
            SvgPicture.asset(
              'assets/svgs/divider.svg',
              fit: BoxFit.contain,
            ),
            certificationState(screenWidth, screenHeight, thisChallenge),
            SvgPicture.asset(
              'assets/svgs/divider.svg',
              fit: BoxFit.contain,
            ),
            EntireCertificationStatus(screenWidth, screenHeight, thisChallenge)
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

  Widget photoes(double screenHeight, Challenge thisChallenge) {
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
            FrequeuncyAndPeriod(thisChallenge),
            const SizedBox(height: 3),
            Text(thisChallenge.challengeName,
                style: const TextStyle(
                    fontSize: 19,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w600,
                    color: Palette.white)),
          ])),
    ]);
  }

  Widget FrequeuncyAndPeriod(Challenge thisChallenge) {
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
              fontWeight: FontWeight.normal),
        ));
  }

  Widget information_challenge(
      DateTime startDate, DateTime endDate, Challenge thisChallenge) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChallengeExplanation(thisChallenge),
          const SizedBox(height: 5),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: const Color(0xFFF5F5F5),
                  borderRadius: BorderRadius.circular(10)),
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
                            "${DateFormat("M월 d일(E)", "ko_KR").format(startDate)}-${DateFormat("M월 d일(E)", "ko_KR").format(endDate)}  ${thisChallenge.challengePeriod}주",
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
                            DateFormat("yyyy년 M월 d일 (E)", "ko_KR")
                                .format(startDate),
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
                          Text(thisChallenge.certificationFrequency ?? "-",
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
                              "${thisChallenge.certificationStartTime}시 ~ ${thisChallenge.certificationEndTime}",
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
                          Text("${thisChallenge.totalParticipants}명",
                              style: const TextStyle(
                                  color: Palette.grey300,
                                  fontSize: 10,
                                  fontFamily: "Pretendard",
                                  fontWeight: FontWeight.w700))
                        ])
                  ]))
        ]);
  }

  Widget ChallengeExplanation(Challenge thisChallenge) {
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
                  color: Palette.grey500,
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 5),
          Text(
            thisChallenge.challengeName,
            style: const TextStyle(
                fontSize: 12,
                fontFamily: "Pretendard",
                color: Palette.grey300,
                fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }

  Widget certificationState(
      double screenWidth, double screenHeight, Challenge thisChallenge) {
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
              Text("$my_certification_number회",
                  style: const TextStyle(
                      fontSize: 10,
                      color: Palette.purPle400,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600)),
              Text(
                  " / ${entire_certification_number}회  |  남은 인증 : ${entire_certification_number - my_certification_number}회",
                  style: const TextStyle(
                      fontSize: 10,
                      color: Palette.grey300,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600))
            ]),
            Text("실패 횟수 : ${fail_num}회",
                style: const TextStyle(
                    fontSize: 9,
                    color: Palette.grey300,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w400))
          ]),
          const SizedBox(height: 20),
          certificationStateBar(screenWidth, thisChallenge),
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

  Widget certificationStateBar(double screenWidth, Challenge thisChallenge) {
    int my_certification_number = 13;
    String percent =
        (my_certification_number / thisChallenge.totalCertificationCount! * 100)
            .toStringAsFixed(1);

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        decoration: BoxDecoration(
            color: Color(0xFFF5F5F5), borderRadius: BorderRadius.circular(10)),
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
                      "${(my_certification_number / thisChallenge.totalCertificationCount! * 100).toStringAsFixed(1)} %",
                      style: const TextStyle(
                          color: Palette.grey500,
                          fontSize: 10,
                          fontFamily: "Pretendard",
                          fontWeight: FontWeight.w700))
                ],
              ),
              const SizedBox(height: 10),
              Container(
                decoration: BoxDecoration(
                    color: Palette.grey500,
                    borderRadius: BorderRadius.circular(5)),
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
              const Text("예상 달성률 : 100%",
                  style: TextStyle(
                      color: Palette.grey200,
                      fontSize: 9,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w500)),
            ]));
  }

  Widget EntireCertificationStatus(
      double screenWidth, double screenHeight, Challenge thisChallenge) {
    final dataMap = <String, double>{"100%": 100, "80% 이상": 300, "80% 미만": 600};
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
          const Text("전체 현황",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
            Row(children: [
              const Text("총 참여인원 :",
                  style: TextStyle(
                      fontSize: 10,
                      color: Palette.grey300,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600)),
              Text("  ${thisChallenge.totalParticipants}명",
                  style: const TextStyle(
                      fontSize: 11,
                      color: Palette.purPle400,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w600))
            ]),
          ]),
          const SizedBox(height: 20),
          certificationStateBar(screenWidth, thisChallenge),
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
                    fontWeight: FontWeight.w600),
              ),
              totalValue: thisChallenge.totalParticipants.toDouble(),
              legendOptions: const LegendOptions(
                legendValueTextStyle: TextStyle(
                    fontSize: 10,
                    color: Palette.grey500,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w600),
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
              centerWidget: const Center(
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
