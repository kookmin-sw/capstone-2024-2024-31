import 'package:camera/camera.dart';
import 'package:frontend/challenge/certification/camera/capture_button.dart';
import 'package:frontend/challenge/certification/camera/top_image_viewer.dart';
import '../scan_controller.dart';
import './camera_viewer.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';


class CameraScreen extends StatelessWidget {
    const CameraScreen({Key? key}) : super(key: key);

    @override
    Widget build(BuildContext context) {
        return Stack(
            alignment: Alignment.center,
            children: [
                CameraViewer(),
                CaptureButton(),
                TopImageViewer()
            ],
        );
    }
}