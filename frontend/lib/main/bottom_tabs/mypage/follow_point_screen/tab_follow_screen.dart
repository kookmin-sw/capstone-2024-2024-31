// import 'dart:html';

import 'package:flutter/material.dart';
import 'package:frontend/main/bottom_tabs/mypage/follow_point_screen/follower_tab.dart';
import 'package:frontend/main/bottom_tabs/mypage/follow_point_screen/following_tab.dart';
import 'package:frontend/model/config/palette.dart';

class TabFollowScreen extends StatefulWidget {
  List<dynamic> followingList;
  List<dynamic> followerList;
  bool isFromFollowing;

  TabFollowScreen(
      {super.key,
      required this.followerList,
      required this.followingList,
      required this.isFromFollowing});

  @override
  State<TabFollowScreen> createState() => _TabFollowScreenState();
}

class _TabFollowScreenState extends State<TabFollowScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _tabController.index =
        widget.isFromFollowing ? 0 : 1; // isFromFollowing 값에 따라 탭 초기 선택 설정
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
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios),
            onPressed: () {},
          ),
          title: Container(
              height: 30,
              margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
              child: const Text(
                "팔로우 목록",
                style: TextStyle(
                    fontFamily: 'Pretendard',
                    fontWeight: FontWeight.bold,
                    fontSize: 16),
              )),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(40),
            child: ClipRRect(
                borderRadius: const BorderRadius.all(Radius.circular(10)),
                child: Container(
                    height: 40,
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: TabBar(
                      indicatorSize: TabBarIndicatorSize.tab,
                      dividerHeight: 0,
                      controller: _tabController,
                      tabs: [
                        Tab(
                          child: Text(
                            '팔로잉 ${widget.followingList.length}',
                            style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Pretendard',
                               ),
                          ),
                        ),
                        Tab(
                          child: Text(
                            '팔로워 ${widget.followerList.length}',
                            style: const TextStyle(
                                fontSize: 13,
                                fontFamily: 'Pretendard',
                              ),
                          ),
                        ),
                      ],
                      indicator: const BoxDecoration(
                          border: Border(
                              bottom: BorderSide(
                                  color: Palette.mainPurple, width: 2.0))),
                      labelColor: Palette.purPle700,
                      labelStyle: const TextStyle(fontWeight: FontWeight.w500),
                      unselectedLabelStyle:
                          const TextStyle(fontWeight: FontWeight.w200),
                    ))),
          )),
      body: TabBarView(
          controller: _tabController,
          children: [
            FollowingTab(
              followingList: widget.followingList,
            ),
            FollowerTab(
              followerList: widget.followerList,
            )
          ]),
    );
  }
}
