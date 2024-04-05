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

class BodyPart3 extends StatefulWidget {
  // final Function(bool, String) onPrivateButtonPressed;
  //
  // const BodyPart1({
  //   required this.isPrivateSelected,
  //   required this.onPrivateButtonPressed,
  // });

  @override
  State<StatefulWidget> createState() => _BodyPart3State();
}

class _BodyPart3State extends State<BodyPart3> {
  final picker = ImagePicker();
  XFile? image; // 카메라로 촬영한 이미지를 저장할 변수
  List<XFile?> multiImage = []; // 갤러리에서 여러 장의 사진을 선택해서 저장할 변수
  List<XFile?> images = []; // 가져온 사진들을 보여주기 위한 변수\

  List<bool> isAuthMethodSelected = [true, false]; // 각 버튼의 선택 상태를 나타내는 리스트

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
            child: SvgPicture.asset('assets/svgs/create_challenge_level3.svg'),
          ),
          inputAuthIntro(),
          pickAuthMethod(),
          addPicture(),
          // selectWeekend(),
          // selectStartDay(),
          // selectFrequency(),
          // selectAuthTime()
        ])));
  }

  Widget inputAuthIntro() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Form(
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "인증 방법",
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
                minLines: 3,
                maxLength: 200,
                style: TextStyle(
                    fontWeight: FontWeight.w300,
                    fontSize: 11,
                    fontFamily: 'Pretendard'),
                decoration: InputDecoration(
                    hintText: "인증 방법을 자세하게 알려주세요.",
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

  Widget pickAuthMethod() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "인증 수단",
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Pretendard',
                color: Palette.grey300),
          ),
          SizedBox(height: 15),
          ToggleButtons(
            focusColor: Palette.mainPurple,
            borderRadius: BorderRadius.circular(30.0),
            isSelected: isAuthMethodSelected,
            onPressed: (int index) {
              setState(() {
                // 버튼이 선택되면 해당 인덱스의 상태를 토글
                for (int buttonIndex = 0;
                    buttonIndex < isAuthMethodSelected.length;
                    buttonIndex++) {
                  if (buttonIndex == index) {
                    isAuthMethodSelected[buttonIndex] = true;
                  } else {
                    isAuthMethodSelected[buttonIndex] = false;
                  }
                }
              });
            },
            children: [
              // 첫 번째 버튼 (카메라)
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                height: 50,
                width: 130,
                child: Text(
                  '카메라',
                  style: TextStyle(
                    fontWeight: isAuthMethodSelected[0]
                        ? FontWeight.bold // 선택된 버튼의 텍스트 색상
                        : FontWeight.w400,
                    fontSize: 13,
                    fontFamily: 'Pretendard',
                    color: isAuthMethodSelected[0]
                        ? Palette.mainPurple // 선택된 버튼의 텍스트 색상
                        : Palette.grey300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              // 두 번째 버튼 (갤러리)
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                height: 50,
                width: 130,
                child: Text(
                  '카메라+갤러리',
                  style: TextStyle(
                    fontWeight: isAuthMethodSelected[1]
                        ? FontWeight.bold // 선택된 버튼의 텍스트 색상
                        : FontWeight.w400,
                    fontSize: 13,
                    fontFamily: 'Pretendard',
                    color: isAuthMethodSelected[1]
                        ? Palette.mainPurple // 선택된 버튼의 텍스트 색상
                        : Palette.grey300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ]));
  }

  Widget addPicture() {
    return Padding(
        padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "인증 성공 / 실패 예시",
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
}
