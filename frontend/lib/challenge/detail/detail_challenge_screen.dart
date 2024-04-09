import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
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
      challengeExplanation: '챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라',
      challengePeriod: '8주',
      startDate: '2024-04-08',
      certificationFrequency: '4번',
      certificationStartTime: 1,
      certificationEndTime: '24시',
      certificationExplanation: '인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~',
      isGalleryPossible: true,
      maximumPeople: 100,
      participants: []);

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    initializeDateFormatting('ko_KR', 'en_US');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        // AppBar를 투명하게 설정
        elevation: 0,
        // 그림자 없애기
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.ios_share)),
        ],
        title: const Text(
          '챌린지 상세정보',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [photoes(screenHeight),
            information_challenge()],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
    );
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

  Widget information_challenge() {
    return Column(children: [
      Row(
        children: [
          Container(
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.blue, // 동그라미의 배경색
            ),
            child: Image.asset(
              'assets/images/24.png', // 동그라미 이미지의 경로
              fit: BoxFit.cover, // 이미지가 동그라미 안에 맞도록 설정
            ),
          ),
          Text(
            "루틴업",
            style: TextStyle(fontSize: 8),
          )
        ],
      ),
      Text(challenge.challengeName,
          style: TextStyle(
              fontSize: 24,
              fontFamily: "Pretendard",
              fontWeight: FontWeight.bold)),
      Row(children: [
        Container(
          width: 20,
          height: 20,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: Colors.blue, // 동그라미의 배경색
          ),
          child: Image.asset(
            'assets/images/detail_man_icon.png', // 동그라미 이미지의 경로
            fit: BoxFit.cover, // 이미지가 동그라미 안에 맞도록 설정
          ),
        ),
        Text("${challenge.participants.length}명의 루티너가 참여중",
            style: TextStyle(
                color: Palette.purPle400,
                fontSize: 14,
                fontFamily: "Pretendard",
                fontWeight: FontWeight.bold))
      ]),
      Container(
          padding: EdgeInsets.symmetric(vertical: 5, horizontal: 10),
          decoration: BoxDecoration(
              color: Color(0xFFF5F5F5), // 배경색 설정
              borderRadius: BorderRadius.circular(10)), // 컨테이너를 둥글게 만듭니다.
          child: Column(children: [
            Row(
              children: [
                Text("기간",
                    style: TextStyle(
                        color: Palette.grey200,
                        fontSize: 10,
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w500)),
                Text(
                    "${DateFormat("M월 d일 (E)", "ko_KR").format(DateTime.parse(challenge.startDate))}-*월 *일 ${challenge.challengePeriod}",
                    style: TextStyle(
                        color: Palette.grey300,
                        fontSize: 10,
                        fontFamily: "Pretendard",
                        fontWeight: FontWeight.w700))
              ],
            ),
            Row(),
            Row()
          ]))
    ]);
  }
}
