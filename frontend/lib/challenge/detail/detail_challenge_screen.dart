import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/challenge/detail/detail_imageDetail_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class ChallengeDetailScreen extends StatelessWidget {
  ChallengeDetailScreen({super.key});

  Challenge challenge = Challenge(
      isPrivate: false,
      privateCode: 'privateCode',
      challengeName: '조깅 3KM 하기',
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
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: information_challenge(startDate, endDate)),
                  SvgPicture.asset(
                    'assets/svgs/divider.svg',
                    fit: BoxFit.contain,
                  ),
                  ChallengeExplanation(),
                  ImageGridView(screenHeight, screenWidth),
                  SvgPicture.asset(
                    'assets/svgs/divider.svg',
                    fit: BoxFit.contain,
                  ),
                  certificationMethod(screenWidth, screenHeight)
                ],
              ),
            ),
            bottomNavigationBar: Stack(children: <Widget>[
              Container(
                alignment: Alignment.center,
                padding:
                    const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
                height: 80,
                color: Colors.transparent,
                width: double.infinity,
                child: InkWell(
                  onTap: () {},
                  child: SvgPicture.asset(
                    'assets/svgs/join_challenge_btn.svg',
                    // width: double.infinity,
                    // height: 30,
                  ),
                ),
              ),
              Positioned(
                  top: 5,
                  left: 20,
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 5, vertical: 2),
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
                          fontSize: 11,
                          fontFamily: "Pretendard",
                          color: Palette.white,
                          fontWeight: FontWeight.normal),
                    ),
                  ))
            ])));
  }

  Widget photoes(double screenHeight) {
    return Container(
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage('assets/images/challenge_image.png'),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }

  Widget information_challenge(DateTime startDate, DateTime endDate) {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue, // 동그라미의 배경색
                ),
                child: Image.asset(
                  'assets/images/24.png', // 동그라미 이미지의 경로
                  fit: BoxFit.cover, // 이미지가 동그라미 안에 맞도록 설정
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "루틴업",
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Pretendard",
                    color: Palette.grey300,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          const SizedBox(height: 3),
          Text(challenge.challengeName,
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w700,
                  color: Palette.grey500)),
          const SizedBox(height: 3),
          Row(children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/svgs/detail_user_icon.svg',
                fit: BoxFit.cover,
                // 이미지가 동그라미 안에 맞도록 설정
              ),
            ),
            const SizedBox(width: 5),
            Text("${challenge.participants.length}명의 루티너가 참여중",
                style: const TextStyle(
                    color: Palette.purPle200,
                    fontSize: 10,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500))
          ]),
          const SizedBox(height: 8),
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
                            "${DateFormat("M월 d일 (E)", "ko_KR").format(startDate)}-${DateFormat("M월 d일 (E)", "ko_KR").format(endDate)} ${challenge.challengePeriod}",
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
                                fontWeight: FontWeight.w700))
                      ],
                    )
                  ]))
        ]);
  }

  Widget ImageGridView(double screenHeight, double screenWidth) {
    final List<String> imagePaths = [
      'assets/images/image.png',
      'assets/images/image.png',
      'assets/images/image.png',
      'assets/images/image.png',
    ];

    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        height: screenHeight * 0.15 * 3.3,
        child: GridView.builder(
          padding: EdgeInsets.symmetric(vertical: 4),
          physics: NeverScrollableScrollPhysics(),
          // 스크롤 불가능하게 설정
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 4.0,
          ),
          itemCount: imagePaths.length,

          itemBuilder: (BuildContext context, int index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) =>
                        ImageDetailPage(imagePath: imagePaths[index]),
                  ),
                );
              },
              child: ClipRRect(
                borderRadius: BorderRadius.circular(15.0),
                child: Image.asset(
                  imagePaths[index],
                  height: screenHeight * 0.15,
                  // 이미지 높이 고정
                  width: screenWidth * 0.4,
                  // 이미지 너비 고정                  imagePaths[index],
                  fit: BoxFit.cover,
                ),
              ),
            );
          },
        ));
  }

  Widget ChallengeExplanation() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("챌린지 소개",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 15),
          Text(
            challenge.challengeExplanation,
            style: const TextStyle(
                fontSize: 10,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.w500),
          ),
        ],
      ),
    );
  }

  Widget certificationMethod(double screenWidth, double screenHeight) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("인증 방식",
              style: TextStyle(
                  fontSize: 15,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w600)),
          const SizedBox(height: 20),
          Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
              decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5), // 배경색 설정
                  borderRadius: BorderRadius.circular(10)), // 컨테이너를 둥글게 만듭니다.
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
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
                            "${challenge.certificationStartTime}시 - ${challenge.certificationEndTime}",
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
                        const Text("인증 횟수",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(challenge.certificationFrequency,
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
                        const Text("수단",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(challenge.isGalleryPossible ? "카메라+갤러리" : "카메라",
                            style: const TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    )
                  ])),
          const SizedBox(height: 10),
          Container(
              padding: EdgeInsets.symmetric(horizontal: 5, vertical: 5),
              child: Text(challenge.certificationExplanation,
                  style: const TextStyle(
                      fontSize: 10,
                      fontFamily: "Pretendard",
                      fontWeight: FontWeight.w500))),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              buildImageContainer(challenge.successfulVerificationImage,
                  Palette.green, true, screenWidth, screenHeight),
              SizedBox(width: 10),
              buildImageContainer(challenge.failedVerificationImage,
                  Palette.red, false, screenWidth, screenHeight),
            ],
          ),
        ],
      ),
    );
  }

  Widget buildImageContainer(File? file, Color color, bool isSuccess,
      double screenWidth, double screenHeight) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(
              isSuccess
                  ? 'assets/svgs/check_green.svg'
                  : 'assets/svgs/check_red.svg',
            ),
            const SizedBox(width: 3),
            Text(
              isSuccess ? "성공 예시" : "실패 예시",
              style: const TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                  color: Palette.grey500),
            ),
          ],
        ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            color: Palette.greySoft,
            borderRadius: BorderRadius.circular(33.0),
            border: Border.all(
              color: file != null ? color : Palette.greySoft,
              width: 2.0,
            ),
          ),
          height: screenHeight * 0.16,
          width: screenWidth * 0.42,
          child: file != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),
                  child: Image.file(
                    File(file.path),
                    fit: BoxFit.cover,
                  ),
                )
              : const Icon(
                  Icons.image,
                  size: 35,
                  color: Palette.grey300,
                ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
