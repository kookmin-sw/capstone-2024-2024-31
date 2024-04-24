import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
import 'package:frontend/challenge/state/state_challenge_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';
import 'package:simple_progress_indicators/simple_progress_indicators.dart';
import 'dart:io';

class ChallengeStateBox extends StatefulWidget {
  const ChallengeStateBox({super.key});

  @override
  State<ChallengeStateBox> createState() => _ChallengeStateBoxState();
}

class _ChallengeStateBoxState extends State<ChallengeStateBox> {
  List<Map<String, dynamic>> challengeList = [
    {'name': '매일 커밋하기', 'percent': '50', 'image': 'assets/images/image.png'},
    {'name': '매일 운동하기', 'percent': '10', 'image': 'assets/images/image.png'},
    {'name': '매일 먹기', 'percent': '30', 'image': 'assets/images/image.png'},
  ];

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
          File("C:/Users/82103/Pictures/Screenshots/image.png"),
      failedVerificationImage:
          File("C:/Users/82103/Pictures/Screenshots/image.png"),
      challengeImage1: File("C:/Users/82103/Pictures/Screenshots/image.png"),
      challengeImage2: File("C:/Users/82103/Pictures/Screenshots/image.png"),
      isGalleryPossible: true,
      maximumPeople: 100,
      participants: []);

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Palette.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
          child: SizedBox(
            height: 186, // Specify a fixed height here
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero, // 내부 패딩을 없앰
                    splashFactory: NoSplash.splashFactory,
                  ),
                  child: const Text("내 챌린지 현황 >",
                      style: TextStyle(
                        fontFamily: 'Pretendard',
                        fontWeight: FontWeight.bold,
                        color: Palette.grey500,
                        fontSize: 15,
                      )),
                  onPressed: () {
                    print("dddd");
                  },
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
                Expanded(
                  child: Swiper(
                    itemCount: challengeList.length,
                    pagination: new SwiperPagination(
                      alignment: Alignment.bottomCenter,
                      builder: new DotSwiperPaginationBuilder(
                          space: 3,
                          size: 8,
                          activeSize: 9,
                          color: Palette.softPurPle,
                          activeColor: Palette.purPle300),
                    ),
                    itemBuilder: (context, index) {
                      return Column(children: [
                        challengeStateCard(screenWidth, index),
                        SizedBox(height: 10)
                      ]);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget challengeStateCard(double screenWidth, int index) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ChallengeStateScreen(
                      challenge: challenge,
                    )),
          );
        },
        child: Container(
            width: screenWidth * 0.95,
            child: Card(
                color: Colors.grey[90],
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 10),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Image.asset(
                              challengeList[index]['image'], // 이미지 경로
                              width: 50, // 이미지 너비
                              height: 50, // 이미지 높이
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
                                      Text(
                                        challengeList[index]['name'], // 챌린지 이름
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 10,
                                        ),
                                      ),
                                      Text(
                                        '${challengeList[index]['percent']}%',
                                        style: TextStyle(fontSize: 11), // 진행 상태
                                      ),
                                    ],
                                  )),
                              SizedBox(
                                height: 8,
                              ),
                              stateBar(screenWidth,
                                  double.parse(challengeList[index]['percent']))
                            ],
                          ),
                          SizedBox(width: 10),
                          Container(
                            width: 1,
                            height: 40,
                            color: Colors.grey[300],
                          ),
                          SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {
                              // 버튼을 눌렀을 때 실행할 동작
                              print('Button pressed');
                            },
                            style: ElevatedButton.styleFrom(
                              minimumSize: Size(40, 40),
                              // 버튼의 최소 크기
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(
                                    10.0), // 테두리를 둥글게 만드는 부분
                              ),
                              padding: EdgeInsets.zero,
                              // 내부 여백 없음
                              backgroundColor: Palette.purPle50,
                              // 버튼 배경색
                              foregroundColor: Palette.purPle700,
                              // 텍스트 및 아이콘 색상
                            ),
                            child: Text('인증',
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
//
//
// List<Widget> AuthList() {
//
//
//   return challengeList.map((challenge) {
//     return Card(
//       color: const Color(0xFFF1F1F1),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const SizedBox(width: 8),
//           ClipRRect(
//             borderRadius: BorderRadius.circular(10),
//             child: Image.asset(
//               challenge['image'], // 이미지 경로
//               width: 40, // 이미지 너비
//               height: 40, // 이미지 높이
//             ),
//           ),
//           const SizedBox(width: 8),
//           Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: [
//               Expanded(
//                 child: Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Text(
//                         challenge['name'], // 챌린지 이름
//                         style: TextStyle(
//                             fontWeight: FontWeight.bold,
//                             fontSize: 10),
//
//                       ),
//                       Text(
//                           '${challenge['percent']}%',
//                           style: TextStyle(fontSize: 12) // 진행 상태
//                       )
//                     ]),
//               )
//             ],
//           ),
//           GestureDetector(
//             onTap: () {
//               // 버튼을 눌렀을 때 실행할 동작
//               print('Button pressed');
//             },
//             child: SizedBox(
//               width: 50, // 버튼의 너비
//               height: 50, // 버튼의 높이
//               child: SvgPicture.asset(
//                 'assets/buttons/auth_mini_btn.svg', // SVG 파일의 경로
//                 width: 50, // SVG 이미지의 너비
//                 height: 50, // SVG 이미지의 높이
//               ),
//             ),
//           )
//         ],
//       ),
//     );
//   }).toList();
// }
//
//
