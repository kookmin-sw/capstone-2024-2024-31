import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:flutter/services.dart';

Uint8List concatenatePlanes(List<Plane> planes) {
  final WriteBuffer allBytes = WriteBuffer();
  for (Plane plane in planes) {
    allBytes.putUint8List(plane.bytes);
  }
  return allBytes.done().buffer.asUint8List();
}

Future<Uint8List> convertCameraImageToUint8List(CameraImage cameraImage) async {
  try {
    // Concatenate the image planes to get the full image data
    return concatenatePlanes(cameraImage.planes);
  } catch (e) {
    throw Exception('Failed to convert CameraImage to Uint8List: $e');
  }
}
