import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/challenge/create/create_challenge_screen_fir.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';

Widget homeAppBar = AppBar(
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
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.notifications),
            onPressed: () {
// 알림 버튼 클릭 시 수행할 작업
            },
          ),
          IconButton(
            icon: const Icon(CupertinoIcons.add),
            onPressed: () {
              Get.to(() => const CreateChallengeFir());
            },
          ),
        ],
      ),
    ),
  ],
);
