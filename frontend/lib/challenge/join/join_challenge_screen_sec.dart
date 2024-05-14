import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/state/state_challenge_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';

class JoinChallengeSecScreen extends StatefulWidget {
  final Challenge challenge = Challenge.getDummyData();

  JoinChallengeSecScreen({super.key});

  @override
  State<JoinChallengeSecScreen> createState() => _JoinChallengeSecScreenState();
}

class _JoinChallengeSecScreenState extends State<JoinChallengeSecScreen> {
  bool isAllInput = false;
  List<bool> isInputList = [false, false, false, false];

  late String receiverName;
  late String receiverNumber;
  String authNumber = '1010';
  late String authInputNumber = '';
  late String toReceiverText;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();
  final FocusNode _authFocusNode = FocusNode();
  final FocusNode _resultFocusNode = FocusNode();

  // 나머지 코드는 유지됩니다.

  @override
  void dispose() {
    // FocusNode 해제
    _nameFocusNode.dispose();
    _numberFocusNode.dispose();
    _authFocusNode.dispose();
    _resultFocusNode.dispose();
    super.dispose();
  }

  void _updateButtonState() {
    setState(() {
      // Check if all input fields are filled
      if (validateInput()) {
        // All input fields are filled
        isAllInput = true;
      } else {
        // At least one input field is not filled
        isAllInput = false;
      }
    });
  }

  bool validateInput() {
    // Check if all input fields are filled
    return isInputList.every((element) => element);
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white, // 배경색 설정
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {},
        ),
        title: const Text(
          '루틴업 참가하기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard',
          ),
        ),
      ),
      body: GestureDetector(
          onTap: () {
            // 다른 곳을 탭하면 포커스 해제
            FocusScope.of(context).unfocus();
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  const SizedBox(height: 15),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                    child: Text(
                      "\"결과를 누구에게 전송할까요?\"",
                      style: TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 15,
                        fontFamily: 'Pretendard',
                        color: Palette.grey500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  inputPenaltyName(screenSize),
                  const SizedBox(height: 15),
                  inputPenaltyNumber(screenSize),
                  const SizedBox(height: 5),
                  verificationInput(screenSize),
                  const SizedBox(height: 25),
                  inputResultText(screenSize),
                  const SizedBox(height: 10),
                ],
              ),
            ),
          )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        color: Colors.transparent,
        width: double.infinity,
        child: isAllInput
            ? InkWell(
                onTap: () {
                  Navigator.of(context).popUntil((route) => route.isFirst);
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => ChallengeStateScreen(),
                    ),
                  );
                },
                child: SvgPicture.asset(
                  'assets/svgs/join_able_btn.svg',
                ),
              )
            : SvgPicture.asset(
                'assets/svgs/join_disable_btn.svg',
              ),
      ),
    );
  }

  Widget inputPenaltyName(Size screenSize) {
    return Form(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "이름을 입력해주세요",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Pretendard',
            color: Palette.grey300),
      ),
      const Text(
        "ex) 부모님, 친구, 연인",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 11,
            fontFamily: 'Pretendard',
            color: Palette.grey200),
      ),
      const SizedBox(height: 15),
      Container(
          padding: EdgeInsets.only(right: screenSize.width * 0.4),
          // width: screenSize.width * 0.4,
          child: TextFormField(
            maxLength: 5,
            keyboardType: TextInputType.name,
            style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
                fontFamily: 'Pretendard'),
            decoration: InputDecoration(
                hintText: "김혁주",
                hintStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Palette.grey200,
                ),
                counterStyle: const TextStyle(
                    fontSize: 9,
                    color: Palette.grey200,
                    fontFamily: 'Pretendard'),
                contentPadding:
                    EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                filled: true,
                fillColor: Palette.greySoft,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Palette.greySoft)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Palette.mainPurple, width: 2))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '이름을 입력하세요.';
              }
              return null;
            },
            onChanged: (value) {
              receiverName = value.toString();
              isInputList[0] = true;
              _updateButtonState();
              print(isInputList);
            },
            focusNode: _nameFocusNode,
          )),
    ]));
  }

  Widget inputPenaltyNumber(Size screenSize) {
    return Form(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "전화번호 입력해주세요.",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Pretendard',
            color: Palette.grey300),
      ),
      const Text(
        "(성공을 가장 알리고 싶은 or 실패를 가장 숨기고 싶은)",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            fontFamily: 'Pretendard',
            color: Palette.grey200),
      ),
      const SizedBox(height: 15),
      Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
                child: TextFormField(
              maxLength: 11,
              // 휴대폰 번호는 보통 11자리입니다.
                  keyboardType: TextInputType.phone,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(11), // Limit to 11 characters
                  ],              // 키보드 타입을 전화번호로 설정합니다.
              style: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 11,
                  fontFamily: 'Pretendard'),
              decoration: InputDecoration(
                  hintText: "01012345678",
                  // 예시 번호를 힌트로 표시합니다.
                  hintStyle: const TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w300,
                    color: Palette.grey200,
                  ),
                  counterStyle: const TextStyle(
                      fontSize: 9,
                      color: Palette.grey200,
                      fontFamily: 'Pretendard'),
                  contentPadding:
                      const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                  filled: true,
                  fillColor: Palette.greySoft,
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide: const BorderSide(color: Palette.greySoft)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Palette.mainPurple, width: 2))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '휴대폰 번호를 입력하세요.';
                }
                return null;
              },
              onChanged: (value) {
                receiverNumber = value.toString();
                isInputList[1] = true;
                _updateButtonState();
              },
              focusNode: _numberFocusNode,
            )),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  setState(() {});
                },
                child: SvgPicture.asset(
                  'assets/svgs/number_auth_btn.svg',
                  // width: double.infinity,
                  // height: 30,
                ),
              ),
            )
          ])
    ]));
  }

  Widget verificationInput(Size screenSize) {
    return Container(
        // margin: EdgeInsets.only(left: 20, right: 20),
        // padding: EdgeInsets.only(left: 30),
        decoration: BoxDecoration(
            // border: Palette.greySoft, // 배경색 설정
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SvgPicture.asset("assets/svgs/horizonal_bar.svg"),
                const Text(
                  "인증번호",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    fontFamily: 'Pretendard',
                    color: Palette.grey300,
                  ),
                ),
                SvgPicture.asset("assets/svgs/horizonal_bar.svg"),
              ],
            ),
            SizedBox(height: 3),
            const Text(
              "완료시, 본 전화번호 소유자 개인정보 수집에 동의합니다.",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                  fontFamily: 'Pretendard',
                  color: Palette.grey200),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: screenSize.width * 0.4,
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    style: const TextStyle(
                      fontWeight: FontWeight.w300,
                      fontSize: 11,
                      fontFamily: 'Pretendard',
                    ),
                    decoration: InputDecoration(
                      hintText: "4자리 입력",
                      hintStyle: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w300,
                        color: Palette.grey200,
                      ),
                      contentPadding:
                          const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                      filled: true,
                      fillColor: Palette.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Palette.greySoft),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide:
                            const BorderSide(color: Palette.mainPurple, width: 2),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return '인증번호를 입력하세요.';
                      }
                      return null;
                    },
                    onChanged: (value) {
                      authInputNumber = value.toString();
                      if (authNumber == authInputNumber) {
                        isInputList[2] = true;
                        _updateButtonState();
                      }
                    },
                    focusNode: _authFocusNode,
                  ),
                ),
                const SizedBox(width: 10),
                Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {});
                    },
                    child: SvgPicture.asset(
                      'assets/svgs/auth_check_btn.svg',
                      // width: double.infinity,
                      // height: 30,
                    ),
                  ),
                )
              ],
            ),
          ],
        ));
  }

  Widget inputResultText(Size screenSize) {
    return Form(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "각오 한마디를 입력해주세요",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Pretendard',
            color: Palette.grey300),
      ),
      const Text(
        "성공/실패 시 결과와 함께 전송돼요.",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 11,
            fontFamily: 'Pretendard',
            color: Palette.grey200),
      ),
      const SizedBox(height: 15),
      Container(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: TextFormField(
            maxLength: 50,
            maxLines: 3,
            keyboardType: TextInputType.text,
            style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
                fontFamily: 'Pretendard'),
            decoration: InputDecoration(
                hintText: "ex) 나 실패하면 ㅋ 공차 사줄게 ㅋ\n\t   나의 갓생을 응원해줘~ 반드시 성공할거야~",
                hintStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Palette.grey200,
                ),
                counterStyle: const TextStyle(
                    fontSize: 9,
                    color: Palette.grey200,
                    fontFamily: 'Pretendard'),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                filled: true,
                fillColor: Palette.greySoft,
                enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(color: Palette.greySoft)),
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide:
                        const BorderSide(color: Palette.mainPurple, width: 2))),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return '각오 한마디를 입력하세요.';
              }
              return null;
            },
            onChanged: (value) {
              toReceiverText = value.toString();
              isInputList[3] = true;
              _updateButtonState();
            },
            focusNode: _resultFocusNode,
          )),
    ]));
  }
}
