import 'dart:io';

import 'package:flutter/material.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_challenge_item_card.dart';
import 'package:frontend/model/data/challenge.dart';
import 'package:get/get.dart';

class ChallengeItemList extends StatefulWidget {
  const ChallengeItemList({super.key});

  @override
  State<ChallengeItemList> createState() => _ChallengeItemListState();
}

class _ChallengeItemListState extends State<ChallengeItemList> {
  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    List<dynamic> challengeList = [
      Challenge(
          isPrivate: true,
          privateCode: 'privateCode',
          challengeName: '달리기',
          challengeExplanation: 'challengeExplanation',
          challengePeriod: '8주',
          startDate: DateTime(2023, 3, 15).toString(),
          certificationFrequency: '평일 매일',
          certificationStartTime: 13,
          certificationEndTime: '24',
          certificationExplanation: 'certificationExplanation',
          challengeImage1 : File('assets/images/image.png'),
          isGalleryPossible: true,
          maximumPeople: 100,
          participants: []),
      Challenge(
          isPrivate: false,
          privateCode: 'privateCode',
          challengeName: '걷기',
          challengeImage1 : File('assets/images/image.png'),
          challengeExplanation: 'challengeExplanation',
          challengePeriod: '2주',
          startDate: DateTime(2023, 3, 16).toString(),
          certificationFrequency: '주말 매일',
          certificationStartTime: 13,
          certificationEndTime: '13',
          certificationExplanation: 'certificationExplanation',
          isGalleryPossible: true,
          maximumPeople: 110,
          participants: []),
      Challenge(
          isPrivate: true,
          challengeImage1 : File('assets/images/image.png'),
          privateCode: 'privateCode',
          challengeName: '수영가기 매일매일',
          challengeExplanation: 'challengeExplanation',
          challengePeriod: '7주',
          startDate: DateTime(2023, 3, 17).toString(),
          certificationFrequency: '주 3일',
          certificationStartTime: 13,
          certificationEndTime: '22',
          certificationExplanation: 'certificationExplanation',
          isGalleryPossible: true,
          maximumPeople: 10,
          participants: []),
      Challenge(
          isPrivate: false,
          privateCode: 'privateCode',
          challengeName: '매일 코딩하기',
          challengeImage1 : File('assets/images/image.png'),
          challengeExplanation: 'challengeExplanation',
          challengePeriod: '3주',
          startDate: DateTime(2023, 3, 18).toString(),
          certificationFrequency: '주 5일',
          certificationStartTime: 13,
          certificationEndTime: '24',
          certificationExplanation: 'certificationExplanation',
          isGalleryPossible: true,
          maximumPeople: 1,
          participants: []),
    ];

    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "챌린지 모아보기 >",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                    fontSize: 15),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  height: screenSize.height * 0.3,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(challengeList.length, (index) {
                      return ChallengeItemCard(this_challenge: challengeList[index]);
                    }),
                  ))
            ]));
  }
}
