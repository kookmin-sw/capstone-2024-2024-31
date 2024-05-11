import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/create/widgets/create_body_part1.dart';
import 'package:frontend/challenge/create/widgets/create_body_part2.dart';
import 'package:frontend/challenge/create/widgets/create_body_part3.dart';
import 'package:frontend/challenge/create/create_challenge_screen_sec.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge.dart';

class CreateChallengeFir extends StatefulWidget {
  const CreateChallengeFir({Key? key});

  @override
  State<CreateChallengeFir> createState() => _CreateChallengeFirState();
}

class _CreateChallengeFirState extends State<CreateChallengeFir> {
  late Challenge newChallenge = Challenge(
      isPrivate: false,
      privateCode: '',
      challengeName: '',
      challengeExplanation: '',
      challengePeriod: '',
      startDate: '',
      certificationFrequency: '',
      certificationStartTime: 88,
      certificationEndTime: '',
      certificationExplanation: '',
      isGalleryPossible: false,
      maximumPeople: 0,
      participants: []);

  bool? isPrivateSelected;

  bool showAdditionalWidgets =
      false; // Added state to control the visibility of additional widgets


  late String privateCode = '';
  bool showCodeInput = false; // 코드 입력 창 보여주기 여부
  late FocusNode _focusNode; // 텍스트 필드의 포커스를 제어하기 위한 FocusNode

  @override
  void initState() {
    super.initState();
    _focusNode = FocusNode(); // FocusNode 초기화
  }

  @override
  void dispose() {
    _focusNode.dispose(); // FocusNode 해제
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {},
          ),
          title: const Text(
            '챌린지 생성하기',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pretender',
            ),
          ),
        ),
        bottomNavigationBar: Container(
          padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
          color: Colors.transparent,
          width: double.infinity,
          child: InkWell(
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => CreateChallengeSec(challenge: newChallenge),
                ),
              );
            },
            child: SvgPicture.asset(
              'assets/svgs/create_challenge_next_btn.svg',
              // width: double.infinity,
              // height: 30,
            ),
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: SvgPicture.asset('assets/svgs/create_challenge_level1.svg'),
              ),
              disclosureButton(
                "public",
                "공개",
                "원하는 사람은 누구든지 참여할 수 있어요.",
                Icons.lock_open_rounded,
              ),
              disclosureButton(
                "private",
                "비공개",
                "암호를 아는 사람만 참여할 수 있어요.",
                Icons.lock_outline_rounded,
              ),
              if (showCodeInput) ...[
                // Show additional widgets when '비공개' button is selected
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          focusNode: _focusNode,
                          onChanged: (value) {
                            privateCode =
                                value; // TextField에 입력된 값을 privateCode 변수에 저장
                          },
                          decoration: const InputDecoration(
                            labelText: '암호',
                            labelStyle: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Pretendard'),
                            hintText: '루티너 간 공유할 암호를 입력하세요',
                            hintStyle: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.w200,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      // Add spacing between text field and button
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            print('입력된 암호: $privateCode');
                            FocusScope.of(context).unfocus(); // 포커스 해제

                          });
                        },
                        style: ElevatedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15))),
                        child: const Text(
                          '확인',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Palette.mainPurple),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ));
  }
  void onPrivateButtonPressed (bool isPrivate, String _privateCode) {
          setState(() {
            isPrivateSelected = isPrivate;
            newChallenge.isPrivate = isPrivate;
            if (isPrivate) {
              newChallenge.privateCode = _privateCode;
            } else {
              newChallenge.privateCode = "";
            }
          });}

  Widget disclosureButton(
      String isOpened,
      String title,
      String memo,
      IconData iconData,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
      height: 120,
      child: ElevatedButton.icon(
        onPressed: () {
          bool isPrivate = isOpened == "private";
          bool showWidgets = isOpened == "private";
          onPrivateButtonPressed(isPrivate, privateCode);
          if (showWidgets) {
            setState(() {
              showCodeInput = true; // 코드 입력 창 표시
            });
          }else{
            setState(() {
              showCodeInput = false; // 코드 입력 창 표시
            });
          }
        },
        icon: Icon(
          iconData,
          size: 40,
          color: isPrivateSelected == (isOpened == "private")
              ? Palette.mainPurple
              : Colors.black,
        ),
        label: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$title 챌린지",
                    style: TextStyle(
                      color: isPrivateSelected == (isOpened == "private")
                          ? Palette.mainPurple
                          : Colors.black,
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    memo,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Palette.mainPurple,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
