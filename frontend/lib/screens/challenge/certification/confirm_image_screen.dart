import 'package:flutter/material.dart';
import 'package:frontend/screens/community/create_posting_screen.dart';
import 'package:get/get.dart';
import 'dart:io';

import '../../../model/config/palette.dart';
import 'certification_camera.dart';

class ConfirmImageScreen extends StatelessWidget {
  final File image;

  const ConfirmImageScreen({super.key, required this.image});

  TextStyle textStyle(double size, Color color,
          {FontWeight weight = FontWeight.w400}) =>
      TextStyle(
          fontSize: size,
          fontWeight: weight,
          fontFamily: 'Pretender',
          color: color);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        titleSpacing: 15.0,
        backgroundColor: Palette.mainPurple,
        centerTitle: false,
        title: Text(
          '사진 확인',
          style: textStyle(15, Palette.white, weight: FontWeight.bold),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(image),
          ),
          Text(
            '✔️ 이 사진으로 업로드 하시겠습니까?',
            style: textStyle(13, Palette.grey300, weight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: Text(
                  '다시 찍기',
                  style: textStyle(18, Palette.mainPurple,
                      weight: FontWeight.bold),
                ),
                onPressed: () {
                  Get.off(() => const CertificationCamera());
                },
              ),
              TextButton(
                child: Text(
                  '예',
                  style: textStyle(18, Palette.mainPurple,
                      weight: FontWeight.bold),
                ),
                onPressed: () {
                  print(image);
                  Get.back(result: image); // 이미지 반환하고 이전 화면으로 돌아가기
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
