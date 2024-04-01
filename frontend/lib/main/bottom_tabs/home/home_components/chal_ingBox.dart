import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';

class ChallengeIngBox extends StatefulWidget {
  const ChallengeIngBox({super.key});

  @override
  State<ChallengeIngBox> createState() => _ChallengeIngBoxState();
}

class _ChallengeIngBoxState extends State<ChallengeIngBox> {
  String name = "신혜은";
  String category = "운동";

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PupleBox(),
    );
  }

  Widget PupleBox() {
    return Container(
      color: Palette.mainPurple,
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Text(
                "$name 님 오늘은 $category 관련 \n챌린지를 도전해 볼까요?",
                // overflow: TextOverflow.visible,
                // maxLines: null,
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 15),
              ElevatedButton(
                onPressed: () {},
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12))),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Palette.white),
                ),
                child: Text(
                  "챌린지 보러가기",
                  style: TextStyle(
                      color: Palette.mainPurple,
                      fontSize: 10,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 50),
            ],
          ),
          SizedBox(width: 20),
          Icon(
            Icons.ice_skating,
            color: Colors.white,
            size: 90,
          )
        ],
      ),
    );
  }

  Widget AuthBox() {
    return Container(
        padding: EdgeInsets.symmetric(vertical: 15, horizontal: 10),
        child: Card(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
          color: Palette.white,
          child: Column(
            children: [
              Text(
                "내 챌린지 현황 >",
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 21),
              ),
              Text(
                "챌린지를 진행하고 인증을 완료해 주세요!",
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w100,
                    fontSize: 12),
              )
            ],
          ),
        ));
  }


  Widget AuthList() {

    return Card();
  }
}
