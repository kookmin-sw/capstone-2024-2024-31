import 'package:flutter/material.dart';
import 'package:frontend/screens/main/bottom_tabs/mypage/follow_point_screen/point_history_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';

class PointScreen extends StatelessWidget {
  PointScreen({super.key});

  TextStyle titleStyle(double value, Color color, FontWeight weight) =>
      TextStyle(
          fontSize: value,
          fontWeight: weight,
          fontFamily: 'Pretender',
          color: color);

  final int point = 9000;
  final int challengeNumber = 90;

  final List<Map<String, dynamic>> pointHistory = [
    {"dateTime": DateTime(2024, 5, 8), "challengeName": "하루 3km 달리기"},
    {"dateTime": DateTime(2024, 9, 8), "challengeName": "하루 3km 코딩하기"},
    {"dateTime": DateTime(2024, 2, 8), "challengeName": "하루 3km 걷고 수영하고"},
    {"dateTime": DateTime(2024, 5, 4), "challengeName": "하루 3km 뛰기"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          '포인트 내역',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretender',
          ),
        ),
      ),
      body: SingleChildScrollView(
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),
                  Center(
                      child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: "쌓인 포인트만큼 나의 ",
                          style:
                              titleStyle(16, Palette.grey300, FontWeight.bold),
                        ),
                        TextSpan(
                          text: "갓생력",
                          style: titleStyle(
                              16, Colors.orangeAccent, FontWeight.bold),
                        ),
                        TextSpan(
                          text: "도 UP!",
                          style:
                              titleStyle(16, Palette.grey300, FontWeight.bold),
                        ),
                      ],
                    ),
                  )),
                  const SizedBox(height: 20),
                  Center(
                      child: SizedBox(
                          width: 100,
                          child: Image.asset(
                            "assets/images/coin_image.png",
                            alignment: Alignment.center,
                          ))),
                  const SizedBox(height: 20),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "챌린지 횟수",
                          style:
                              titleStyle(11, Palette.grey200, FontWeight.w400),
                        ),
                        Text(
                          "$challengeNumber 회",
                          style:
                              titleStyle(11, Palette.grey500, FontWeight.bold),
                        )
                      ]),
                  const SizedBox(height: 5),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "전체 포인트",
                          style:
                              titleStyle(11, Palette.grey200, FontWeight.w400),
                        ),
                        Text(
                          "$point 포인트",
                          style:
                              titleStyle(11, Palette.grey500, FontWeight.bold),
                        )
                      ]),
                  const SizedBox(height: 30),
                  Text(
                    "적립내역",
                    style: titleStyle(13, Colors.black, FontWeight.bold),
                  ),
                  const Padding(
                    padding: EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Divider(
                      thickness: 3,
                      color: Palette.grey50,
                    ),
                  ),
                  ...generatePointHistoryCards(),
                ],
              ))),
    );
  }

  List<Widget> generatePointHistoryCards() {
    // Sort pointHistory by dateTime in descending order
    pointHistory.sort((a, b) => b["dateTime"].compareTo(a["dateTime"]));

    // Generate PointHistoryCard widgets
    return List.generate(pointHistory.length, (index) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: PointHistoryCard(history: pointHistory[index]),
      );
    });
  }
}
