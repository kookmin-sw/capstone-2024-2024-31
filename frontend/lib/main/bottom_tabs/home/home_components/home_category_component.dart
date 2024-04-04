import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class Home_Category extends StatelessWidget {
  final List<Map<String, dynamic>> categoryList = [
    {
      "name": "운동",
      "memo": "튼튼한 몸을 위하여!",
      "icons": "assets/icons/category_icons/exercise.svg",
      "color": const Color(0xffEEE9FD),
    },
    {
      "name": "식습관",
      "memo": "골고루 건강하게!",
      "icons": "assets/icons/category_icons/eating.svg",
      "color": const Color(0xffFFDFDF),
    },
    {
      "name": "취미",
      "memo": "더 즐거운 삶을 위해!",
      "icons": "assets/icons/category_icons/hobby.svg",
      "color": const Color(0xffFFD0A3),
    },
    {
      "name": "환경",
      "memo": "깨끗한 환경에서!",
      "icons": "assets/icons/category_icons/nature.svg",
      "color": const Color(0xffDAF2CB),
    },
    {
      "name": "공부",
      "memo": "지적인 나를 위해!",
      "icons": "assets/icons/category_icons/study.svg",
      "color": const Color(0xffD4E0FF),
    }
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "챌린지 카테고리 >",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontFamily: 'Pretendard',
                    fontSize: 22),
              ),
              const SizedBox(height: 10),
              SizedBox(
                  height: 160,
                  child: ListView(
                    scrollDirection: Axis.horizontal,
                    children: List.generate(categoryList.length, (index) {
                      return CategoryCard(
                        name: categoryList[index]['name'],
                        memo: categoryList[index]['memo'],
                        iconPath: categoryList[index]['icons'],
                        color: categoryList[index]['color'],
                      );
                    }),
                  ))
            ]));
  }
}

class CategoryCard extends StatelessWidget {
  final String name;
  final String memo;
  final String iconPath;
  final Color color;

  CategoryCard({
    required this.name,
    required this.memo,
    required this.iconPath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(0),
        width: 120, // Set the width of the card
        child: Card(
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(8)),
          ),
          color: color,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                  padding: const EdgeInsets.all(15),
                  child: SvgPicture.asset(
                    iconPath,
                    width: 45,
                    height: 45,
                  )),
              Container(
                width: 128,
                height: 77,
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(8), // Rounded bottom-left corner
                    bottomRight: Radius.circular(8), // Rounded bottom-right corner
                  ),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    const SizedBox(height: 10),
                    Text(
                      name,
                      style: const TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      memo,
                      style: const TextStyle(
                        color: Color(0xFF96979B),
                        fontSize: 12,
                        fontWeight: FontWeight.w100,
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
