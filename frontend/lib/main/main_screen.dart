import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend/login/login_screen.dart';
import 'package:frontend/main/bottom_tabs/home/home_screen.dart';
import 'package:frontend/main/bottom_tabs/myRoutineUp/myRoutineUp_screen.dart';
import 'package:frontend/main/bottom_tabs/mypage/mypage_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/user.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/env.dart';

class MainScreen extends StatefulWidget {
  int? tabNumber;

  MainScreen({super.key, this.tabNumber});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late Future<User> _userDataFuture;
  final logger = Logger();
  late int _selectedIndex;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const MyRoutineUpScreen(),
    const MyPageScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  Future<User> _getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final UserController userController = Get.find<UserController>();
    final String? accessToken = prefs.getString('access_token');
    final String url = '${Env.serverUrl}/users/me';

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> userMap =
          jsonDecode(utf8.decode(response.bodyBytes));
      final User user = User.fromJson(userMap);
      userController.saveUser(user);
      logger.d("유저 조회 성공: ${user.name}");
      return user;
    }

    await prefs.remove("access_token");
    return Future.error("유저 조회 실패");
  }

  @override
  void initState() {
    super.initState();
    _userDataFuture = _getUserData();
    if (widget.tabNumber != null) {
      _selectedIndex = widget.tabNumber!;
    }
    else{
      _selectedIndex = 0;
    }
  }

  Widget _errorView(String errorMessage) {
    return Padding(
        padding: const EdgeInsets.all(10),
        child: Center(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(errorMessage),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Get.to(() => const LoginScreen());
              },
              child: const Text("로그인 화면으로 이동"),
            )
          ],
        )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<User>(
        future: _userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return _errorView(snapshot.error.toString());
          } else {
            return SafeArea(
              child: _widgetOptions.elementAt(_selectedIndex),
            );
          }
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "홈"),
          BottomNavigationBarItem(icon: Icon(Icons.timelapse), label: "나의 루틴업"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "마이페이지")
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Palette.mainPurple,
        onTap: _onItemTapped,
      ),
    );
  }
}
