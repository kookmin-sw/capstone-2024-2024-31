import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:frontend/model/config/palette.dart';

class ChallengeSearchScreen extends StatefulWidget {
  const ChallengeSearchScreen({super.key});

  @override
  State<ChallengeSearchScreen> createState() => _ChallengeSearchScreenState();
}

class _ChallengeSearchScreenState extends State<ChallengeSearchScreen> {
  String searchValue = '';
  bool _isPrivate = false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: EasySearchBar(
            backgroundColor: Palette.purPle500,
            foregroundColor: Palette.white,
            searchTextStyle: const TextStyle(
                color: Palette.mainPurple,
                fontFamily: "Pretendard",
                fontSize: 14,
                fontWeight: FontWeight.bold),
            title: const Text("전체 챌린지",
                style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 14,
                    fontWeight: FontWeight.w500)),
            onSearch: (value) => setState(() => searchValue = value),
         ),
        drawer: Drawer(
            child: ListView(padding: EdgeInsets.zero, children: [
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Palette.purPle500,
            ),
            child: Text('카테고리별',
                style: TextStyle(
                    fontFamily: "Pretendard",
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Palette.white)),
          ),
          ListTile(
              title: const Text('전체',
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 14,
                      fontWeight: FontWeight.normal)),
              onTap: () => Navigator.pop(context)),
          ListTile(
              title: const Text('운동',
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 14,
                      fontWeight: FontWeight.normal)),
              onTap: () => Navigator.pop(context)),
          ListTile(
              title: const Text('식습관',
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 14,
                      fontWeight: FontWeight.normal)),
              onTap: () => Navigator.pop(context)),
          ListTile(
              title: const Text('취미',
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 14,
                      fontWeight: FontWeight.normal)),
              onTap: () => Navigator.pop(context)),
          ListTile(
              title: const Text('환경',
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 14,
                      fontWeight: FontWeight.normal)),
              onTap: () => Navigator.pop(context)),
          ListTile(
              title: const Text('공부',
                  style: TextStyle(
                      fontFamily: "Pretendard",
                      fontSize: 14,
                      fontWeight: FontWeight.normal)),
              onTap: () => Navigator.pop(context))
        ])),
        body: Padding(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
            child: Column(children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text("비공개 챌린지만",
                      style: TextStyle(
                          fontFamily: "Pretendard",
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Palette.grey200)),
                  const SizedBox(width: 10),
                  CupertinoSwitch(
                    value: _isPrivate,
                    activeColor: Palette.purPle400,
                    onChanged: (bool? value) {
                      setState(() {
                        _isPrivate = value ?? false;
                      });
                    },
                  ),
                ],
              ),
              Text('Value: $searchValue')
            ])));
  }
}
