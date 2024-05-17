import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';

class CertificationMethod extends StatelessWidget {
  final Challenge challenge;

  const CertificationMethod({super.key, required this.challenge});

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  decoration: BoxDecoration(
                      color: const Color(0xFFF5F5F5), // 배경색 설정
                      borderRadius: BorderRadius.circular(10)),
                  // 컨테이너를 둥글게 만듭니다.
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text("인증 가능 시간",
                                style: TextStyle(
                                    color: Palette.grey200,
                                    fontSize: 10,
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w500)),
                            Text(
                                "${challenge.certificationStartTime}시 - ${challenge.certificationEndTime}",
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
                            const Text("인증 횟수",
                                style: TextStyle(
                                    color: Palette.grey200,
                                    fontSize: 10,
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w500)),
                            Text(challenge.certificationFrequency!,
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
                            const Text("수단",
                                style: TextStyle(
                                    color: Palette.grey200,
                                    fontSize: 10,
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w500)),
                            Text(
                                challenge.isGalleryPossible! ? "카메라+갤러리" : "카메라",
                                style: const TextStyle(
                                    color: Palette.grey300,
                                    fontSize: 10,
                                    fontFamily: "Pretendard",
                                    fontWeight: FontWeight.w700))
                          ],
                        )
                      ])),
              const SizedBox(height: 10),
            ]));
  }
}
