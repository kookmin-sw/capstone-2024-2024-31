import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/search/challenge_search_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/config/category_card_list.dart';
import 'package:get/get.dart';


class HomeCategory extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              const Text(
                "챌린지 카테고리 >",
                style: TextStyle(
                    fontWeight: FontWeight.w500,
                    color: Palette.grey500,
                    fontFamily: 'Pretendard',
                    fontSize: 15),
              ),
              const SizedBox(height: 13),
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

  const CategoryCard({
    super.key,
    required this.name,
    required this.memo,
    required this.iconPath,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          int index =
              categoryList.indexWhere((category) => category['name'] == name);

          Get.to(ChallengeSearchScreen(enterSelectIndex: index + 1));
          },
        child: Container(
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
                        bottomLeft:
                            Radius.circular(8), // Rounded bottom-left corner
                        bottomRight:
                            Radius.circular(8), // Rounded bottom-right corner
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
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          memo,
                          style: const TextStyle(
                            color: Color(0xFF96979B),
                            fontSize: 9,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            )));
  }
}
