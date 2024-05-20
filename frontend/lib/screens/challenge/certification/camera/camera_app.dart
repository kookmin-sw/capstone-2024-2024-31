// import 'package:camera/camera.dart';
// import 'package:flutter/material.dart';
// import 'package:frontend/model/config/palette.dart';

// class CameraApp extends StatefulWidget {
//   final List<CameraDescription> cameras;

//   const CameraApp({Key? key, required this.cameras}) : super(key: key);

//   @override
//   State<CameraApp> createState() => CameraAppState();
// }

// class CameraAppState extends State<CameraApp> {
//   late CameraController controller;

//   @override
//   void initState() {
//     super.initState();
//     controller = CameraController(
//       widget.cameras[0], // Using the first camera from the list
//       ResolutionPreset.max,
//       enableAudio: false,
//     );

//     controller.initialize().then((_) {
//       if (!mounted) {
//         return;
//       }
//       setState(() {});
//     }).catchError((Object e) {
//       if (e is CameraException) {
//         switch (e.code) {
//           case 'CameraAccessDenied':
//             print("CameraController Error : CameraAccessDenied");
//             break;
//           default:
//             print("CameraController Error");
//             break;
//         }
//       }
//     });
//   }

//   @override
//   void dispose() {
//     controller.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     Size screenSize = MediaQuery.of(context).size;
//     if (!controller.value.isInitialized) {
//       return Container();
//     }
//     return Container(
//         decoration: BoxDecoration(
//             borderRadius: BorderRadius.circular(20), border: Border.all()),
//         child: CameraPreview(controller));
//   }
// }
