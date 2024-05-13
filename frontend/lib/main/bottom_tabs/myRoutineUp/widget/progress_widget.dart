import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';

class ChallengeProgressWidget extends StatelessWidget {
  final List<int> challengeProgressNumberList; //0: 진행전 1: 진행중 2: 진행완료
  const ChallengeProgressWidget(
      {super.key, required this.challengeProgressNumberList});

  @override
  Widget build(BuildContext context) {
    List<String> progressLabelText = ['진행 전', '진행 중', '진행 완료'];

    return Container(
        margin: const EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            border: Border.all(
              color: Palette.greyBG,
              width: 3
            ),
            borderRadius: BorderRadius.circular(15),
            color: Palette.white),
        child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                List.generate(challengeProgressNumberList.length, (index) {

              return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 45,
                          width: 45,
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Palette.mainPurple,
                              width: 3
                            ),
                            shape: BoxShape.circle,
                            color: Palette.white,
                          ),
                          child: Text(
                            challengeProgressNumberList[index].toString(),
                            style: const TextStyle(
                                color: Palette.grey300,
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                fontFamily: 'Pretender'),
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          progressLabelText[index],
                          style: const TextStyle(
                              color: Palette.grey300,
                              fontSize: 11,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Pretender'),
                        )
                      ]));
            })));
  }
}
