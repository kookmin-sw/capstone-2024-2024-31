import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/detail/detail_challenge_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';
import 'dart:io';

class ChallengeItemCard extends StatelessWidget {
  final Challenge this_challenge;

  ChallengeItemCard({required this.this_challenge});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    // 문자열을 DateTime 객체로 파싱
    DateTime date = DateTime.parse(this_challenge.startDate);

    // 날짜 형식 변경
    String modifiedString = '${date.month}월 ${date.day}일부터 시작';

    return GestureDetector(
        onTap: () {
          print("${this_challenge.challengeName} 챌린지 클릭됨");
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ChallengeDetailScreen()),
          );
        },
        child: Container(
            width: screenSize.width * 0.45,
            height: screenSize.height * 0.6,
            child: Card(
                color: Colors.transparent,
                elevation: 0,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  side: BorderSide.none,
                ),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      challenge_image(screenSize),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        child: Text(
                          "${this_challenge.challengeName}",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: Palette.grey500,
                            fontSize: 14,
                            fontFamily: 'Pretendard',
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svgs/icon_time.svg",
                              width: 16,
                              color: Palette.grey200,
                            ),
                            SizedBox(width: 5),
                            Text(
                              modifiedString,
                              style: TextStyle(
                                  color: Palette.grey200,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Pretendard'),
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          children: [
                            SvgPicture.asset(
                              "assets/svgs/detail_user_icon.svg",
                              width: 16,
                              color: Palette.purPle400,
                            ),
                            SizedBox(width: 5),
                            Text(
                              '${this_challenge.participants.length}명의 루티너',
                              style: TextStyle(
                                  color: Palette.purPle400,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w400,
                                  fontFamily: 'Pretendard'),
                            ),
                          ],
                        ),
                      )
                    ]))));
  }

  Widget challenge_image(Size screenSize) {
    return Container(
        child: Stack(
      alignment: Alignment.bottomCenter,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.asset(
            'assets/images/image.png', // 이미지 경로
            fit: BoxFit.cover,
            width: screenSize.width * 0.45,
            height: screenSize.width * 0.45 * (3 / 4),
          ),
        ),
        Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              width: screenSize.width * 0.45,
              padding: EdgeInsets.symmetric(vertical: 5),
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                // 투명도 조절 가능한 검은색 배경
                borderRadius: BorderRadius.vertical(
                  top: Radius.circular(0), // 상단 모서리는 안둥글게
                  bottom: Radius.circular(10), // 하단 모서리만 둥글게
                ),
              ),
              child: Text(
                "${this_challenge.certificationFrequency} | ${this_challenge.challengePeriod} 간",
                textAlign: TextAlign.center,
                style: TextStyle(
                    color: Colors.white,
                    fontSize: 10,
                    fontWeight: FontWeight.w400),
              ),
            ))
      ],
    ));
  }
}
