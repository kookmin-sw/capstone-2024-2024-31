import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

import '../../../model/data/gesture.dart';

class CertificationByGallery extends StatefulWidget {
  const CertificationByGallery({super.key});

  @override
  CertificationByGalleryState createState() => CertificationByGalleryState();
}

class CertificationByGalleryState extends State<CertificationByGallery> {
  ClassificationModel? _imageModel;
  bool isLoading = false;
  bool isInit = false;
  late ModelObjectDetection _objectModel;
  bool? result;
  String? textToShow;
  List? _prediction;
  File? _image;
  final ImagePicker _picker = ImagePicker();
  bool objectDetection = false;
  List<ResultObjectDetection?> objDetect = [];
  late Map<String, dynamic> certificationGesture;
  Logger logger = Logger();

  TextStyle textStyle(double size, Color color,
          {FontWeight weight = FontWeight.w400}) =>
      TextStyle(
          fontSize: size,
          fontWeight: weight,
          fontFamily: 'Pretender',
          color: color);

  @override
  void initState() {
    super.initState();
    setState(() {
      isLoading = true;
      isInit = true;
    });
    certificationGesture = Gesture().getRandomGesture();
    loadModel();
  }

  // Load your model
  Future<void> loadModel() async {
    String pathImageModel = "assets/models/model_classification.pt";
    String pathObjectDetectionModel =
        "assets/ai/model_objectDetection.torchscript";

    try {
      _imageModel = await PytorchLite.loadClassificationModel(
          pathImageModel, 224, 224, 1000,
          labelPath: "assets/labels/label_classification_imageNet.txt");
      _objectModel = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionModel, 7, 640, 640,
          labelPath: "assets/ai/labels_objectDetection.txt");

      setState(() {
        isLoading = false; // loadModel after loading is false
      });
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  Future<bool> runObjectDetection() async {
    bool result = false;

    setState(() {
      //일반로딩
      isLoading = true;
    });

    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image == null) {
      setState(() {
        isLoading = false;
      });
      return false;
    }

    Stopwatch stopwatch = Stopwatch()..start();

    try {
      setState(() {
        //"AI 인증 중입니다" 로딩 뷰
        isLoading = true;
        isInit = false;
      });
      objDetect = await _objectModel.getImagePrediction(
          await File(image.path).readAsBytes(),
          minimumScore: 0.1,
          iOUThreshold: 0.3);
      print('object executed in ${stopwatch.elapsed.inMilliseconds} ms');
    } catch (e) {
      logger.e("Error during object detection: $e");
    } finally {}
    logger.d('object executed in ${stopwatch.elapsed.inMilliseconds} ms');
    for (var element in objDetect) {
      logger.d({
        "score": element?.score,
        "className": element?.className,
      });
      if (Gesture().checkGesture(
          certificationGesture["gesture"], element?.className?.trim() ?? "")) {
        textToShow = "인증되었습니다!";
        result = true;
      }
      break;
    }

    setState(() {
      _image = File(image.path);
      isLoading = false;
    });
    textToShow = "인증 실패했습니다\n다시 시도하세요!";

    return result;
  }

  Widget loadingView(bool isInit) {
    return isInit
        ? const Center(
            child: CircularProgressIndicator(
              color: Palette.mainPurple,
            ),
          )
        : Center(
            child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const CircularProgressIndicator(
                color: Palette.mainPurple,
              ),
              const SizedBox(height: 20),
              Text(
                "AI 인증 검사하는 중이에요!\n잠시만 기다려주세요.",
                style: textStyle(19.0, Palette.mainPurple,
                    weight: FontWeight.bold),
                textAlign: TextAlign.center,
              )
            ],
          ));
  }

  String resultString(bool result) =>
      result ? "인증되었습니다!" : "${certificationGesture['nameText']} 포즈\n인증 실패했습니다.\n다시 시도하세요.";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          backgroundColor: Palette.mainPurple,
          actions: [
            TextButton(
                onPressed: () {
                  if (_image != null && result!) {
                    Navigator.pop(context, _image);
                  } else {
                    Get.snackbar("사진을 등록할 수 없습니다.", "다시 인증하세요");
                  }
                },
                child: Text(
                  "확인",
                  style:
                      textStyle(17.0, Palette.white, weight: FontWeight.bold),
                ))
          ],
          title: Text(
            '🖼️ 갤러리로 인증하기',
            style: textStyle(17.0, Palette.white, weight: FontWeight.bold),
          ),
        ),
        body: isLoading
            ? loadingView(isInit)
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: objDetect.isNotEmpty
                        ? _image == null
                            ? const Text('이미지 없음')
                            : _objectModel.renderBoxesOnImage(
                                _image!, objDetect)
                        : _image == null
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SizedBox(
                                      child: certificationGesture['asset'],
                                      height: 100),
                                  const SizedBox(height: 20),
                                  Text(
                                      "${certificationGesture['nameText']} 포즈가\n 포함된 사진을 선택하세요!",
                                      textAlign: TextAlign.center,
                                      style: textStyle(15, Palette.grey500))
                                ],
                              )
                            : Image.file(_image!),
                  ),
                  Center(
                    child: Visibility(
                      visible: textToShow != null,
                      child: Text(
                        "$textToShow",
                        style: textStyle(15, Palette.grey500,
                            weight: FontWeight.bold),
                        textAlign: TextAlign.center,
                        maxLines: 3,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    child: TextButton(
                      onPressed: () async {
                        result = await runObjectDetection();
                        print("Detection result: $result");
                        textToShow = resultString(result!);
                      },
                      style: TextButton.styleFrom(
                        backgroundColor: Palette.mainPurple,
                      ),
                      child: const Text(
                        "인증사진 선택하기",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  Center(
                    child: Visibility(
                      visible: _prediction != null,
                      child:
                          Text(_prediction != null ? "${_prediction![0]}" : ""),
                    ),
                  )
                ],
              ),
      ),
    );
  }
}
