import 'dart:io'; // 파일 관련 패키지 추가
import 'dart:typed_data';
import 'package:camera/camera.dart';
import 'package:get/get.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart'; // 경로 관련 패키지 추가
import 'package:tflite_v2/tflite_v2.dart';

class ScanController extends GetxController {
  late List<CameraDescription> _cameras;
  late CameraController _cameraController;
  final RxBool _isInitialized = RxBool(false);
  CameraImage? _cameraImage;
  final RxList<Uint8List> _imageList = RxList([]);
  var _recognitions = [].obs;
  CameraController get cameraController => _cameraController;
  bool get isInitialized => _isInitialized.value;
  List<Uint8List> get imageList => _imageList;
  List get recognitions => _recognitions;

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
      _cameraController.startImageStream((image) async {
        _cameraImage = image;
        await detectImage(image);
      });
      _isInitialized.refresh();
    }).catchError((Object e) {
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

  Future<void> detectImage(CameraImage image) async {
    if (_cameraImage != null) {
      // Convert CameraImage to img.Image
      img.Image imgImage = img.Image.fromBytes(
        _cameraImage!.width,
        _cameraImage!.height,
        _cameraImage!.planes[0].bytes,
        format: img.Format.bgra,
      );

      // Resize the image to 224x224
      img.Image resizedImage =
          img.copyResize(imgImage, width: 224, height: 224);

      // Convert the resized image to Uint8List (JPEG format)
      Uint8List jpg = Uint8List.fromList(img.encodeJpg(resizedImage));

      // Get temporary directory
      Directory tempDir = await getTemporaryDirectory();
      String tempPath = tempDir.path;
      File tempFile = File('$tempPath/temp_image.jpg');

      // Write the image as a file
      await tempFile.writeAsBytes(jpg);

      // Run TFLite model on the resized image
      var recognitions = await Tflite.runModelOnImage(
        path: tempFile.path, // 파일 경로 사용
        imageMean: 127.5,
        imageStd: 127.5,
        numResults: 6,
        threshold: 0.05,
      );

      _recognitions.value = recognitions!;
    }
  }

  @override
  void onInit() {
    loadModel();
    initCamera();
    super.onInit();
  }

  Future<void> loadModel() async {
    await Tflite.loadModel(
      model: "assets/ai/hand_pose_recognizer.tflite",
      labels: "assets/ai/labels.txt",
    );
  }

  void capture() {
    if (_cameraImage != null) {
      img.Image image = img.Image.fromBytes(
        _cameraImage!.width,
        _cameraImage!.height,
        _cameraImage!.planes[0].bytes,
        format: img.Format.bgra,
      );
      Uint8List list = Uint8List.fromList(img.encodeJpg(image));
      _imageList.add(list);
      _imageList.refresh();
    }
  }
}
