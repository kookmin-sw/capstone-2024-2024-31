import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:get/get.dart';

class UserInformation extends StatelessWidget {
  UserInformation({super.key});

  final UserController userController = Get.find<UserController>();

  // final String userName = ;
  final int followingNum = 10;
  final int followerNum = 1;
  final int level = 1;
  final String imgUrl = '';

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
        child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              imageStackLevel(),
              const SizedBox(width: 15),
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                nameText(screenSize),
                const SizedBox(height: 4),
                Text(
                  "루티너님의 관심사는",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w500,
                      fontSize: 11,
                      color: Colors.grey),
                ),
                Text(
                  "#그림 #헬스 #운동 #환경",
                  style: TextStyle(
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.w600,
                      fontSize: 11,
                      color: Palette.purPle500),
                ),
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
              child: SvgPicture.asset('assets/svgs/level_stack.svg'),
              left: 65,
              top: 65),
          Positioned(
              child: Text(
                level.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                    fontSize: 11),
              ),
              left: 75,
              top: 67),
        ]));
  }

  Widget nameText(Size screenSize) {
    return Row(mainAxisAlignment: MainAxisAlignment.start, children: [
      Container(
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
                style: TextStyle(
                  fontSize: 17,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis, // 오버플로우 발생 시 처리 방식 설정
                ),
              )
            ],
          )),
      Text(
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
