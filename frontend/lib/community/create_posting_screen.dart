import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/community/community_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class CreatePostingScreen extends StatefulWidget {
  const CreatePostingScreen({super.key});

  @override
  State<CreatePostingScreen> createState() => _CreatePostingScreenState();
}

class _CreatePostingScreenState extends State<CreatePostingScreen> {
  TextStyle textStyle(double size, Color color,
          {FontWeight weight = FontWeight.w400}) =>
      TextStyle(
          fontSize: size,
          fontWeight: weight,
          fontFamily: 'Pretender',
          color: color);

  final logger = Logger();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {
              Get.back();
            },
          ),
          title: const Text(
            '인증 게시글 작성',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              fontFamily: 'Pretender',
            ),
          ),
        ),
        body: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: Form(
                key: formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text("📸 인증 사진",
                        style: textStyle(15, Palette.grey500,
                            weight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset("assets/images/challenge_image.png",
                            width: double.infinity)),
                    const SizedBox(height: 15),
                    Text("제목",
                        style: textStyle(15, Palette.grey500,
                            weight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    SizedBox(
                        height: 70,
                        child: TextFormField(
                          maxLength: 15,
                          style: textStyle(11, Palette.grey200,
                              weight: FontWeight.w300),
                          decoration: InputDecoration(
                              hintText: "제목을 입력해주세요.",
                              hintStyle: textStyle(11, Palette.grey200,
                                  weight: FontWeight.w300),
                              counterStyle: textStyle(10, Palette.grey200,
                                  weight: FontWeight.normal),
                              contentPadding: const EdgeInsets.symmetric(
                                  vertical: 0, horizontal: 10),
                              filled: true,
                              fillColor: Palette.white,
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: const BorderSide(
                                      color: Palette.greySoft)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Palette.mainPurple, width: 2),
                              )),
                          validator: (value) =>
                              value!.isEmpty ? '제목을 입력해주세요.' : null,
                          // onChanged: (value) => controller.updateChallengeName(value),
                        )),
                    const SizedBox(height: 10),
                    Text("📢 루틴업 한마디",
                        style: textStyle(15, Palette.grey500,
                            weight: FontWeight.bold)),
                    const SizedBox(height: 5),
                    TextFormField(
                      maxLength: 100,
                      maxLines: 5,
                      style: textStyle(11, Palette.grey200,
                          weight: FontWeight.w300),
                      decoration: InputDecoration(
                          hintText: "오늘의 갓생은 어땠는지 루티너와 공유해주세요!",
                          hintStyle: textStyle(11, Palette.grey200,
                              weight: FontWeight.w300),
                          counterStyle: textStyle(10, Palette.grey200,
                              weight: FontWeight.normal),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10, horizontal: 10),
                          filled: true,
                          fillColor: Palette.white,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide:
                                  const BorderSide(color: Palette.greySoft)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Palette.mainPurple, width: 2),
                          )),
                      validator: (value) =>
                          value!.isEmpty ? "오늘의 루틴업 한마디를 작성해주세요." : null,
                      // onChanged: (value) => controller.updateChallengeName(value),
                    ),
                    const SizedBox(height: 40),
                    Center(
                        child: Text(
                      "※ 공정한 인증을 위하여\n사진과 글은 추후에 수정할 수 없습니다.",
                      textAlign: TextAlign.center,
                      style: textStyle(11, Palette.purPle400),
                    )),
                    const SizedBox(height: 20),
                    GestureDetector(
                        onTap: () {
                          if (formKey.currentState!.validate()) {
                            // logger.d("사진: ${controller.form.challengeName}");
                            // logger.d(
                            //     "제목: ${controller.form.challengeExplanation}");
                            // logger.d("내용: ${controller.form.challengeImages}");
                            //
                            try {
                              // final int challengeId = await _postChallenge();
                              logger.d('인증글 생성 성공: ');
                              Get.snackbar("오늘의 인증 성공 ✨", "당신의 갓생을 응원해요!");
                              Get.offAll(() => const CommunityScreen(
                                  isFromCreatePostingScreen: true));
                            } catch (err) {
                              Get.snackbar("오늘의 인증 실패", "다시 시도해주세요😭");
                            }
                          }
                        },
                        child: SvgPicture.asset(
                            "assets/svgs/create_posting_btn.svg"))
                  ],
                ))));
  }
}
