import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper_view/flutter_swiper_view.dart';
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
    return Stack(
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
    );
  }

  Widget PupleBox() {
    return Container(
      color: Palette.mainPurple,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "$name 님 오늘은 $category 관련 챌린지를 도전해 볼까요?",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 15,
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 15),
                ElevatedButton(
                  onPressed: () {},
                  style: ButtonStyle(
                    shape: MaterialStateProperty.all<OutlinedBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Palette.white),
                  ),
                  child: const Text(
                    "챌린지 보러가기",
                    style: TextStyle(
                      color: Palette.mainPurple,
                      fontSize: 13,
                      fontFamily: 'Pretendard',
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const SizedBox(height: 50),
              ],
            ),
          ),
          const SizedBox(width: 20),
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
      padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: Palette.white,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                "내 챌린지 현황 >",
                style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
              const Text(
                "챌린지를 진행하고 인증을 완료해 주세요!",
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.w500,
                    fontSize: 11,
                    color: Colors.grey),
              ),
              const SizedBox(height: 10),
              Container(
                  width: double.infinity,
                  height: 70,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Swiper(
                    itemBuilder: (BuildContext context, int index) {
                      return AuthList()[index];
                    },
                    pagination:
                        const SwiperPagination(margin: EdgeInsets.all(1)),
                    itemCount: AuthList().length,
                  ))
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
      return Card(
        color: const Color(0xFFF1F1F1),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const SizedBox(width: 8),
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: Image.asset(
                challenge['image'], // 이미지 경로
                width: 40, // 이미지 너비
                height: 40, // 이미지 높이
              ),
            ),
            const SizedBox(width: 8),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Expanded(
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          challenge['name'], // 챌린지 이름
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                          fontSize:10),

                        ),
                        Text(
                          '${challenge['percent']}%',
                          style: TextStyle(fontSize :12)// 진행 상태
                        )
                      ]),
                )
              ],
            ),
            GestureDetector(
              onTap: () {
                // 버튼을 눌렀을 때 실행할 동작
                print('Button pressed');
              },
              child: SizedBox(
                width: 50, // 버튼의 너비
                height: 50, // 버튼의 높이
                child: SvgPicture.asset(
                  'assets/buttons/auth_mini_btn.svg', // SVG 파일의 경로
                  width: 50, // SVG 이미지의 너비
                  height: 50, // SVG 이미지의 높이
                ),
              ),
            )
          ],
        ),
      );
    }).toList();
  }
}
