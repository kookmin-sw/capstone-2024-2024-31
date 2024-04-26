import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';

Widget home_appBar = AppBar(
  backgroundColor: Palette.mainPurple,
  foregroundColor: Colors.white,
  leading: Padding(
      padding: const EdgeInsets.only(top: 20, left: 10),
      child: Image.asset(
        'assets/images/logo/logo_white.png',
        fit: BoxFit.cover,
      )),
  leadingWidth: 120,
  actions: [
    Padding(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 2),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
// 알림 버튼 클릭 시 수행할 작업
            },
          ),
          IconButton(
            //todo : 디자인 받으면 아이콘 수정하기
            icon: const Icon(Icons.image),
            onPressed: () {
// 이미지 아이콘 버튼 클릭 시 수행할 작업
            },
          ),
        ],
      ),
    ),
  ],
);
