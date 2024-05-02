import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:frontend/challenge/certification/camera/camera_app.dart';
import 'package:frontend/challenge/certification/camera/camera_awosome.dart';
import 'package:frontend/challenge/certification/certification_screen.dart';
import 'package:frontend/challenge/create/create_challenge_screen_fir.dart';
import 'package:frontend/challenge/detail/detail_challenge_screen.dart';
import 'package:frontend/community/tab_community_screen.dart';
import 'package:frontend/login/login_screen.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:frontend/main/main_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

late List<CameraDescription> _cameras;

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  _cameras = await availableCameras();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDateFormatting('ko_KR', null);

  // Firebase.initializeApp().whenComplete(() => {
  FlutterNativeSplash.remove();
// });
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  // This widgets is the root of your application.
  Widget build(BuildContext context) {
    return ScreenUtilInit(
        designSize: const Size(375, 844),
        minTextAdapt: true,
        builder: (context, child) {
          return GetMaterialApp(
              theme: ThemeData(primaryColor: Colors.white),
              // navigatorObservers: <NavigatorObserver>[observer],
              initialRoute: 'camera2',
              routes: {
                // SplashScreen.routeName: (context) => SplashScreen(),
                'login': (context) => const LoginScreen(),
                'main': (context) => const MainScreen(),
                'create_challenge': (context) => CreateChallenge_fir(),
                'detail_challenge': (context) => ChallengeDetailScreen(),
                // 'state_challenge' : (context) => ChallengeStateScreen(),
                'community': (context) => TabCommunityScreen(),
                'camera': (context) => CameraApp(cameras: _cameras),
                'camera2': (context) => CameraAwesomeApp()
              });
        });
  }
}
