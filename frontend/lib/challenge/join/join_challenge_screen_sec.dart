import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/challenge/state/state_challenge_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:frontend/model/data/sms/sms_certification.dart';
import 'package:frontend/model/data/sms/sms_result.dart';
import 'package:frontend/widgets/rtu_button.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:get/get.dart';

import '../../env.dart';
import '../../model/data/challenge/challenge_join.dart';

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

  String _targetName = '';
  String _receiverNumber = '';
  String _determination = '';
  String _authInputNumber = '';
  bool _showAuthInput = false;

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
  void initState() {
    super.initState();
  }

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

  Future<Dio> _createDio() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();

    dio.options.contentType = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString('access_token')}';

    return dio;
  }

  Future<bool> _getCode() async {
    Dio dio = await _createDio();

    try {
      final response = await dio.post('${Env.serverUrl}/sms/send',
          data: SmsCertification(phone: _receiverNumber).toJson());

      if (response.statusCode == 200) {
        logger.d(response.data);
        final SmsResult smsResult = SmsResult.fromJson(response.data);
        return smsResult.isSuccess;
      }
    } catch (err) {
      logger.e('Error: $err');
      Get.snackbar('메세지 전송 실패', '다시 시도해주세요.');
    }

    return false;
  }

  Future<bool> _verifyCode() async {
    Dio dio = await _createDio();

    try {
      final response = await dio.post('${Env.serverUrl}/sms/verify',
          data: SmsCertification(
                  phone: _receiverNumber, certificationNumber: _authInputNumber)
              .toJson());

      if (response.statusCode == 200) {
        final SmsResult smsResult = SmsResult.fromJson(response.data);
        return smsResult.isSuccess;
      }
    } catch (err) {
      logger.e('Error: $err');
      Get.snackbar('인증 실패', '인증번호를 다시 확인해주세요.');
    }

    return false;
  }

  Future<void> _pressJoinButton(ChallengeJoin challengeJoin) async {
    Dio dio = await _createDio();

    try {
      final response = await dio.post(
          '${Env.serverUrl}/challenges/${widget.challenge.id}/join',
          data: challengeJoin.toJson());

      if (response.statusCode == 201) {
        logger.d('챌린지 참가 성공');
        Get.offAll(() => ChallengeStateScreen(
              isFromJoinScreen: true,
              challenge: widget.challenge,
              challengeId: widget.challenge.id,
            ));
      }
    } catch (err) {
      logger.e('Error: $err');
      Get.snackbar('챌린지 참가 실패', '다시 시도해주세요.');
    }
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
            onPressed: () {
              Get.back();
            },
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
            child: Row(children: [
              Expanded(
                child: RtuButton(
                  onPressed: () => _pressJoinButton(ChallengeJoin()),
                  text: '바로 참가하기',
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                  child: RtuButton(
                onPressed: () => _pressJoinButton(ChallengeJoin(
                    determination: _determination,
                    targetName: _targetName,
                    receiverNumber: _receiverNumber)),
                text: "번호 등록 후 참가하기",
                disabled: !isAllInput,
              )),
            ])));
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
        "ex) 친구, 어머니, ...",
        style: TextStyle(
            fontWeight: FontWeight.w500,
            fontSize: 10,
            fontFamily: 'Pretender',
            color: Palette.grey200),
      ),
      const SizedBox(height: 15),
      Container(
          padding: EdgeInsets.only(right: screenSize.width * 0.4),
          // width: screenSize.width * 0.4,
          child: TextFormField(
            maxLength: 8,
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
        "(성공을 가장 알리고 싶은 or 실패를 가장 숨기고 싶은) 사람의 전화번호",
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
                  _getCode().then((success) {
                    if (success) {
                      setState(() {
                        _showAuthInput = true;
                      });
                      Get.snackbar("인증번호 전송 성공!", "4자리 인증번호를 하단에 입력하세요.",
                          backgroundColor: Palette.greenSuccess,
                          colorText: Palette.white,
                          duration: const Duration(seconds: 1));
                    } else {
                      Get.snackbar('인증번호 전송 실패', '다시 시도해주세요.',
                          backgroundColor: Palette.red,
                          colorText: Palette.white,
                          duration: const Duration(seconds: 1));
                    }
                  });
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
    return Visibility(
        visible: _showAuthInput,
        child: Container(
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
                      fontWeight: FontWeight.w500,
                      fontSize: 10,
                      fontFamily: 'Pretender',
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
                        maxLength: 6,
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
                          filled: true,
                          fillColor: Palette.greySoft,
                          counterStyle: const TextStyle(
                              fontSize: 9,
                              color: Palette.grey200,
                              fontFamily: 'Pretendard'),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide:
                                const BorderSide(color: Palette.greySoft),
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
                          _authInputNumber = value.toString();
                        },
                        focusNode: _authFocusNode,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 10),
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () async {
                          if (await _verifyCode()) {
                            isInputList[2] = true;
                            _updateButtonState();
                            Get.snackbar("인증완료", "수신자 개인 정보 제공에 동의합니다.",
                                colorText: Palette.white,
                                backgroundColor: Palette.purPle200,
                                duration: const Duration(seconds: 1));
                          } else {
                            Get.snackbar("인증실패", "인증번호를 다시 확인해주세요.",
                                colorText: Palette.white,
                                backgroundColor: Palette.red,
                                duration: const Duration(seconds: 1));
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
            )));
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
