import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/services.dart';

class BodyPart3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BodyPart3State();
}

class _BodyPart3State extends State<BodyPart3> {
  final picker = ImagePicker();
  XFile? successFile;
  XFile? failFile;
  List<bool> _toggleSelections = [true, false];
  bool _isCapacity = false;
  TextEditingController _maxCapacityController = TextEditingController();

  Future<void> _pickImage(bool isSuccess) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (isSuccess) {
          successFile = XFile(pickedImage.path);
          print('successFile${successFile!.path}');

        } else {
          failFile = XFile(pickedImage.path);
          print('failFile${failFile!.path}');

        }

      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric( horizontal: 20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child:
                  SvgPicture.asset('assets/svgs/create_challenge_level3.svg'),
            ),
            inputAuthIntro(),
            pickAuthMethod(),
            SizedBox(height: 15),
            addPicture(),
            SizedBox(height: 25),
            maxCapacity(),
            SizedBox(height: 15),
            _isCapacity ? buildMaxCapacity() : Container()
          ],
        ),
      ),
    ));
  }

  Widget inputAuthIntro() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "인증 방법",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Palette.grey300,
          ),
        ),
        SizedBox(height: 15),
        TextField(
          maxLines: 5,
          minLines: 3,
          maxLength: 200,
          style: TextStyle(
            fontWeight: FontWeight.w300,
            fontSize: 11,
          ),
          decoration: InputDecoration(
            hintText: "인증 방법을 자세하게 알려주세요.",
            hintStyle: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w300,
              color: Palette.grey200,
            ),
            counterStyle: TextStyle(
              fontSize: 10,
              color: Palette.grey200,
            ),
            contentPadding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
            filled: true,
            fillColor: Palette.greySoft,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Palette.greySoft),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
              borderSide: BorderSide(color: Palette.mainPurple, width: 2),
            ),
          ),
        ),
      ],
    );
  }

  Widget pickAuthMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "인증 수단",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Palette.grey300,
          ),
        ),
        SizedBox(height: 15),
        ToggleButtons(
          borderRadius: BorderRadius.circular(12), // 전체 토글 버튼의 둥근 정도 설정
          isSelected: _toggleSelections,
          onPressed: (int index) {
            setState(() {
              // 토글 버튼이 클릭되었을 때 포커스를 변경
              for (int buttonIndex = 0;
                  buttonIndex < _toggleSelections.length;
                  buttonIndex++) {
                if (buttonIndex == index) {
                  _toggleSelections[buttonIndex] = true;
                } else {
                  _toggleSelections[buttonIndex] = false;
                }
              }
            });
          },
          children: [
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              height: 50,
              width: 130,
              child: Text(
                '카메라',
                style: TextStyle(
                  fontWeight:
                      _toggleSelections[0] ? FontWeight.bold : FontWeight.w400,
                  fontSize: 13,
                  color: _toggleSelections[0]
                      ? Palette.mainPurple
                      : Palette.grey300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(vertical: 12),
              height: 50,
              width: 130,
              child: Text(
                '카메라+갤러리',
                style: TextStyle(
                  fontWeight:
                      _toggleSelections[1] ? FontWeight.bold : FontWeight.w400,
                  fontSize: 13,
                  color: _toggleSelections[1]
                      ? Palette.mainPurple
                      : Palette.grey300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget addPicture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: 15),
        Text(
          "인증 성공 / 실패 예시",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Palette.grey300,
          ),
        ),
        SizedBox(height: 15),
        Row(
          children: [
            buildImageContainer(successFile, Palette.green, true),
            SizedBox(width: 20),
            buildImageContainer(failFile, Palette.red, false),
          ],
        ),
      ],
    );
  }

  Widget buildImageContainer(XFile? file, Color color, bool isSuccess) {
    return GestureDetector(
      onTap: () {
        _pickImage(isSuccess);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Palette.greySoft,
              borderRadius: BorderRadius.circular(33.0),
              border: Border.all(
                color: file != null ? color : Palette.greySoft,
                width: 2.0,
              ),
            ),
            height: 120,
            width: 120,
            child: file != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image.file(
                      File(file.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : Icon(
                    Icons.image,
                    size: 35,
                    color: Palette.grey300,
                  ),
          ),
          SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isSuccess
                    ? 'assets/icons/check_green.png'
                    : 'assets/icons/check_red.png',
                color: color,
              ),
              SizedBox(width: 5),
              Text(
                isSuccess ? "성공 예시" : "실패 예시",
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Palette.grey200),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget maxCapacity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "최대 모집 인원 설정하기",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Palette.grey300,
            ),
          ),
          Text(
            "모집 인원을 제한 설정할 수 있어요",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w200,
              fontSize: 10,
              color: Palette.grey300,
            ),
          ),
        ]),
        CupertinoSwitch(
          value: _isCapacity,
          activeColor: Palette.mainPurple,
          onChanged: (bool? value) {
            setState(() {
              _isCapacity = value ?? false;
            });
          },
        ),
      ],
    );
  }

  Widget buildMaxCapacity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 300,
          height: 56,
          padding: EdgeInsets.symmetric(vertical: 5),
          margin: EdgeInsets.symmetric(horizontal: 10),
          child: TextField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4), // 최대 4자리까지 입력 가능
              TextInputFormatter.withFunction((oldValue, newValue) {
                // 새 값이 1에서 1000 사이의 정수인지 확인합니다.
                if (newValue.text.isEmpty) {
                  return TextEditingValue.empty;
                }
                final int? value = int.tryParse(newValue.text);
                return value != null && value >= 1 && value <= 1000
                    ? newValue
                    : oldValue;
              }),
            ],
            controller: _maxCapacityController,
            keyboardType: TextInputType.number,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Pretendard'), // 입력 텍스트의 스타일을 변경합니다.
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(width: 2.0, color: Palette.mainPurple),
                // 포커스가 있을 때의 테두리 색상을 지정합니다.
                borderRadius: BorderRadius.circular(25), // 테두리를 둥글게 만듭니다.
              ),
              hintText: '1~1000',
              hintStyle: TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  fontFamily: 'Pretendard'),

              suffixStyle:  TextStyle(fontFamily: 'Pretendard',fontSize: 10),
              suffix: Text(
                '명',),

              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15), // TextField를 둥글게 만듭니다.
              ),
            ),
            onChanged: (value) {
              // 입력이 변경될 때 호출되는 콜백 함수
              print('입력된 값: $value');
            },
          ),
        ),
        // "명" 텍스트 추가
      ],
    );
  }
}
