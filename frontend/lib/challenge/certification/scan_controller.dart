import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;


class ScanController extends GetxController {

  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  final RxBool _isInitialized = RxBool(false);
  CameraImage? _cameraImage;
  final RxList<Uint8List> _imageList = RxList([]);


  CameraController get cameraController => _cameraController;
  bool get isInitialized => _isInitialized.value;
  List<Uint8List> get imageList => _imageList;


  @override
  void dispose() {
    _isInitialized.value = false;
    _cameraController.dispose();
    super.dispose();
  }


  Future<void> initCamera() async {
    _cameras = await availableCameras();
    _cameraController = CameraController(_cameras[0], ResolutionPreset.high,
        imageFormatGroup: ImageFormatGroup.bgra8888);
    _cameraController.initialize().then((value) {
      _isInitialized.value = true;
      _cameraController.startImageStream((image) => _cameraImage = image);

      _isInitialized.refresh();
    })
        .catchError((Object e) {
      if (e is CameraException) {
        switch (e.code) {
          case 'CameraAccessDenied':
            print('User denied camera access.');
            break;
          default:
            print('Handle other errors.');
            break;
        }
      }
    });
  }

  @override
  void onInit() {
    initCamera();
    super.onInit();
  }

  void capture() {
    if (_cameraImage != null) {
      // Uint8List 인스턴스를 가정
      Uint8List uint8List = _cameraImage!.planes[0].bytes;

// Uint8List에서 ByteBuffer 접근
      ByteBuffer buffer = uint8List.buffer;

// 오프셋과 길이 처리
      int offset = uint8List.offsetInBytes;
      int length = uint8List.lengthInBytes;

// ByteBuffer에서 정확한 Uint8List 부분을 추출하여 함수에 전달
      ByteBuffer correctBuffer = buffer.asUint8List(offset, length).buffer;

      // Create an img.Image from the ByteBuffer
      img.Image image = img.Image.fromBytes(
          width: _cameraImage!.width,
          height: _cameraImage!.height,
          bytes: buffer.uint8List(offset, length),
          format: img.Format.bgra  // Confirm that the format matches your camera data
      );

      // Encode the image to JPEG format and add it to the image list
      Uint8List jpg = Uint8List.fromList(img.encodeJpg(image));
      _imageList.add(jpg);
      _imageList.refresh();
    }
  }


}

