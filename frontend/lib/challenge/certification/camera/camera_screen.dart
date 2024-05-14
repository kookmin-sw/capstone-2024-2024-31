import 'package: flutter/material.dart';
import 'package:get/get.dart';


class CameraScreen extends GetView<ScanController> {
    const CameraScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return getX<ScanController>(builder: (controller) { 
            if(!controller.isInitialized) {
                return Container();
            }
            return Sizedbox(
                height: Get.height,
                width: Get.width,
                child: CameraPreview(controller.cameraController));
        });
    }
}