import 'package:flutter/material.dart';
import 'package:pytorch_lite/pytorch_lite.dart';
import 'package:camera/camera.dart';
import 'dart:io';
import 'camera_view_singleton.dart';
import 'confirm_image_screen.dart';
import 'ui/box_widget.dart';
import 'ui/camera_view.dart';

class RunModelByCameraDemo extends StatefulWidget {
  const RunModelByCameraDemo({super.key});

  @override
  State<RunModelByCameraDemo> createState() => _RunModelByCameraDemoState();
}

class _RunModelByCameraDemoState extends State<RunModelByCameraDemo> {
  List<ResultObjectDetection>? results;
  Duration? objectDetectionInferenceTime;
  int detectionCount = 0;
  late File capturedImage;

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
    if (!mounted) {
      return;
    }
    setState(() {
      this.results = results;
      objectDetectionInferenceTime = inferenceTime;
      detectionCount++;
      if (detectionCount >= 3) {
        captureImage();
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
              onPressed: () {
                Navigator.of(context).pop(); // 팝업 닫기
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ConfirmImageScreen(image: image),
                  ),
                );
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
