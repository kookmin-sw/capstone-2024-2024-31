import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:frontend/main/bottom_tabs/home/home_screen.dart';
import 'package:frontend/main/bottom_tabs/myRoutineUp/myRoutineUp_screen.dart';
import 'package:frontend/main/bottom_tabs/mypage/mypage_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/global_variables.dart';
import 'package:frontend/model/data/user.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

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

  void _getUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final String? accessToken = prefs.getString('access_token');
    final String url = '${GlobalVariables().SERVER_URL}/users/me';

    final response = await http.get(
      Uri.parse(url),
      headers: <String, String>{
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      UserController userController = Get.find<UserController>();
      final Map<String, dynamic> data =
          jsonDecode(utf8.decode(response.bodyBytes));
      final User user = User.fromJson(data);
      userController.saveUser(user);
    } else {
      Get.snackbar('로그인 실패', '다시 로그인해주세요');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: _widgetOptions.elementAt(_selectedIndex),
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

  @override
  void initState() {
    //해당 클래스가 호출되었을떄
    super.initState();
    _getUserData();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
