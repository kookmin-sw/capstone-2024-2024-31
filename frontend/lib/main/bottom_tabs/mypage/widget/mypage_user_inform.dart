import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/main/bottom_tabs/mypage/widget/categoryButtonPress.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/user.dart';
import 'package:get/get.dart';

class UserInformation extends StatelessWidget {
  UserInformation({super.key});

  final UserController userController = Get.find<UserController>();

  final int followingNum = 10;
  final int followerNum = 1;
  final int level = 1;
  final String imgUrl = '';
  final tagTextStyle = const TextStyle(
      fontFamily: 'Pretender',
      fontWeight: FontWeight.w600,
      fontSize: 11,
      color: Palette.purPle500);

  List<String> categoryList = [];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageStackLevel(),
              const SizedBox(width: 15),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                nameText(screenSize),
                const SizedBox(height: 4),
                if (categoryList.isNotEmpty)
                  Column(
                    children: [
                      const Text(
                        "루티너님의 관심사는",
                        style: TextStyle(
                            fontFamily: 'Pretendard',
                            fontWeight: FontWeight.w500,
                            fontSize: 11,
                            color: Colors.grey),
                      ),
                      GestureDetector(
                          onTap: () {
                            CategoryButtonPress(context);
                          },
                          child: Row(
                              children:
                                  List.generate(categoryList.length, (index) {
                            return Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 4),
                                child: Text(
                                  "#${categoryList[index]}",
                                  style: tagTextStyle,
                                ));
                          })))
                    ],
                  )
                else
                  TextButton(
                      onPressed: () {
                        CategoryButtonPress(context);
                      },
                      child: Text("관심있는 #카테고리를 설정하세요!", style: tagTextStyle))
              ])
            ]));
  }

  Widget imageStackLevel() {
    return Container(
        alignment: Alignment.center,
        width: 90,
        height: 90,
        child: Stack(children: [
          CircleAvatar(
            radius: 70,
            backgroundImage: NetworkImage(userController.user.avatar),
          ),
          Positioned(
              left: 65,
              top: 65,
              child: SvgPicture.asset('assets/svgs/level_stack.svg')),
          Positioned(
              left: 75,
              top: 67,
              child: Text(
                level.toString(),
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                    fontSize: 11),
              )),
        ]));
  }

  Widget nameText(Size screenSize) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      SizedBox(
          width: userController.user.name.length * 25,
          height: 35,
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Container(
                height: 10, // 밑줄의 높이
                color: Palette.purPle50, // 밑줄 색상 설정
              ),
              Text(
                userController.user.name,
                style: const TextStyle(
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis, // 오버플로우 발생 시 처리 방식 설정
                ),
              )
            ],
          )),
      const Text(
        '님 반가워요!',
        style: TextStyle(
            overflow: TextOverflow.fade,
            fontSize: 17,
            fontFamily: 'Pretendard',
            fontWeight: FontWeight.w500),
      )
    ]);
  }
}
