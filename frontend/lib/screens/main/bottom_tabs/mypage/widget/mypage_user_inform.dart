import 'package:flutter/material.dart';
import 'package:frontend/screens/main/bottom_tabs/mypage/widget/categoryButtonPress.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class UserInformation extends StatelessWidget {
  UserInformation({super.key});

  final logger = Logger();
  final UserController userController = Get.find<UserController>();

  final tagTextStyle = const TextStyle(
      fontFamily: 'Pretender',
      fontWeight: FontWeight.w600,
      fontSize: 11,
      color: Palette.purPle500);

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageStackLevel(),
              const SizedBox(width: 15),
              Obx(() {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      nameText(screenSize),
                      const SizedBox(height: 4),
                      if (userController.user.categories.isNotEmpty)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
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
                                    children: List.generate(
                                        userController.user.categories.length,
                                        (index) {
                                  return Padding(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 4),
                                      child: Text(
                                        "#${userController.user.categories[index].name}",
                                        style: tagTextStyle,
                                      ));
                                }).toList()))
                          ],
                        )
                      else
                        TextButton(
                            onPressed: () {
                              CategoryButtonPress(context);
                            },
                            child: Text("관심있는 #카테고리 설정하기", style: tagTextStyle))
                    ]);
              })
            ]));
  }

  Widget imageStackLevel() {
    return Container(
        alignment: Alignment.center,
        width: 90,
        height: 90,
        child: CircleAvatar(
          radius: 70,
          backgroundImage: NetworkImage(userController.user.avatar),
        ));
  }

  Widget nameText(Size screenSize) {
    int nameLength = userController.user.name.length;
    return Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
      SizedBox(
          width: nameLength > 5 ? screenSize.width * 0.3 :userController.user.name.length * 25,
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
      const SizedBox(width: 5),
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
