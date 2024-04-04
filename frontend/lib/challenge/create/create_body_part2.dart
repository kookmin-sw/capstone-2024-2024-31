import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/model/config/palette.dart';

class BodyPart2 extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SvgPicture.asset('assets/svgs/create_challenge_level2.svg'),
          ),
          inputName()
        ]));
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
              height: 50,
              child: TextFormField(
                decoration: InputDecoration(
                    hintText: "챌린지 이름을 입력해주세요.",
                    hintStyle: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w300,
                      color: Palette.grey200,
                    ),
                    contentPadding:  EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    filled: true,
                    fillColor: Palette.greySoft,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(15.0),
                        borderSide: BorderSide(color: Palette.greySoft)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
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
// Widget inputIntro(){}
// Widget addPicture(){}
// Widget selectWeekend(){}
// Widget selectStartDay(){}
}
