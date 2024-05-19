import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:easy_search_bar/easy_search_bar.dart';
import 'package:frontend/env.dart';
import 'package:frontend/main/bottom_tabs/home/home_components/home_challenge_item_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge_category.dart';
import 'package:frontend/model/data/challenge/challenge_filter.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'challenge_search_components.dart';

class ChallengeSearchScreen extends StatefulWidget {
  const ChallengeSearchScreen({super.key, this.enterSelectIndex});

  final int? enterSelectIndex;

  @override
  State<ChallengeSearchScreen> createState() => _ChallengeSearchScreenState();
}

class _ChallengeSearchScreenState extends State<ChallengeSearchScreen> {
  final logger = Logger();
  final ScrollController _scrollController = ScrollController();
  List<ChallengeSimple> challengeList = [];
  List<String> categoryList = ['전체'] + ChallengeCategory.values.map((e) => e.name).toList();

  String searchValue = '';
  bool _isPrivate = false;
  int selectedIndex = 0;
  int currentCursor = 0;
  final int pageSize = 10;
  bool hasMoreData = true;

  @override
  void initState() {
    super.initState();
    selectedIndex = widget.enterSelectIndex ?? 0;
    _getFilteredChallengeList(false);
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels == _scrollController.position.maxScrollExtent) {
      _getFilteredChallengeList(false);
    }
  }

  Future<void> _getFilteredChallengeList(bool isFiltered) async {
    if (!hasMoreData) return;

    try {
      final dio = Dio();
      final prefs = await SharedPreferences.getInstance();
      dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers['Authorization'] = 'Bearer ${prefs.getString('access_token')}';

      final filter = ChallengeFilter(
        name: searchValue,
        isPrivate: isFiltered ? _isPrivate : null,
        category: selectedIndex == 0 ? null : ChallengeCategory.values[selectedIndex - 1],
      ).toJson();

      logger.d("challenge filter: $filter");

      final response = await dio.post('${Env.serverUrl}/challenges/list',
        data: filter,
        queryParameters: {'cursor': currentCursor, 'size': pageSize},
      );

      if (response.statusCode == 200) {
        logger.d(response.data);
        List<ChallengeSimple> newData = (response.data as List).map((c) => ChallengeSimple.fromJson(c)).toList();

        setState(() {
          if (newData.isNotEmpty) {
            challengeList.addAll(newData);
            currentCursor = challengeList.last.id;
          } else {
            hasMoreData = false;
          }
        });
      } else {
        throw Exception("Failed to load more data");
      }
    } catch (e) {
      logger.d(e.toString());
    }
  }

  void _onSearch(String value) {
    setState(() => searchValue = value);
  }

  void _onCategorySelected(int index) {
    setState(() {
      selectedIndex = selectedIndex == index ? 0 : index;
      hasMoreData = true;
      currentCursor = 0;
      challengeList.clear();
      _getFilteredChallengeList(true);
    });
  }

  void _onPrivateToggle(bool value) {
    setState(() {
      _isPrivate = value;
      hasMoreData = true;
      currentCursor = 0;
      challengeList.clear();
      _getFilteredChallengeList(true);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: EasySearchBar(
        backgroundColor: Palette.mainPurple,
        foregroundColor: Palette.white,
        searchTextStyle: const TextStyle(
          color: Palette.mainPurple,
          fontFamily: "Pretendard",
          fontSize: 14,
          fontWeight: FontWeight.bold,
        ),
        title: const Text(
          "챌린지 모아보기",
          style: TextStyle(
            fontFamily: "Pretendard",
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        onSearch: _onSearch,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CategorySelector(
              categoryList: categoryList,
              selectedIndex: selectedIndex,
              onCategorySelected: _onCategorySelected,
            ),
            PrivateToggle(
              isPrivate: _isPrivate,
              onToggle: _onPrivateToggle,
            ),
            const SizedBox(height: 5),
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1 / 1.4,
                ),
                itemCount: challengeList.length,
                itemBuilder: (context, index) {
                  return ChallengeItemCard(data: challengeList[index]);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
