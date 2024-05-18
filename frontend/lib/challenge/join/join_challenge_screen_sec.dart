import 'package:dio/dio.dart' as dio;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/state/state_challenge_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../env.dart';
import '../../model/controller/challenge_form_controller.dart';

class JoinChallengeSecScreen extends StatefulWidget {
  final Challenge challenge;

  const JoinChallengeSecScreen({super.key, required this.challenge});

  @override
  State<JoinChallengeSecScreen> createState() => _JoinChallengeSecScreenState();
}

class _JoinChallengeSecScreenState extends State<JoinChallengeSecScreen> {
  bool isLoading = false;
  bool isAllInput = false;
  List<bool> isInputList = [false, false, false, false];

  late String _targetName;
  late String _receiverNumber;
  String authNumber = '1010';
  late String authInputNumber = '';
  late String _determination;

  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _numberFocusNode = FocusNode();
  final FocusNode _authFocusNode = FocusNode();
  final FocusNode _resultFocusNode = FocusNode();

  // 나머지 코드는 유지됩니다.
  final GlobalKey<FormState> _formKey =
      GlobalKey<FormState>(); // Add a GlobalKey for the form
  final logger = Logger();
  final UserController user = UserController();

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

  Future<bool> _postJoinData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    dio.Dio dioInstance = dio.Dio();

    dioInstance.options.contentType = 'application/json';
    dioInstance.options.headers['Authorization'] =
        'Bearer ${prefs.getString('access_token')}';

    try {
      final response = await dioInstance.post(
        '${Env.serverUrl}/challenges/${widget.challenge.id}/join',
        data: {
          "targetName": _targetName,
          "receiverNumber": _receiverNumber,
          "determination": _determination,
        },
      );

      if (response.statusCode == 200) {
        logger.d('Response status code: ${response.statusCode}');
        logger.d('Response data: ${response.data}');
        logger.d('Request options: ${response.requestOptions}');
        return true;
      } else if (response.statusCode == 404) {
        logger.e('Response status code: ${response.statusCode}');
        logger.e('Response data: ${response.data}');
        logger.e('Request options: ${response.requestOptions}');
      } else {
        logger.e('Response status code: ${response.statusCode}');
        logger.e('Response data: ${response.data}');
        logger.e('Request options: ${response.requestOptions}');
      }
    } on dio.DioError catch (e) {
      logger.e('DioError: ${e.message}');
      if (e.response != null) {
        logger.e('Response status code: ${e.response?.statusCode}');
        logger.e('Response data: ${e.response?.data}');
        logger.e('Request options: ${e.response?.requestOptions}');
      } else {
        logger.e('Error sending request: ${e.requestOptions}');
      }
      return Future.error(e.toString());
    } catch (err) {
      return Future.error(err.toString());
    }

    return false;
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      // 배경색 설정
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
            fontFamily: 'Pretender',
          ),
        ),
      ),
      body: GestureDetector(
          onTap: () {
            // 다른 곳을 탭하면 포커스 해제
            FocusScope.of(context).unfocus();
          },
          child: isLoading
              ? const Center(
                  child: CircularProgressIndicator(color: Palette.mainPurple),
                )
              : SingleChildScrollView(
                  child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Form(
                        key: _formKey, // Add the form key here
                        child: Column(
                          children: [
                            const SizedBox(height: 15),
                            const Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 10),
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
                      )),
                )),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 20),
        color: Colors.transparent,
        width: double.infinity,
        child: isAllInput
            ? InkWell(
                onTap: () {
                  setState(() {
                    isLoading = true;
                  });
                  _postJoinData().then((value) {
                    setState(() {
                      isLoading = false;
                    });

                    if (value) {
                      Get.offAll(() => ChallengeStateScreen(isFromJoinScreen: true, challenge: widget.challenge));
                    }
                  }).catchError((err) {
                    setState(() {
                      isLoading = false;
                    });
                    Get.snackbar(
                      "오류",
                      "이미 챌린지에 가입되어 있습니다.",
                      backgroundColor: Colors.red,
                      colorText: Colors.white,
                    );
                  });
                },
                child: SvgPicture.asset(
                  'assets/svgs/join_able_btn.svg',
                ))
            : SvgPicture.asset(
                'assets/svgs/join_disable_btn.svg',
              ),
      ),
    );
  }

  Widget inputPenaltyName(Size screenSize) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "결과를 수신할 분의 이름을 입력해주세요",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Pretendard',
            color: Palette.grey300),
      ),
      const Text(
        "ex) 울 자기, 신혠, 지영이어머니",
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
                fontFamily: 'Pretender'),
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
                return '이름을 입력하세요.';
              }
              return null;
            },
            onChanged: (value) {
              _targetName = value.toString();
              isInputList[0] = true;
              _updateButtonState();
              print(isInputList);
            },
            focusNode: _nameFocusNode,
          )),
    ]);
  }

  Widget inputPenaltyNumber(Size screenSize) {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      const Text(
        "전화번호 입력해주세요.",
        style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            fontFamily: 'Pretender',
            color: Palette.grey300),
      ),
      const Text(
        "(성공을 가장 알리고 싶은 or 실패를 가장 숨기고 싶은)",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            fontFamily: 'Pretender',
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
                LengthLimitingTextInputFormatter(11),
                // Limit to 11 characters
              ],
              // 키보드 타입을 전화번호로 설정합니다.
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
                      borderSide: const BorderSide(
                          color: Palette.mainPurple, width: 2))),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return '휴대폰 번호를 입력하세요.';
                }
                return null;
              },
              onChanged: (value) {
                _receiverNumber = value.toString();
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
                  Get.snackbar(
                    "인증번호",
                    "4자리 인증번호를 하단에 입력하세요.",
                    backgroundColor: Palette.softPurPle,
                      duration: const Duration(seconds: 1));
                },
                child: SvgPicture.asset(
                  'assets/svgs/number_auth_btn.svg',
                  // width: double.infinity,
                  // height: 30,
                ),
              ),
            )
          ])
    ]);
  }

  Widget verificationInput(Size screenSize) {
    return Container(
        // margin: EdgeInsets.only(left: 20, right: 20),
        // padding: EdgeInsets.only(left: 30),
        decoration: BoxDecoration(
            // border: Palette.greySoft, // 배경색 설정
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 5),
            const Text(
              "인증번호",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                fontFamily: 'Pretendard',
                color: Palette.grey300,
              ),
            ),
            const SizedBox(height: 3),
            const Text(
              "완료시, 본 전화번호 소유자 개인정보 수집에 동의합니다.",
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 9,
                  fontFamily: 'Pretendard',
                  color: Palette.grey200),
            ),
            const SizedBox(height: 10),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                      contentPadding: const EdgeInsets.symmetric(
                          vertical: 0, horizontal: 10),
                      filled: true,
                      fillColor: Palette.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Palette.greySoft),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(
                            color: Palette.mainPurple, width: 2),
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
                      if (authNumber == authInputNumber) {
                        isInputList[2] = true;
                        _updateButtonState();
                        Get.snackbar("인증완료", "수신자 개인 정보 제공에 동의합니다.",
                            colorText: Palette.white,
                            backgroundColor: Palette.purPle200, duration: const Duration(seconds: 1));
                      }
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
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
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
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 12),
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
              _determination = value.toString();
              isInputList[3] = true;
              _updateButtonState();
            },
            focusNode: _resultFocusNode,
          )),
    ]);
  }
}
