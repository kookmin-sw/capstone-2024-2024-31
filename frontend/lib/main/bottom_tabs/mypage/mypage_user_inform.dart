import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class UserInformation extends StatelessWidget {
  const UserInformation({super.key});

  final String userName = '신혜은';
  final int followingNum = 10;
  final int followerNum = 1;
  final int level = 1;
  final String imgUrl = '';

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Row(
          children: [imageStackLevel()],
        ));
  }

  Widget imageStackLevel() {
    return Container(
        width: 90,
        height: 90,
        child: Stack(children: [
          SvgPicture.asset(
            'assets/svgs/default_user_circle.svg',
            width: 80,
            height: 80,
          ),
          Positioned(
              child: SvgPicture.asset('assets/svgs/level_stack.svg'),
              left: 60,
              top: 50),
          Positioned(
              child: Text(
                level.toString(),
                style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontFamily: 'Pretendard',
                    fontSize: 11),
              ),
              left: 68,
              top: 52),
        ]));
  }
}
