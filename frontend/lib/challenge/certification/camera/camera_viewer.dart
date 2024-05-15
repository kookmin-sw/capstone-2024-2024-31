import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../scan_controller.dart';
import 'package:camera/camera.dart';

class CameraViewer extends GetView<ScanController> {
  const CameraViewer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetX<ScanController>(builder: (controller) {
      if (!controller.isInitialized) {
        return Container();
      }
      return Stack(
        children: [
          SizedBox(
            height: Get.height,
            width: Get.width,
            child: CameraPreview(controller.cameraController),
          ),
          ...controller.recognitions.map((recog) {
            return Positioned(
              left: recog['rect']['x'] * Get.width,
              top: recog['rect']['y'] * Get.height,
              width: recog['rect']['w'] * Get.width,
              height: recog['rect']['h'] * Get.height,
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    color: Colors.red,
                    width: 3,
                  ),
                ),
                child: Text(
                  "${recog['label']} ${(recog['confidence'] * 100).toStringAsFixed(0)}%",
                  style: TextStyle(
                    background: Paint()..color = Colors.red,
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ),
            );
          }).toList(),
        ],
      );
    });
  }
}
