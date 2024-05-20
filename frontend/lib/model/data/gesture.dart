import 'dart:math';

import 'package:flutter/cupertino.dart';

class Gesture {
  List<Map<String, dynamic>> gestureMap = [
    {
      "gesture": "Down",
      "asset": Image.asset("assets/images/camera/Down.png"),
      "nameText": "아래로 향한"
    },
    {
      "gesture": "Side",
      "asset": Image.asset("assets/images/camera/Side.png"),
      "nameText": "좌/우를 가리키는"
    },
    {
      "gesture": "Thumbs Up",
      "asset": Image.asset("assets/images/camera/ThumbsUp.png"),
      "nameText": "엄지 척"
    },
    {
      "gesture": "Stop",
      "asset": Image.asset("assets/images/camera/Stop.png"),
      "nameText": "손바닥을 보이는"
    },
    {
      "gesture": "Thumbs Down",
      "asset": Image.asset("assets/images/camera/ThumbsDown.png"),
      "nameText": "엄지 아래로"
    },
    {
      "gesture": "Up",
      "asset": Image.asset("assets/images/camera/Up.png"),
      "nameText": "위를 가리키는"
    },
  ];

  Map<String, dynamic> getRandomGesture() {
    final random = Random();
    int index = random.nextInt(gestureMap.length);
    print(gestureMap[index]);
    return gestureMap[index];
  }

  bool checkGesture(String targetGesture, String resultOfTflite) {
    if (targetGesture == resultOfTflite.replaceAll('\r', '')) {
      return true;
    }
    return false;
  }
}
