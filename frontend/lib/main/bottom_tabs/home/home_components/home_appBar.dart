import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/config/palette.dart';

Widget home_appBar = AppBar(
  backgroundColor: Palette.mainPurple,
  foregroundColor: Colors.white,
  leading: Padding(
      padding: const EdgeInsets.only(left: 10, top: 3, bottom: 3),
      child: Image.asset(
        'assets/images/logo/logo_white.png',
        fit: BoxFit.cover,
      )),
  leadingWidth: 100,
  actions: [
    Padding(
      padding: const EdgeInsets.symmetric( horizontal: 2),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
// 알림 버튼 클릭 시 수행할 작업
            },
          ),
          IconButton(
            icon: SvgPicture.asset('assets/svgs/icon_point.svg',color: Colors.white,
            width: 50),
            onPressed: () {
  print("buttton");
              },
          ),
        ],
      ),
    ),
  ],
);
