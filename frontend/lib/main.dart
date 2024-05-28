import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:flutter/services.dart';
import 'package:frontend/service/dio_service.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:frontend/screens/main/main_screen.dart';
import 'package:get/get.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'model/config/palette.dart';

const AndroidNotificationChannel channel = AndroidNotificationChannel(
  'high_importance_channel', // id
  'High Importance Notifications', // title
  description:
      'This channel is used for important notifications.', // description
  importance: Importance.max,
);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
    FlutterLocalNotificationsPlugin();

Future<void> _initializeNotifications() async {
  const AndroidInitializationSettings initializationSettingsAndroid =
      AndroidInitializationSettings('@mipmap/launcher_icon');

  const InitializationSettings initializationSettings = InitializationSettings(
    android: initializationSettingsAndroid,
  );

  await flutterLocalNotificationsPlugin.initialize(initializationSettings);
}

@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();

  if (message.notification != null) {
    flutterLocalNotificationsPlugin.show(
        message.notification.hashCode,
        message.notification!.title,
        message.notification!.body,
        NotificationDetails(
          android: AndroidNotificationDetails(
            channel.id,
            channel.name,
            channelDescription: channel.description,
            icon: message.notification!.android!.smallIcon,
          ),
        ));
  }
}

void _permissionWithNotification() async {
  if (await Permission.notification.isDenied &&
      !await Permission.notification.isPermanentlyDenied) {
    await [Permission.notification].request();
  }
}

void main() async {
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Palette.mainPurple,
      statusBarIconBrightness: Brightness.light,
    ),
  );

  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  await initializeDateFormatting('ko_KR', null);

  await DioService.init();

  bool isLoggedIn = await checkIfLoggedIn();
  FlutterNativeSplash.remove();

  _permissionWithNotification();

  await Firebase.initializeApp();
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  await _initializeNotifications();
  await flutterLocalNotificationsPlugin
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);
  runApp(MyApp(isLoggedIn: isLoggedIn));
}

class MyApp extends StatefulWidget {
  final bool isLoggedIn;

  const MyApp({super.key, required this.isLoggedIn});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final Logger logger = Logger();

  @override
  initState() {
    super.initState();

    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      logger.d('meesage title: ${message.notification!.title}');
      logger.d('meesage body: ${message.notification!.body}');

      if (message.notification != null) {
        flutterLocalNotificationsPlugin.show(
            message.notification.hashCode,
            message.notification!.title,
            message.notification!.body,
            NotificationDetails(
              android: AndroidNotificationDetails(
                channel.id,
                channel.name,
                channelDescription: channel.description,
                icon: message.notification!.android!.smallIcon,
              ),
            ));
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    Get.put(UserController());

    return GetMaterialApp(
              debugShowCheckedModeBanner: false,
              theme: ThemeData(
                  scaffoldBackgroundColor: Colors.white,
                  // primaryColor: Colors.white,
                ),
              initialRoute: widget.isLoggedIn ? 'main' : 'login',
              useInheritedMediaQuery: true,
              routes: {
                'login': (context) => const LoginScreen(),
                'main': (context) => const MainScreen(
                      tabNumber: 0,
                    ),
              });

  }
}

Future<bool> checkIfLoggedIn() async {
  final SharedPreferences prefs = await SharedPreferences.getInstance();
  final String? accessToken = prefs.getString('access_token');

  bool isLoggedIn = accessToken != null;

  return isLoggedIn;
}
