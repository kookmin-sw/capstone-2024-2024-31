import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_challenge_item_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';

class ChallengeSearchScreen extends StatefulWidget {
  const ChallengeSearchScreen({super.key});

  @override
  State<ChallengeSearchScreen> createState() => _ChallengeSearchScreenState();
}

class _ChallengeSearchScreenState extends State<ChallengeSearchScreen> {
  String searchValue = '';
  bool _isPrivate = false;

  List<String> categoryList = <String>[
    '전체',
    '운동',
    '식습관',
    '취미',
    '환경',
    '공부',
  ];
  int selectedIndex = 0;
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
        challengeImage1: File('assets/images/image.png'),
        isGalleryPossible: true,
        maximumPeople: 100,
        participants: []),
    Challenge(
        isPrivate: false,
        privateCode: 'privateCode',
        challengeName: '걷기',
        challengeImage1: File('assets/images/image.png'),
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
        challengeImage1: File('assets/images/image.png'),
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
        challengeImage1: File('assets/images/image.png'),
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
    Challenge(
        isPrivate: false,
        privateCode: 'privateCode',
        challengeName: '매일 우왁굳하기',
        challengeImage1: File('assets/images/image.png'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EasySearchBar(
          backgroundColor: Palette.purPle200,
          foregroundColor: Palette.white,
          searchTextStyle: const TextStyle(
            color: Palette.mainPurple,
            fontFamily: "Pretendard",
            fontSize: 14,
            fontWeight: FontWeight.bold,
          ),
          title: const Text(
            "전체 챌린지",
            style: TextStyle(
              fontFamily: "Pretendard",
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          onSearch: (value) => setState(() => searchValue = value),
        ),
        body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  selectCategory(),
                  Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                    const Text(
                      "비공개 챌린지만",
                      style: TextStyle(
                        fontFamily: "Pretendard",
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: Palette.grey300,
                      ),
                    ),
                    const SizedBox(width: 5),
                    CupertinoSwitch(
                      value: _isPrivate,
                      thumbColor: Palette.white,
                      trackColor: Palette.greySoft,
                      activeColor: Palette.purPle300,
                      onChanged: (bool? value) {
                        setState(() {
                          _isPrivate = value ?? false;
                        });
                      },
                    ),
                  ]),
                  const SizedBox(height: 5),
                  Expanded(
                      child: GridView.count(
                          shrinkWrap: true,
                          crossAxisCount: 2,
                          childAspectRatio: 1 / 1.4,
                          children:
                              List.generate(challengeList.length, (index) {
                            return ChallengeItemCard(
                                this_challenge: challengeList[index]);
                          })))
                ])));
  }

  Widget selectCategory() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
        child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(
                  categoryList.length,
                  (index) => Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: ElevatedButton(
                        onPressed: () {
                          setState(() {
                            if (selectedIndex == index) {
                              selectedIndex =
                                  -1; // Deselect if already selected
                            } else {
                              selectedIndex = index; // Select otherwise
                            }
                          });
                        },
                        style: ButtonStyle(
                          padding:
                              MaterialStateProperty.all<EdgeInsetsGeometry?>(
                            const EdgeInsets.symmetric(horizontal: 15),
                          ),
                          maximumSize: MaterialStateProperty.all<Size>(
                              const Size(80, 35)),
                          minimumSize: MaterialStateProperty.all<Size>(
                              const Size(10, 35)),
                          // Adjust the button's size
                          shape: MaterialStateProperty.all<OutlinedBorder>(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(15),
                            ),
                          ),
                          backgroundColor: selectedIndex == index
                              ? MaterialStateProperty.all<Color>(
                                  Palette.purPle300)
                              : null,
                        ),
                        child: Text(categoryList[index],
                            style: TextStyle(
                                color: selectedIndex == index
                                    ? Colors.white
                                    : Palette.grey200,
                                fontSize: 11,
                                fontWeight: selectedIndex == index
                                    ? FontWeight.bold
                                    : FontWeight.w500)),
                      ))),
            )));
  }
}
