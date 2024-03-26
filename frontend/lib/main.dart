import 'package:flutter/material.dart';
import 'package:frontend/login/login_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

void main() async {

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  // This widget is the root of your application.
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
              theme: ThemeData(primaryColor: Colors.white),
              // navigatorObservers: <NavigatorObserver>[observer],
              initialRoute: 'home',
              routes: {
                // SplashScreen.routeName: (context) => SplashScreen(),
                'home': (context) => const LoginScreen(),

              });
        });
  }
}