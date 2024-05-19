import 'dart:developer';
import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pytorch_lite/pytorch_lite.dart';

import 'camera_view_singleton.dart';

class CameraView extends StatefulWidget {
  final Function(
          List<ResultObjectDetection> recognitions, Duration inferenceTime)
      resultsCallback;
  final Function(String classification, Duration inferenceTime)
      resultsCallbackClassification;

  const CameraView(this.resultsCallback, this.resultsCallbackClassification,
      {Key? key})
      : super(key: key);

  @override
  CameraViewState createState() => CameraViewState();
}

class CameraViewState extends State<CameraView> with WidgetsBindingObserver {
  late List<CameraDescription> cameras;
  CameraController? cameraController;
  bool predicting = false;
  bool predictingObjectDetection = false;
  ModelObjectDetection? _objectModel;
  ClassificationModel? _imageModel;
  bool classification = false;
  int _camFrameRotation = 0;
  String errorMessage = "";

  @override
  void initState() {
    super.initState();
    initStateAsync();
  }

  Future loadModel() async {
    String pathObjectDetectionModel =
        "assets/ai/model_objectDetection.torchscript";
    try {
      _objectModel = await PytorchLite.loadObjectDetectionModel(
          pathObjectDetectionModel, 7, 640, 640,
          labelPath: "assets/ai/labels_objectDetection.txt",
          objectDetectionModelType: ObjectDetectionModelType.yolov5);
    } catch (e) {
      if (e is PlatformException) {
        print("only supported for android, Error is $e");
      } else {
        print("Error is $e");
      }
    }
  }

  void initStateAsync() async {
    WidgetsBinding.instance.addObserver(this);
    await loadModel();

    try {
      initializeCamera();
    } on CameraException catch (e) {
      switch (e.code) {
        case 'CameraAccessDenied':
          errorMessage = ('You have denied camera access.');
          break;
        case 'CameraAccessDeniedWithoutPrompt':
          errorMessage = ('Please go to Settings app to enable camera access.');
          break;
        case 'CameraAccessRestricted':
          errorMessage = ('Camera access is restricted.');
          break;
        case 'AudioAccessDenied':
          errorMessage = ('You have denied audio access.');
          break;
        case 'AudioAccessDeniedWithoutPrompt':
          errorMessage = ('Please go to Settings app to enable audio access.');
          break;
        case 'AudioAccessRestricted':
          errorMessage = ('Audio access is restricted.');
          break;
        default:
          errorMessage = (e.toString());
          break;
      }
      setState(() {});
    }
    setState(() {
      predicting = false;
    });
  }

  void initializeCamera(
      {CameraLensDirection direction = CameraLensDirection.back}) async {
    cameras = await availableCameras();

    var idx = cameras.indexWhere((c) => c.lensDirection == direction);
    if (idx < 0) {
      log("No camera found with direction $direction");
      return;
    }

    var desc = cameras[idx];
    _camFrameRotation = Platform.isAndroid ? desc.sensorOrientation : 0;

    cameraController = CameraController(desc, ResolutionPreset.medium,
        imageFormatGroup: Platform.isAndroid
            ? ImageFormatGroup.yuv420
            : ImageFormatGroup.bgra8888,
        enableAudio: false);

    cameraController?.initialize().then((_) async {
      await cameraController?.startImageStream(onLatestImageAvailable);

      Size? previewSize = cameraController?.value.previewSize;
      CameraViewSingleton.inputImageSize = previewSize!;

      Size screenSize = MediaQuery.of(context).size;
      CameraViewSingleton.screenSize = screenSize;
      CameraViewSingleton.ratio = cameraController!.value.aspectRatio;
    });
  }

  Future<void> switchCamera() async {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return;
    }

    CameraLensDirection currentDirection =
        cameraController!.description.lensDirection;
    CameraLensDirection newDirection =
        currentDirection == CameraLensDirection.back
            ? CameraLensDirection.front
            : CameraLensDirection.back;

    await cameraController?.stopImageStream();
    await cameraController?.dispose();

    initializeCamera(direction: newDirection);
  }

  @override
  Widget build(BuildContext context) {
    if (cameraController == null || !cameraController!.value.isInitialized) {
      return Container();
    }

    return CameraPreview(cameraController!);
  }

  runClassification(CameraImage cameraImage) async {
    if (predicting) {
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      predicting = true;
    });
    if (_imageModel != null) {
      Stopwatch stopwatch = Stopwatch()..start();
      String imageClassification = await _imageModel!
          .getCameraImagePrediction(cameraImage, _camFrameRotation);
      stopwatch.stop();
      widget.resultsCallbackClassification(
          imageClassification, stopwatch.elapsed);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      predicting = false;
    });
  }

  Future<void> runObjectDetection(CameraImage cameraImage) async {
    if (predictingObjectDetection) {
      return;
    }
    if (!mounted) {
      return;
    }

    setState(() {
      predictingObjectDetection = true;
    });
    if (_objectModel != null) {
      Stopwatch stopwatch = Stopwatch()..start();
      List<ResultObjectDetection> objDetect =
          await _objectModel!.getCameraImagePrediction(
        cameraImage,
        _camFrameRotation,
        minimumScore: 0.3,
        iOUThreshold: 0.3,
      );
      stopwatch.stop();
      widget.resultsCallback(objDetect, stopwatch.elapsed);
    }
    if (!mounted) {
      return;
    }

    setState(() {
      predictingObjectDetection = false;
    });
  }

  onLatestImageAvailable(CameraImage cameraImage) async {
    if (!mounted) {
      return;
    }

    runClassification(cameraImage);
    runObjectDetection(cameraImage);

    if (!mounted) {
      return;
    }
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (!mounted) {
      return;
    }
    switch (state) {
      case AppLifecycleState.paused:
        cameraController?.stopImageStream();
        break;
      case AppLifecycleState.resumed:
        if (!cameraController!.value.isStreamingImages) {
          await cameraController?.startImageStream(onLatestImageAvailable);
        }
        break;
      default:
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    cameraController?.dispose();
    super.dispose();
  }
}
