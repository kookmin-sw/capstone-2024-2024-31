import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class BodyPart3 extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _BodyPart3State();
}

class _BodyPart3State extends State<BodyPart3> {
  final picker = ImagePicker();
  XFile? successFile;
  XFile? failFile;

  Future<void> _pickImage(bool isSuccess) async {
    final pickedImage = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      setState(() {
        if (isSuccess) {
          successFile = XFile(pickedImage.path);
        } else {
          failFile = XFile(pickedImage.path);
        }
      });
    }
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
              child: Text(
                '인증 방법 및 예시',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
            ),
            inputAuthIntro(),
            pickAuthMethod(),
            addPicture(),
          ],
        ),
      ),
    );
  }

  Widget inputAuthIntro() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Column(
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
      ),
    );
  }

  Widget pickAuthMethod() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 5, horizontal: 25),
      child: Column(
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
            isSelected: [true, false],
            onPressed: (int index) {},
            children: [
              Container(
                padding: EdgeInsets.symmetric(vertical: 12),
                height: 50,
                width: 130,
                child: Text(
                  '카메라',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Palette.mainPurple,
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
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Palette.grey300,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
  Widget addPicture() {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
      ),
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
              borderRadius: BorderRadius.circular(30.0),
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
              Icon(isSuccess ? Icons.check_box_rounded : Icons.delete_outline_rounded, color: color),
              SizedBox(width: 5),
              Text(isSuccess ? "성공 예시" : "실패 예시"),
            ],
          ),
        ],
      ),
    );
  }

}
