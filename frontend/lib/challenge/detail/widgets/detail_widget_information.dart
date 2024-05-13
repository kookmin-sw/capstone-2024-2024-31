import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';
import 'package:intl/intl.dart';

class InformationWidget extends StatelessWidget {
  final Challenge challenge;

  const InformationWidget({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    final DateTime startDate = challenge.startDate;
    final int challengePeriod = challenge.challengePeriod;
    final DateTime endDate = startDate.add(Duration(days: challengePeriod * 7));

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 5),
          Row(
            children: [
              Container(
                width: 20,
                height: 20,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.blue, // 동그라미의 배경색
                ),
                child: Image.asset(
                  'assets/images/24.png', // 동그라미 이미지의 경로
                  fit: BoxFit.cover, // 이미지가 동그라미 안에 맞도록 설정
                ),
              ),
              const SizedBox(width: 5),
              const Text(
                "루틴업",
                style: TextStyle(
                    fontSize: 12,
                    fontFamily: "Pretendard",
                    color: Palette.grey300,
                    fontWeight: FontWeight.w600),
              )
            ],
          ),
          const SizedBox(height: 3),
          Text(challenge.challengeName,
              style: const TextStyle(
                  fontSize: 20,
                  fontFamily: "Pretendard",
                  fontWeight: FontWeight.w700,
                  color: Palette.grey500)),
          const SizedBox(height: 3),
          Row(children: [
            Container(
              width: 20,
              height: 20,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: SvgPicture.asset(
                'assets/svgs/detail_user_icon.svg',
                fit: BoxFit.cover,
                // 이미지가 동그라미 안에 맞도록 설정
              ),
            ),
            const SizedBox(width: 5),
            Text("${challenge.totalParticipants}명의 루티너가 참여중",
                style: const TextStyle(
                    color: Palette.purPle200,
                    fontSize: 10,
                    fontFamily: "Pretendard",
                    fontWeight: FontWeight.w500))
          ]),
          const SizedBox(height: 8),
          Container(
              padding: EdgeInsets.symmetric(vertical: 10, horizontal: 15),
              decoration: BoxDecoration(
                  color: Color(0xFFF5F5F5), // 배경색 설정
                  borderRadius: BorderRadius.circular(10)), // 컨테이너를 둥글게 만듭니다.
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("기간",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(
                            "${DateFormat("M월 d일 (E)", "ko_KR").format(startDate)}-${DateFormat("M월 d일 (E)", "ko_KR").format(endDate)} ${challenge.challengePeriod}",
                            style: const TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("시작일",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text(
                            "${DateFormat("yyyy년 M월 d일 (E)", "ko_KR").format(startDate)}",
                            style: const TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    ),
                    const SizedBox(height: 3),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text("인증 빈도",
                            style: TextStyle(
                                color: Palette.grey200,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w500)),
                        Text("${challenge.certificationFrequency}",
                            style: const TextStyle(
                                color: Palette.grey300,
                                fontSize: 10,
                                fontFamily: "Pretendard",
                                fontWeight: FontWeight.w700))
                      ],
                    )
                  ]))
        ]);
  }
}
