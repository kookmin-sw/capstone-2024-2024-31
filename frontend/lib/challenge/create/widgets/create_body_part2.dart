// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:intl/intl.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:frontend/model/config/palette.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:weekly_date_picker/weekly_date_picker.dart';
// import 'package:intl/date_symbol_data_local.dart';
//
// class BodyPart2 extends StatefulWidget {
//
//
//   @override
//   State<StatefulWidget> createState() => _BodyPart2State();
// }
//
// class _BodyPart2State extends State<BodyPart2> {
//   final picker = ImagePicker();
//   XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
//   List<XFile?> multiImage = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수
//   List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수\
//
//   int selectedIndex = -1;
//   DateTime _selectedDay = DateTime.now();
//
//   List<String> frequencyList = <String>[
//     '매일',
//     '평일 매일',
//     '주말 매일',
//     '주 1회',
//     '주 2회',
//     '주 3회',
//     '주 4회',
//     '주 5회',
//     '주 6회'
//   ];
//   String dropdownValue = '매일';
//   int? selectedHourStart = 0;
//   int? selectedHourEnd = 24;
//
//
//   @override
//   void initState() {
//     super.initState();
//     initializeDateFormatting('ko_KR', null);
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//         body:));
//   }
//
// //
// }
