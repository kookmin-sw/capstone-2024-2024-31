import 'package:flutter/material.dart';
import 'package:get/get.dart' ;
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
      return SizedBox(
          height: Get.height,
          width: Get.width,
          child: CameraPreview(controller.cameraController));
    }
    );
  }
}