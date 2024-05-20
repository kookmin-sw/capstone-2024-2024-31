import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:intl/intl.dart';

class PointHistoryCard extends StatelessWidget {
  Map<String, dynamic> history;

  PointHistoryCard( {super.key, required this.history});


  TextStyle textStyle(double size, Color color,
      {FontWeight weight = FontWeight.w400}) => TextStyle(
      fontSize: size,
      fontWeight: weight,
      fontFamily: 'Pretender',
      color: color);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
        children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(DateFormat('yyyy-MM-dd').format(history['dateTime']).toString(),
              style: textStyle(12, Palette.grey300)),
          Text("+100", style: textStyle(12, Palette.mainPurple, weight: FontWeight.w500)),
        ],
      ),
      Text(history['challengeName'], style: textStyle(10, Palette.grey200))
    ]);
  }
}
