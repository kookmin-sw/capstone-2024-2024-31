import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/screens/challenge/create/create_challenge_screen_sec.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/challenge_form_controller.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:frontend/widgets/rtu_button.dart';

class CreateChallengeFir extends StatefulWidget {
  const CreateChallengeFir({super.key});

  @override
  State<CreateChallengeFir> createState() => _CreateChallengeFirState();
}

class _CreateChallengeFirState extends State<CreateChallengeFir> {
  late FocusNode _focusNode;
  final controller = Get.put(ChallengeFormController());
  final formKey = GlobalKey<FormState>();
  final logger = Logger();

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
    return Obx(() => Scaffold(
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
            text: "다음으로",
            onPressed: () {
              if (formKey.currentState!.validate()) {
                logger.d('설정된 비공개 여부: ${controller.form.isPrivate}');
                logger.d('설정된 암호: ${controller.form.privateCode}');
                Get.to(() => const CreateChallengeSec());
              }
            },
          ),
        ),
        body: SingleChildScrollView(
            child: Form(
          key: formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child:
                    SvgPicture.asset('assets/svgs/create_challenge_level1.svg'),
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
              if (controller.form.isPrivate) ...[
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNode,
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
                          validator: (value) => value!.isEmpty
                              ? '암호를 입력하세요'
                              : value.length < 6
                                  ? '암호는 6자 이상이어야 합니다.'
                                  : null,
                          onChanged: (value) {
                            controller.updatePrivateCode(value.trim());
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ],
          ),
        ))));
  }

  void onPrivateButtonPressed(bool isPrivate) {
    controller.updateIsPrivate(isPrivate);
    if (!isPrivate) {
      controller.updatePrivateCode('');
    }
  }

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
          onPrivateButtonPressed(isPrivate);
        },
        icon: Icon(
          iconData,
          size: 40,
          color: controller.form.isPrivate == (isOpened == "private")
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
                      color:
                          controller.form.isPrivate == (isOpened == "private")
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
