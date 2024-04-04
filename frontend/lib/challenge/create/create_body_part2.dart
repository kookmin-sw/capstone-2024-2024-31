import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'package:flutter_svg/svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/model/config/palette.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:weekly_date_picker/weekly_date_picker.dart';
import 'package:intl/date_symbol_data_local.dart';

class BodyPart2 extends StatefulWidget {
  // final Function(bool, String) onPrivateButtonPressed;
  //
  // const BodyPart1({
  //   required this.isPrivateSelected,
  //   required this.onPrivateButtonPressed,
  // });

  @override
  State<StatefulWidget> createState() => _BodyPart2State();
}

class _BodyPart2State extends State<BodyPart2> {
  final picker = ImagePicker();
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수\

  int selectedIndex = -1;
  DateTime _selectedDay = DateTime.now();

  @override
  void initState() {
    super.initState();
    initializeDateFormatting('ko_KR', null);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
            child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SvgPicture.asset('assets/svgs/create_challenge_level2.svg'),
          ),
          inputName(),
          inputIntro(),
          addPicture(),
          selectWeekend(),
          selectStartDay()
        ])));
  }

  Widget inputName() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
        child: Form(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "챌린지 이름",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Pretendard',
                color: Palette.grey300),
          ),
          SizedBox(height: 15),
          SizedBox(
              height: 70,
              child: TextFormField(
                maxLength: 20,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                    fontFamily: 'Pretendard'),
                decoration: InputDecoration(
                    hintText: "챌린지 이름을 입력해주세요.",
                    hintStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Palette.grey200,
                    ),
                    counterStyle: TextStyle(
                        fontSize: 10, // 최대 길이 카운터의 글자 크기
                        color: Palette.grey200,
                        fontFamily: 'Pretendard' // 최대 길이 카운터의 색상
                        ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    filled: true,
                    fillColor: Palette.greySoft,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Palette.greySoft)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Palette.mainPurple, width: 2),
                    )),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return '챌린지 이름을 입력하세요.';
                  }
                  return null;
                },
                onSaved: (value) {
                  // _submittedName = value;
                },
              ))
        ])));
  }

  Widget inputIntro() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Form(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "챌린지 소개",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Pretendard',
                color: Palette.grey300),
          ),
          SizedBox(height: 15),
          SizedBox(
              height: 140,
              child: TextField(
                maxLines: 5,
                maxLength: 50,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                    fontFamily: 'Pretendard'),
                decoration: InputDecoration(
                    hintText: "챌린지를 소개하는 글을 적어주세요.",
                    hintStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Palette.grey200,
                    ),
                    counterStyle: TextStyle(
                        fontSize: 10, // 최대 길이 카운터의 글자 크기
                        color: Palette.grey200,
                        fontFamily: 'Pretendard' // 최대 길이 카운터의 색상
                        ),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                    filled: true,
                    fillColor: Palette.greySoft,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: BorderSide(color: Palette.greySoft)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          BorderSide(color: Palette.mainPurple, width: 2),
                    )),
              ))
        ])));
  }

  Widget addPicture() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "챌린지 소개 사진",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Pretendard',
                color: Palette.grey300),
          ),
          Container(
            height: 100, // 이미지가 표시될 높이
            width: double.infinity,
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal, // 수평 스크롤
              child: Row(
                children: [
                  Container(
                      padding: EdgeInsets.zero,
                      // 갤러리에서 가져오기 버튼
                      height: 60,
                      width: 60,
                      decoration: BoxDecoration(
                        color: Palette.greySoft,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 0.5,
                            blurRadius: 5,
                          )
                        ],
                      ),
                      child: Stack(alignment: Alignment.center, children: [
                        IconButton(
                          //todo : 이미지 5장만 추가할 수 있게 block
                          padding: EdgeInsets.zero,
                          alignment: Alignment.topCenter, // 아이콘을 중앙에 배치
                          onPressed: () async {
                            if (images.length < 5) {
                              // 이미지가 5장 미만일 때만 이미지 추가 동작 수행
                              multiImage = await picker.pickMultiImage();
                              setState(() {
                                images.addAll(multiImage);
                              });
                            } else {
                              Fluttertoast.showToast(
                                msg: "이미지는 최대 5장까지 선택할 수 있습니다.",
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.BOTTOM,
                                backgroundColor: Colors.grey,
                                textColor: Colors.white,
                                fontSize: 10.0,
                              );
                            }
                          },
                          icon: const Icon(
                            Icons.add_photo_alternate_outlined,
                            size: 24,
                            color: Palette.grey200,
                          ),
                        ),
                        Positioned(
                            bottom: 6,
                            child: Text(
                              "${images.length}/5",
                              style: TextStyle(
                                fontSize: 9,
                                fontFamily: 'Pretendard',
                                fontWeight: FontWeight.w300,
                                color: images.length < 5
                                    ? Palette.grey200
                                    : Colors.red[20], // 텍스트 색상 설정
                              ),
                            ))
                      ])),
                  // 선택한 이미지들을 나타내는 그리드 뷰
                  Container(
                    padding: EdgeInsets.all(5),
                    height: 80,
                    // 그리드 뷰의 높이
                    width: images.length * 100.0,
                    // 그리드 뷰의 너비 (이미지 너비 * 이미지 개수)
                    child: GridView.builder(
                      scrollDirection: Axis.horizontal,
                      // 수평 스크롤
                      padding: EdgeInsets.all(5),
                      shrinkWrap: true,
                      itemCount: images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1, // 수평으로 한 번에 보여질 이미지 수
                        childAspectRatio: 1, // 이미지의 가로 세로 비율
                        mainAxisSpacing: 10, // 그리드 뷰의 아이템들 간의 수평 간격 조정
                      ),
                      itemBuilder: (BuildContext context, int index) {
                        // 이미지와 삭제 버튼을 포함한 스택
                        return Stack(
                          alignment: Alignment.topRight,
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: DecorationImage(
                                  fit: BoxFit.cover,
                                  image: FileImage(
                                    File(images[index]!.path),
                                  ),
                                ),
                              ),
                            ),
                            // 삭제 버튼
                            Container(
                              height: 20,
                              width: 20,
                              decoration: BoxDecoration(
                                color: Palette.grey300,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: IconButton(
                                padding: EdgeInsets.zero,
                                constraints: BoxConstraints(),
                                icon: Icon(
                                  Icons.close,
                                  color: Colors.white,
                                  size: 13,
                                ),
                                onPressed: () {
                                  // 이미지 삭제
                                  setState(() {
                                    images.remove(images[index]);
                                  });
                                },
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          )
        ]));
  }

  Widget selectWeekend() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "챌린지 기간",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Pretendard',
                color: Palette.grey300),
          ),
          SizedBox(height: 10),
          SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(
                    8,
                    (index) => Padding(
                        padding: EdgeInsets.symmetric(horizontal: 4),
                        child: ElevatedButton(
                          onPressed: () {
                            setState(() {
                              if (selectedIndex == index) {
                                selectedIndex =
                                    -1; // Deselect if already selected
                              } else {
                                selectedIndex = index; // Select otherwise
                              }
                            });
                          },
                          style: ButtonStyle(
                            minimumSize: MaterialStateProperty.all<Size>(
                                Size(10, 35)), // Adjust the button's size

                            shape: MaterialStateProperty.all<OutlinedBorder>(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                            ),
                            backgroundColor: selectedIndex == index
                                ? MaterialStateProperty.all<Color>(
                                    Palette.mainPurple)
                                : null,
                          ),
                          child: Text("${(index + 1).toString()}주",
                              style: TextStyle(
                                  color: selectedIndex == index
                                      ? Colors.white
                                      : Palette.grey200,
                                  fontSize: 11,
                                  fontWeight: FontWeight.w500)),
                        ))),
              ))
        ]));
  }

  Widget selectStartDay() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 20, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children : [Text(
            "챌린지 시작일",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Pretendard',
                color: Palette.grey300),
          ),
          Text("${DateFormat('M월 d일 (E)', 'ko_KR').format(_selectedDay)}   ", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, fontFamily: 'Pretendard', color: Palette.mainPurple),)]),
          SizedBox(height: 15),
          WeeklyDatePicker(
            selectedDay: _selectedDay,
            changeDay: (value) => setState(() {
              _selectedDay = value;
              print(_selectedDay);
            }),
            enableWeeknumberText: false,
            weeknumberColor: Palette.grey200,
            weeknumberTextColor: Palette.grey200,
            backgroundColor: Palette.greySoft,
            weekdayTextColor: Palette.grey200,
            digitsColor: Colors.grey,
            selectedDigitBackgroundColor: Palette.mainPurple,
            weekdays: const ["월", "화", "수", "목", "금", "토", "일"],
            daysInWeek: 7,
          ),
        ]));
  }
}
