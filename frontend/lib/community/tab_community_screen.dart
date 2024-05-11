import 'package:flutter/material.dart';
import 'package:frontend/community/community_screen.dart';
import 'package:frontend/model/config/palette.dart';

class TabCommunityScreen extends StatefulWidget {
  const TabCommunityScreen({super.key});

  @override
  State<TabCommunityScreen> createState() => _TabCommunityScreenState();
}

class _TabCommunityScreenState extends State<TabCommunityScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
          title: Container(
              height: 30,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: const Text(
                "인증",
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
      ),
      body: const CommunityScreen()
    );
  }
}
