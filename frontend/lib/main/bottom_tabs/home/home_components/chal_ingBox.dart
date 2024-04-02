import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChallengeIngBox extends StatefulWidget {
  const ChallengeIngBox({Key? key}) : super(key: key);

  @override
  State<ChallengeIngBox> createState() => _ChallengeIngBoxState();
}

class _ChallengeIngBoxState extends State<ChallengeIngBox> {
  String name = "신혜은";
  String category = "운동";
  late PageController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = PageController(); // Initialize _scrollController
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Dispose _scrollController
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Stack(
        clipBehavior: Clip.none,
        children: [
          PupleBox(),
          Positioned(
            top: 135, // 위젯이 겹치는 위치 설정
            left: 0,
            right: 0,
            child: AuthBox(),
          ),
        ],
      ),
    );
  }

  Widget PupleBox() {
    return Container(
      color: Palette.mainPurple,
      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "$name 님 오늘은 $category 관련 \n챌린지를 도전해 볼까요?",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 17,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor: MaterialStateProperty.all<Color>(Palette.white),
                  ),
                  child: Text(
                    "챌린지 보러가기",
                    style: TextStyle(
                      color: Palette.mainPurple,
                      fontSize: 16,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 50),
              ],
            ),
          ),
          SizedBox(width: 20),
          SvgPicture.asset(
            'assets/icons/category_icons/exercise.svg',
            width: 90, // 조절할 아이콘의 너비
            height: 90, // 조절할 아이콘의 높이
            color: Colors.white,
          ),
        ],
      ),
    );
  }

  Widget AuthBox() {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Palette.white,
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "내 챌린지 현황 >",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: 21,
                ),
              ),
              Text(
                "챌린지를 진행하고 인증을 완료해 주세요!",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.w500,
                  fontSize: 12,
                  color: Colors.grey
                ),
              ),
              SizedBox(height: 10),
              Container(
                width: double.infinity,
                height: 75,
                child: PageView(
                  controller: _scrollController,
                  pageSnapping: true,
                  scrollDirection: Axis.horizontal,
                  children: AuthList(),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> AuthList() {
    List<Map<String, dynamic>> challengeList = [
      {'name': '매일 커밋하기', 'percent': '50', 'image': 'assets/images/image.png'},
      {'name': '매일 운동하기', 'percent': '10', 'image': 'assets/images/image.png'},
      {'name': '매일 먹기', 'percent': '30', 'image': 'assets/images/image.png'},
    ];

    return challengeList.map((challenge) {
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        width: 300,
        height: 100,
        child: Card(
          color: Color(0xFFF1F1F1),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.asset(
                  challenge['image'], // 이미지 경로
                  width: 40, // 이미지 너비
                  height: 40, // 이미지 높이
                ),
              ),
              SizedBox(width: 8),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(children: [
                    Text(
                      challenge['name'], // 챌린지 이름
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '${challenge['percent']}%', // 진행 상태
                    )
                  ]),
                ],
              ),
              Image.asset(
                'assets/images/Rectangle177.png',
                height: 40,
                width: 5,
              ),
              IconButton(
                onPressed: () {
                  print("인증버튼");
                  // 버튼을 눌렀을 때 실행할 작업
                },
                icon: Image.asset(
                  'assets/buttons/auth_small_active.png', // 이미지 경로
                  width: 40, // 이미지 너비
                  height: 40, // 이미지 높이
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }
}

