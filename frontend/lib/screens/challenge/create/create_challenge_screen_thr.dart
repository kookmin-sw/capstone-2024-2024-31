import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/challenge_form_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:frontend/widgets/rtu_button.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/services.dart';
import 'package:logger/logger.dart';
import 'package:frontend/screens/challenge/create/create_challenge_screen_complete.dart';

class CreateChallengeThr extends StatefulWidget {
  const CreateChallengeThr({super.key});

  @override
  State<CreateChallengeThr> createState() => _CreateChallengeThrState();
}

class _CreateChallengeThrState extends State<CreateChallengeThr> {
  final logger = Logger();
  final formKey = GlobalKey<FormState>();
  final UserController userController = Get.find<UserController>();
  final challengeFormController = Get.find<ChallengeFormController>();
  final picker = ImagePicker();

  bool isLoading = false;
  bool _canSetCapacity = false;
  final List<bool> _toggleSelections = [true, false];
  final TextEditingController _maxCapacityController = TextEditingController();

  Future<void> _pickImage(bool isSuccess) async {
    final pickedImage =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      if (isSuccess) {
        challengeFormController
            .updateSuccessfulVerificationImage(File(pickedImage.path));
      } else {
        challengeFormController
            .updateFailedVerificationImage(File(pickedImage.path));
      }
    }
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Container(
            color: Colors.white, // 배경 색상을 흰색으로 설정
            child: const Center(
              child: CircularProgressIndicator(color: Palette.mainPurple),
            ),
          )
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.arrow_back_ios),
                onPressed: () {
                  Get.back();
                },
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
              child: RtuButton(
                text: "생성하기",
                onPressed: () async {
                  setState(() {
                    isLoading = true;
                  });
                  if (formKey.currentState!.validate()) {
                    logger.d(
                        '인증 방법: ${challengeFormController.form.certificationExplanation}');
                    logger.d('인증 수단: ${challengeFormController.form.isGalleryPossible}');
                    logger.d(
                        '성공 이미지: ${challengeFormController.form.successfulVerificationImage}');
                    logger.d(
                        '실패 이미지: ${challengeFormController.form.failedVerificationImage}');
                    logger.d('최대 인원: ${challengeFormController.form.maximumPeople}');

                    try {
                      ChallengeService.createChallenge().then((val) {
                        setState(() {
                          isLoading = false;
                        });
                        Get.to(() => CreateCompleteScreen(challengeId: val.id));
                      });
                    } catch (err) {
                      Get.snackbar("챌린지 생성 실패", "다시 시도해주세요.");
                    } finally {}
                  }
                },
              ),
            ),
            body: GestureDetector(
                onTap: () {
                  FocusScope.of(context).unfocus();
                },
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 20),
                            child: SvgPicture.asset(
                                'assets/svgs/create_challenge_level3.svg'),
                          ),
                          inputCertificationExplanation(),
                          pickAuthMethod(),
                          const SizedBox(height: 15),
                          addPicture(),
                          const SizedBox(height: 25),
                          maxCapacity(),
                          const SizedBox(height: 15),
                          _canSetCapacity ? buildMaxCapacity() : Container()
                        ],

                      ),
                    ),
                  ),
                )));
  }

  Widget inputCertificationExplanation() {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "인증 방법",
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Palette.grey300,
              ),
            ),
            const SizedBox(height: 15),
            TextFormField(
              maxLines: 5,
              minLines: 3,
              maxLength: 200,
              style: const TextStyle(
                fontWeight: FontWeight.w300,
                fontSize: 11,
              ),
              decoration: InputDecoration(
                hintText: "인증 방법을 자세하게 알려주세요.",
                hintStyle: const TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w300,
                  color: Palette.grey200,
                ),
                counterStyle: const TextStyle(
                  fontSize: 10,
                  color: Palette.grey200,
                ),
                contentPadding:
                    const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
                filled: true,
                fillColor: Palette.greySoft,
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
              validator: (value) => value!.isEmpty ? "내용을 입력해주세요." : null,
              onChanged: (value) => challengeFormController
                  .updateCertificationExplanation(value.trim()),
            ),
          ],
        ));
  }

  Widget pickAuthMethod() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "인증 수단",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Palette.grey300,
          ),
        ),
        const SizedBox(height: 15),
        ToggleButtons(
          borderRadius: BorderRadius.circular(12), // 전체 토글 버튼의 둥근 정도 설정
          isSelected: _toggleSelections,
          onPressed: (int index) {
            setState(() {
              _toggleSelections[index] = true;
              _toggleSelections[(index + 1) % 2] = false;
            });
            challengeFormController.updateIsGalleryPossible(index == 1);
          },
          children: [
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              height: 50,
              width: 130,
              child: Text(
                '카메라',
                style: TextStyle(
                  fontWeight:
                      _toggleSelections[0] ? FontWeight.bold : FontWeight.w400,
                  fontSize: 13,
                  color: _toggleSelections[0]
                      ? Palette.mainPurple
                      : Palette.grey300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              height: 50,
              width: 130,
              child: Text(
                '카메라+갤러리',
                style: TextStyle(
                  fontWeight:
                      _toggleSelections[1] ? FontWeight.bold : FontWeight.w400,
                  fontSize: 13,
                  color: _toggleSelections[1]
                      ? Palette.mainPurple
                      : Palette.grey300,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget addPicture() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 15),
        const Text(
          "인증 성공 / 실패 예시",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 13,
            color: Palette.grey300,
          ),
        ),
        const SizedBox(height: 15),
        Obx(
          () => Row(
            children: [
              buildImageContainer(
                  challengeFormController.form.successfulVerificationImage,
                  Palette.green,
                  true),
              const SizedBox(width: 20),
              buildImageContainer(
                  challengeFormController.form.failedVerificationImage,
                  Palette.red,
                  false),
            ],
          ),
        )
      ],
    );
  }

  Widget buildImageContainer(File? file, Color color, bool isSuccess) {
    return GestureDetector(
      onTap: () {
        _pickImage(isSuccess);
      },
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: Palette.greySoft,
              borderRadius: BorderRadius.circular(33.0),
              border: Border.all(
                color: file != null ? color : Palette.greySoft,
                width: 2.0,
              ),
            ),
            height: 120,
            width: 120,
            child: file != null
                ? ClipRRect(
                    borderRadius: BorderRadius.circular(30.0),
                    child: Image.file(
                      File(file.path),
                      fit: BoxFit.cover,
                    ),
                  )
                : const Icon(
                    Icons.image,
                    size: 35,
                    color: Palette.grey300,
                  ),
          ),
          const SizedBox(height: 5),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                isSuccess
                    ? 'assets/icons/check_green.png'
                    : 'assets/icons/check_red.png',
                color: color,
              ),
              const SizedBox(width: 5),
              Text(
                isSuccess ? "성공 예시" : "실패 예시",
                style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: Palette.grey200),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget maxCapacity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            "최대 모집 인원 설정하기",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
              fontSize: 13,
              color: Palette.grey300,
            ),
          ),
          Text(
            "모집 인원을 제한 설정할 수 있어요",
            style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.w200,
              fontSize: 10,
              color: Palette.grey300,
            ),
          ),
        ]),
        CupertinoSwitch(
          value: _canSetCapacity,
          activeColor: Palette.mainPurple,
          onChanged: (bool? value) {
            setState(() {
              _canSetCapacity = value ?? false;
            });
          },
        ),
      ],
    );
  }

  Widget buildMaxCapacity() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Container(
          width: 300,
          height: 56,
          padding: const EdgeInsets.symmetric(vertical: 5),
          margin: const EdgeInsets.symmetric(horizontal: 10),
          child: TextFormField(
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
              LengthLimitingTextInputFormatter(4), // 최대 4자리까지 입력 가능
              TextInputFormatter.withFunction((oldValue, newValue) {
                // 새 값이 1에서 1000 사이의 정수인지 확인합니다.
                if (newValue.text.isEmpty) {
                  return TextEditingValue.empty;
                }
                final int? value = int.tryParse(newValue.text);
                return value != null && value >= 1 && value <= 1000
                    ? newValue
                    : oldValue;
              }),
            ],
            controller: _maxCapacityController,
            keyboardType: TextInputType.number,
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                fontFamily: 'Pretender'),
            decoration: InputDecoration(
              focusedBorder: OutlineInputBorder(
                borderSide:
                    const BorderSide(width: 2.0, color: Palette.mainPurple),
                // 포커스가 있을 때의 테두리 색상을 지정합니다.
                borderRadius: BorderRadius.circular(25), // 테두리를 둥글게 만듭니다.
              ),
              hintText: '1~1000',
              hintStyle: const TextStyle(
                  fontWeight: FontWeight.w300,
                  fontSize: 10,
                  fontFamily: 'Pretendard'),
              suffixStyle:
                  const TextStyle(fontFamily: 'Pretendard', fontSize: 10),
              suffix: const Text(
                '명',
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15), // TextField를 둥글게 만듭니다.
              ),
            ),
            onChanged: (value) {
              challengeFormController.updateMaximumPeople(int.parse(value));
            },
          ),
        ),
        // "명" 텍스트 추가
      ],
    );
  }
}
