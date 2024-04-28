import 'dart:math';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/config/palette.dart';

class ChallengeRecommendBox extends StatelessWidget {
  final String name;

  ChallengeRecommendBox({required this.name, super.key});

  List<Map<String, String>> categoryIconList = [
    {'category': '운동', 'svg_icon': 'assets/icons/category_icons/exercise.svg'},
    {'category': '식습관', 'svg_icon': 'assets/icons/category_icons/eating.svg'},
    {'category': '취미', 'svg_icon': 'assets/icons/category_icons/hobby.svg'},
    {'category': '환경', 'svg_icon': 'assets/icons/category_icons/nature.svg'},
    {'category': '공부', 'svg_icon': 'assets/icons/category_icons/study.svg'}
  ];

  Map<String, String> getRandomCategory(
      List<Map<String, String>> categoryIconList) {
    // Generate a random index
    int randomIndex = Random().nextInt(categoryIconList.length);

    // Get the randomly selected map
    Map<String, String> randomMap = categoryIconList[randomIndex];

    return randomMap!;
  }

  @override
  Widget build(BuildContext context) {
    Map<String, String> randomCategory = getRandomCategory(
      categoryIconList
    );
    return Container(
      color: Palette.mainPurple,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "$name 님 오늘은 ${randomCategory['category']} 관련 챌린지를 도전해 볼까요?",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Palette.white),
                  ),
                  child: const Text(
                    "챌린지 보러가기",
                    style: TextStyle(
                      color: Palette.mainPurple,
                      fontSize: 13,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 30),
          SvgPicture.asset(
            '${randomCategory['svg_icon']}',
            width: 90, // 조절할 아이콘의 너비
            height: 90, // 조절할 아이콘의 높이
            // color: Colors.white,
          ),
        ],
      ),
    );
  }
}
