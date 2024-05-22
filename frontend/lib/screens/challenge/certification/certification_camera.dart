import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import '../../../model/data/gesture.dart';
import 'camera_view_singleton.dart';
import 'confirm_image_screen.dart';
import 'ui/box_widget.dart';
import 'ui/camera_view.dart';
import 'dart:collection';

class CertificationCamera extends StatefulWidget {
  const CertificationCamera({super.key});

  @override
  State<CertificationCamera> createState() => _CertificationCameraState();
}

class _CertificationCameraState extends State<CertificationCamera> {
  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<CameraViewState> cameraViewKey = GlobalKey<CameraViewState>();

  List<ResultObjectDetection>? results;
  Duration? objectDetectionInferenceTime;
  Queue<String?> recentClasses = Queue<String?>(); // 최근 탐지된 클래스 저장
  int detectionCount = 0;
  late File capturedImage;
  bool detectionComplete = false; // 플래그 변수 추가

  //제스처 UI 관련
  bool resultHasTarget = false;
  late Map<String, dynamic> certificationGesture;
  Gesture gesture = Gesture();
  int correctDetectionCount = 0;

  TextStyle textStyle(double size, Color color,
          {FontWeight weight = FontWeight.w400}) =>
      TextStyle(
          fontSize: size,
          fontWeight: weight,
          fontFamily: 'Pretender',
          color: color);

  @override
  void initState() {
    detectionCount = 0;
    certificationGesture = gesture.getRandomGesture();

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.black,
      body: Stack(
        children: <Widget>[
          CameraView(resultsCallback, key: cameraViewKey),
          boundingBoxes2(results),
          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.4,
              minChildSize: 0.1,
              maxChildSize: 0.5,
              builder: (_, ScrollController scrollController) => Container(
                width: double.maxFinite,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(24.0),
                        topRight: Radius.circular(24.0))),
                child: SingleChildScrollView(
                  controller: scrollController,
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: Column(
                            children: [
                              offerGesture(certificationGesture),
                              const SizedBox(height: 10),
                              CameraProgressWidget(
                                  detectionCount: correctDetectionCount),
                              const SizedBox(height: 15),
                              ElevatedButton(
                                onPressed: () {
                                  cameraViewKey.currentState?.switchCamera();
                                },
                                child: const Icon(
                                  Icons.cameraswitch_rounded,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget boundingBoxes2(List<ResultObjectDetection>? results) {
    if (results == null) {
      return Container();
    }
    return Stack(
      children: results.map((e) => BoxWidget(result: e)).toList(),
    );
  }

  void resultsCallback(
      List<ResultObjectDetection> results, Duration inferenceTime) async {
    if (!mounted || detectionComplete) {
      // 인증 완료된 경우 콜백 무시
      return;
    }
    setState(() {
      this.results = results;
      objectDetectionInferenceTime = inferenceTime;
      print("inference Time : ${inferenceTime.inMilliseconds}}");
      // 최근 탐지된 클래스 추적
      if (results.isNotEmpty) {
        for (var result in results) {
          String? detectedClass = result.className; // Null 가능성 처리
          if (gesture.checkGesture(
              certificationGesture['gesture'], detectedClass ?? "")) {
            //제스처가 인증제스처와 같으면, add
            resultHasTarget = true;
            correctDetectionCount++;
            recentClasses.add(detectedClass);
          } else {
            resultHasTarget = false; //탐지한 객체가 offerGesture와 다르면 false
          }
        }
        if (recentClasses.length > 2) {
          recentClasses.removeFirst();
          resultHasTarget = false;
        }

        // 같은 클래스가 연속 세 번 탐지되었는지 확인
        if (recentClasses.length == 2 &&
            recentClasses.every((c) => c == recentClasses.first)) {
          detectionComplete = true; // 객체 탐지 완료 플래그 설정
          captureImage();
        }
      }
    });
  }

  void captureImage() async {
    final CameraController? cameraController =
        cameraViewKey.currentState?.cameraController;
    if (cameraController != null && cameraController.value.isInitialized) {
      final XFile file = await cameraController.takePicture();
      capturedImage = File(file.path);
      showSuccessDialog(capturedImage);
    }
  }

  void showSuccessDialog(File image) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            '인증 성공!',
            style: textStyle(17, Palette.mainPurple, weight: FontWeight.bold),
          ),
          content: Text(
            '인증이 성공적으로 완료되었습니다.',
            style: textStyle(13, Palette.grey300, weight: FontWeight.bold),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                '확인',
                style:
                    textStyle(14, Palette.mainPurple, weight: FontWeight.bold),
              ),
              onPressed: () async {
                Navigator.of(context).pop(); // 팝업 닫기

                final confirmedImage =
                    await Get.to(() => ConfirmImageScreen(image: image));
                if (confirmedImage != null) {
                  Get.back(result: confirmedImage);
                }
              },
            ),
          ],
        );
      },
    );
  }
}

Widget offerGesture(Map<String, dynamic> certificationGesture) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    mainAxisAlignment: MainAxisAlignment.center,
    children: [
      SizedBox(child: certificationGesture['asset'], height: 100),
      const SizedBox(height: 20),
      Text("${certificationGesture['nameText']} 포즈를 유지하세요!",
          textAlign: TextAlign.center, style: textStyle(13, Palette.grey500))
    ],
  );
}

TextStyle textStyle(double size, Color color,
        {FontWeight weight = FontWeight.w400}) =>
    TextStyle(
        fontSize: size,
        fontWeight: weight,
        fontFamily: 'Pretender',
        color: color);

class CameraProgressWidget extends StatelessWidget {
  final int detectionCount;

  const CameraProgressWidget({super.key, required this.detectionCount});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(2, (index) {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: index < detectionCount
                    ? Palette.purPle500
                    : Palette.grey200,
              ),
              child: Center(
                child: Text(
                  '${index + 1}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontFamily: 'Pretender',
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          );
        }),
      ),
    );
  }
}
