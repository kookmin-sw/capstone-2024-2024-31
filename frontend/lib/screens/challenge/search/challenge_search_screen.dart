import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/env.dart';
import 'package:frontend/screens/main/bottom_tabs/home/home_list_widgets/home_challenge_item_card.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge_category.dart';
import 'package:frontend/model/data/challenge/challenge_filter.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:get/get.dart';
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
  List<String> categoryList =
      ['전체'] + ChallengeCategory.values.map((e) => e.name).toList();

  String _inputName = '';
  bool _isPrivate = false;
  int _seletedCategoryIndex = 0;
  int currentCursor = 0;
  final int pageSize = 10;
  bool hasMoreData = true;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    _seletedCategoryIndex = widget.enterSelectIndex ?? 0;
    _scrollController.addListener(_onScroll);
    _getFilteredChallengeList();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels ==
            _scrollController.position.maxScrollExtent &&
        hasMoreData &&
        !isLoading) {
      _getFilteredChallengeList();
    }
  }

  Future<void> _getFilteredChallengeList() async {
    if (!hasMoreData || isLoading) return;

    setState(() {
      isLoading = true;
    });

    ChallengeFilter filter = ChallengeFilter(
      name: _inputName,
      category: _seletedCategoryIndex == 0
          ? null
          : ChallengeCategory.values[_seletedCategoryIndex - 1],
      isPrivate: _isPrivate ? true : null,
    );

    List<ChallengeSimple> newChallengeSimples =
        await ChallengeService.fetchChallengeSimples(
            currentCursor, pageSize, filter);

    setState(() {
      if (newChallengeSimples.isNotEmpty) {
        for (final newChallengeSimple in newChallengeSimples) {
          challengeList.add(newChallengeSimple);
        }
        currentCursor = challengeList.last.id;
      } else {
        hasMoreData = false;
      }
    });

    setState(() {
      isLoading = false;
    });
  }

  void _onSearch(String value) {
    setState(() {
      _inputName = value;
      hasMoreData = true;
      currentCursor = 0;
      challengeList.clear();
      _getFilteredChallengeList();
    });
  }

  void _onCategorySelected(int index) {
    setState(() {
      _seletedCategoryIndex = _seletedCategoryIndex == index ? 0 : index;
      hasMoreData = true;
      currentCursor = 0;
      challengeList.clear();
      _getFilteredChallengeList();
    });
  }

  void _onPrivateToggle(bool value) {
    setState(() {
      _isPrivate = value;
      hasMoreData = true;
      currentCursor = 0;
      challengeList.clear();
      _getFilteredChallengeList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 80,
        backgroundColor: Palette.mainPurple,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Palette.white),
          onPressed: () {
            Get.back();
          },
        ),
        title: Container(
          height: 60,
          padding: const EdgeInsets.all(5.0),
          child: SearchBar(
            onSubmitted: (value) {
              _onSearch(value);
            },
            padding: const WidgetStatePropertyAll<EdgeInsets>(
                EdgeInsets.symmetric(horizontal: 16.0)),
            trailing: const [Icon(Icons.search)],
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: Column(
          children: [
            CategorySelector(
              categoryList: categoryList,
              selectedIndex: _seletedCategoryIndex,
              onCategorySelected: _onCategorySelected,
            ),
            PrivateToggle(
              isPrivate: _isPrivate,
              onToggle: _onPrivateToggle,
            ),
            const SizedBox(height: 5),
            Expanded(
              child: Stack(
                children: [
                  GridView.builder(
                    controller: _scrollController,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 1 / 1.4,
                    ),
                    itemCount: challengeList.length,
                    itemBuilder: (context, index) {
                      return ChallengeItemCard(
                          challengeSimple: challengeList[index]);
                    },
                  ),
                  if (isLoading)
                    const Positioned(
                      bottom: 10,
                      left: 0,
                      right: 0,
                      child: Center(
                        child: CircularProgressIndicator(),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
