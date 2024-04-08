import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/model/data/challenge.dart';

class ChallengeDetailScreen extends StatelessWidget {
  ChallengeDetailScreen({super.key});

  Challenge challenge = Challenge.builder(
      challengeName: '조깅 3KM 하기',
      startDate: DateTime(2024, 4, 15),
      endDate: DateTime(2024, 4, 15).add(Duration(days: 56)),
      certificationFrequency: 4,
      certificationExplanation: '인증방식에 대한 설명이다. 인증해야지 안인증하면 안인정해줌 어잊인정~',
      certificationCount: 1,
      certificationMethod: '카메라',
      challengeExplanation: '챌린지에대한 설명이올시다. 챌린지를 하지 않는자 도태되리라',
      maximumPeople: 800,
      isPrivate: false, privateCode: 'privateCode',
      participants: []);


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          children: [
          ],
        ),
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        color: Colors.transparent,
        width: double.infinity,
        child: InkWell(
          onTap: () {},
          child: SvgPicture.asset(
            'assets/svgs/join_challenge.svg',
            // width: double.infinity,
            // height: 30,
          ),
        ),
      ),
    );
  }

  Widget photoes() {
    return Container(

    );
  }

  Widget information_challenge() {
    return Column(
        children: [
          Row(
            children: [
              Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue, // 동그라미의 배경색
                ),
                child: Image.asset(
                  'assets/circle_image.png', // 동그라미 이미지의 경로
                  fit: BoxFit.cover, // 이미지가 동그라미 안에 맞도록 설정
                ),
              ),
              // Text(
              //
              // )
            ],
          ),
          // Text(),
          Row(),
          Container(
              child: Column(
                  children: [
                    Row(),
                    Row(),
                    Row()]
              )
          )
        ]

    );
  }
}