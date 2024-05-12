import 'package:flutter/material.dart';
import 'package:frontend/main/bottom_tabs/mypage/follow_point_screen/point_screen.dart.dart';
import 'package:frontend/main/bottom_tabs/mypage/follow_point_screen/tab_follow_screen.dart';
import 'package:frontend/main/bottom_tabs/mypage/follow_point_screen/point_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';

class PurpleThreeBox extends StatelessWidget {
  PurpleThreeBox({super.key});

  final List<dynamic> _followerList = [
    {
      'image': 'assets/images/image.png',
      'name': '루틴업 공식계정',
      'isFollowing': false
    },
    {
      'image': 'assets/images/image.png',
      'name': '루틴업 공식계정',
      'isFollowing': true
    },
    {
      'image': 'assets/images/image.png',
      'name': '루틴업 샤넬',
      'isFollowing': false
    },
    {
      'image': 'assets/images/image.png',
      'name': '코코 공식계정',
      'isFollowing': false
    },
    {
      'image': 'assets/images/image.png',
      'name': '일론머스크 공식계정',
      'isFollowing': true
    },
    {
      'image': 'assets/images/image.png',
      'name': '루틴업 만만세',
      'isFollowing': false
    },
    {'image': 'assets/images/image.png', 'name': '형아', 'isFollowing': true}
  ];

  final List<dynamic> _followingList = [
    {
      'image': 'assets/images/image.png',
      'name': '루틴업 공식계정',
      'isFollowing': true
    },
    {
      'image': 'assets/images/image.png',
      'name': '루틴업 샤넬',
      'isFollowing': false
    },
    {
      'image': 'assets/images/image.png',
      'name': '코코 공식계정',
      'isFollowing': false
    },
    {
      'image': 'assets/images/image.png',
      'name': '일론머스크 공식계정',
      'isFollowing': true
    },
    {
      'image': 'assets/images/image.png',
      'name': '루틴업 만만세',
      'isFollowing': false
    },
    {'image': 'assets/images/image.png', 'name': '형아', 'isFollowing': true}
  ];

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    int point = 1;

    return Container(
        width: screenSize.width * 0.87,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12), // 컨테이너 둥글게 설정
            color: Palette.purPle300),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            button(context, screenSize, _followingList.length, '팔로잉'),
            Container(
              width: 1,
              height: 40,
              color: Palette.greySoft,
            ),
            button(context, screenSize, _followerList.length, '팔로워'),
            Container(
              width: 1,
              height: 40,
              color: Colors.grey[100],
            ),
            button(context, screenSize, point, '포인트', isPoint: true),
          ],
        ));
  }

  Widget button(BuildContext context, Size screenSize, int number, String text,
      {isPoint = false}) {
    return GestureDetector(
        onTap: () {
          if (text == '팔로잉') {
            Get.to(() => TabFollowScreen(
                  followerList: _followerList,
                  followingList: _followingList,
                  isFromFollowing: true,
                ));
          } else if (text == '팔로워') {
            Get.to(() => TabFollowScreen(
                  followerList: _followerList,
                  followingList: _followingList,
                  isFromFollowing: false,
                ));
          } else {
            Get.to(() => PointScreen());
          }
        },
        child: Container(
            // color: Colors.grey,
            padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 10),
            width: screenSize.width * 0.25,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  isPoint ? '$number point' : number.toString(),
                  style: const TextStyle(
                      fontWeight: FontWeight.w400,
                      fontFamily: 'Pretendard',
                      fontSize: 15,
                      color: Colors.white),
                ),
                Text(
                  text,
                  style: const TextStyle(
                      fontWeight: FontWeight.w100,
                      fontFamily: 'Pretendard',
                      fontSize: 10,
                      color: Colors.white70),
                ),
              ],
            )));
  }
}
