import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:frontend/model/data/post/post_form.dart';
import 'package:frontend/screens/community/post_detail_screen.dart';
import 'package:frontend/service/post_service.dart';
import 'package:frontend/widgets/rtu_button.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'dart:io';
import '../challenge/certification/certification_camera.dart';
import '../challenge/certification/certification_gallery.dart';

class CreatePostingScreen extends StatefulWidget {
  final Challenge challenge;
  const CreatePostingScreen({super.key, required this.challenge,});

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

  late int _challengeId;
  late bool _isGalleryPossible;
  bool _showImage = false;
  String _inputTitle = '';
  String _inputContent = '';
  File _inputImage = File('');

  @override
  void initState() {
    super.initState();
    _challengeId = widget.challenge.id;
    _isGalleryPossible = widget.challenge.isGalleryPossible;
  }

  void getImage(final bool isGallery) async {
    if (isGallery) {
      // 기존 isGallery=true 로직
      final selectedImage = await Get.to(() => const CertificationByGallery());
      if (selectedImage != null) {
        setState(() {
          _inputImage = selectedImage;
          _showImage = true;
        });
      } else {
        final image =
            await ImagePicker().pickImage(source: ImageSource.gallery);
        if (image != null) {
          setState(() {
            _inputImage = File(image.path);
            _showImage = true;
          });
        }
      }
    } else { //카메라 버튼일때

      final cameraImage  =  await Get.to(()=> const CertificationCamera());

      if (cameraImage != null) {

        setState(() {
          _inputImage = cameraImage;
          _showImage = true;
        });
      }
    }
  }

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
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          Center(
              child: Text(
            "※ 공정한 인증을 위하여\n사진과 글은 추후에 수정할 수 없습니다.",
            textAlign: TextAlign.center,
            style: textStyle(11, Palette.purPle400),
          )),
          const SizedBox(height: 10),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: RtuButton(
                onPressed: () {
                  setState(() {
                    _inputTitle = _inputTitle.trim();
                    _inputContent = _inputContent.trim();
                  });

                  if (formKey.currentState!.validate()) {
                    PostService.createPost(
                            _challengeId,
                            PostForm(
                                title: _inputTitle,
                                content: _inputContent,
                                image: _inputImage))
                        .then((value) => {
                              Get.off(() => PostDetailScreen(
                                    post: value,
                                  ))
                            });
                  }
                },
                text: "올리기",
              ))
        ]),
        body: GestureDetector(
            onTap: () {
              FocusScope.of(context).unfocus();
            },
            child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                child: Form(
                  key: formKey,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          Text("📸 사진",
                              style: textStyle(15, Palette.grey500,
                                  weight: FontWeight.bold)),
                          Visibility(
                              visible: _showImage,
                              child: GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _showImage = false;
                                      _inputImage = File(''); // 이미지 리셋
                                    });
                                  },
                                  child: const Icon(Icons.close, color: Palette.red)))
                        ]),
                        const SizedBox(height: 10),
                        imageContainer(),
                        const SizedBox(height: 20),
                        Text("제목",
                            style: textStyle(15, Palette.grey500,
                                weight: FontWeight.bold)),
                        const SizedBox(height: 10),
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
                              onChanged: (value) => setState(() {
                                _inputTitle = value;
                              }),
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
                                  borderSide: const BorderSide(
                                      color: Palette.greySoft)),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(12.0),
                                borderSide: const BorderSide(
                                    color: Palette.mainPurple, width: 2),
                              )),
                          validator: (value) =>
                              value!.isEmpty ? "오늘의 루틴업 한마디를 작성해주세요." : null,
                          onChanged: (value) => setState(() {
                            _inputContent = value;
                          }),
                        )
                      ]),
                ))));
  }

  Widget imageContainer() {
    return SizedBox(
        width: double.infinity,
        height: 200,
        child: Stack(
          children: [
            Positioned.fill(
                child: Visibility(
                  visible: !_showImage,
                  child:   _isGalleryPossible
                      ? Row(
                    children: [
                      shadowBtn(Icons.camera_alt, false),
                      const Padding(
                          padding: EdgeInsets.symmetric(
                              vertical: 30, horizontal: 3),
                          child: VerticalDivider(
                            color: Palette.grey50,
                            thickness: 3,
                          )),
                      shadowBtn(Icons.add_photo_alternate, true)
                    ],
                  ) : shadowBtn(Icons.camera_alt, false),
                )),
            Positioned.fill(
              child: Visibility(
                  visible: _showImage,
                  child: Image.file(
                    _inputImage,
                    fit: BoxFit.fitHeight,
                  )),
            ),
          ],
        ));
  }

  Widget shadowBtn(final IconData iconData, bool isGallery) {
    return Expanded(
        child: GestureDetector(
            onTap: () => getImage(isGallery), //여기
            child: Container(
                decoration: BoxDecoration(
                  color: Palette.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(15),
                    child: Center(
                        child: Icon(iconData, color: Palette.grey500))))));
  }
}
