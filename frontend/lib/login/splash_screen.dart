// import 'dart:convert';
// import 'package:crypto/crypto.dart';
// import 'package:flutter/material.dart';
// import 'package:frontend/main/main_screen.dart';
// import 'package:frontend/model/config/palette.dart';
// import 'package:get/get.dart';
//
// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key? key}) : super(key: key);
//   static const routeName = 'splash';
//
//   @override
//   State<SplashScreen> createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     super.initState();
//     _routePage();
//   }
//
//   Future<void> _routePage() async {
//     String initialRoute = 'login';
//     String newUserUid = '';
//     String uid = '';
//
//     // 로그인 정보 파악 후, 페이지 이동
//     await Future.delayed(Duration(seconds: 3));
//     if (initialRoute == 'tab') {
//       print(' 토큰 자동 로그인 성공 👋');
//       Get.offAll(MainScreen());
//     } else {
//       if (!mounted) return;
//       Navigator.pushReplacementNamed(context, initialRoute);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final screenSize = MediaQuery.of(context).size;
//
//     return WillPopScope(
//         onWillPop: () async {
//           return false;
//         },
//         child: Scaffold(
//             appBar: AppBar(
//               backgroundColor: Colors.transparent,
//               elevation: 0,
//             ),
//             backgroundColor: Palette.mainPurple,
//             body: Container(
//                 width: screenSize.width * 0.6,
//                 height: double.infinity,
//                 alignment: Alignment.topCenter,
//                 decoration: BoxDecoration(
//                     image: DecorationImage(
//                         alignment: Alignment.topCenter,
//                         fit: BoxFit.fitWidth,
//                         image: AssetImage('assets/images/logo/logo_white.png'))))));
//   }
// }