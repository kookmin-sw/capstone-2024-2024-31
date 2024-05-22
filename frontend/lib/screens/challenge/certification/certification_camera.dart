import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:camera/camera.dart';
import 'dart:io';
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
  List<ResultObjectDetection>? results;
  Duration? objectDetectionInferenceTime;
  Queue<String?> recentClasses = Queue<String?>(); // 최근 탐지된 클래스 저장
  int detectionCount = 0;
  late File capturedImage;
  bool detectionComplete = false; // 플래그 변수 추가

  GlobalKey<ScaffoldState> scaffoldKey = GlobalKey();
  GlobalKey<CameraViewState> cameraViewKey = GlobalKey<CameraViewState>();

  @override
  void initState() {
    super.initState();
    detectionCount = 0;
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
                        const Icon(Icons.keyboard_arrow_up,
                            size: 48, color: Colors.orange),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Column(
                            children: [
                              if (objectDetectionInferenceTime != null)
                                StatsRow('Object Detection Inference time:',
                                    '${objectDetectionInferenceTime?.inMilliseconds} ms'),
                              ElevatedButton(
                                onPressed: () {
                                  cameraViewKey.currentState?.switchCamera();
                                },
                                child: const Text('Switch Camera'),
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

      // 최근 탐지된 클래스 추적
      if (results.isNotEmpty) {
        for (var result in results) {
          String? detectedClass = result.className; // Null 가능성 처리
          recentClasses.add(detectedClass);
        }
        if (recentClasses.length > 3) {
          recentClasses.removeFirst();
        }

        // 같은 클래스가 연속 세 번 탐지되었는지 확인
        if (recentClasses.length == 3 &&
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
          title: const Text('인증 성공!'),
          content: const Text('인증이 성공적으로 완료되었습니다.'),
          actions: <Widget>[
            TextButton(
              child: const Text('확인'),
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

class StatsRow extends StatelessWidget {
  final String title;
  final String value;

  const StatsRow(this.title, this.value, {super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Column(
        children: [
          Text(
            title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          Text(value)
        ],
      ),
    );
  }
}
