import 'package:flutter/material.dart';
import 'package:frontend/screens/login/login_screen.dart';
import 'package:frontend/screens/main/bottom_tabs/home/home_screen.dart';
import 'package:frontend/screens/main/bottom_tabs/myRoutineUp/my_routine_up_screen.dart';
import 'package:frontend/screens/main/bottom_tabs/mypage/mypage_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/user.dart';
import 'package:frontend/service/user_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class MainScreen extends StatefulWidget {
  final int tabNumber;

  const MainScreen({super.key, required this.tabNumber});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final logger = Logger();

  late Future<User> _userDataFuture;
  late int _selectedIndex;

  final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(),
    const MyRoutineUpScreen(),
    const MyPageScreen(),
  ];

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.tabNumber;
    _userDataFuture = UserService.fetchUser();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
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
