import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/community/widget/post_card.dart';
import 'package:frontend/main/main_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';
import 'package:frontend/model/data/post.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../env.dart';
import '../model/data/post/post.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen(
      {super.key,
      this.isFromCreatePostingScreen = false,
      required this.challengeId});

  final bool isFromCreatePostingScreen;
  final int challengeId;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  final logger = Logger();
  bool isLoading = false;
  List<Post> posts = [];
  int _sortIndex = 0; // 정렬 방식 인덱스

  Future<List<Post>> _fetchPosts(int challengeId) async {
    final Dio dio = Dio();
    final String url = '${Env.serverUrl}/challenges/$challengeId/posts';
    logger.d("111111111111111111111111111111111111");

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Post> posts = data.map((item) => Post.fromJson(item)).toList();

        logger.d("response.data: ${response.data}");
        return posts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load posts');
    }
  }

  @override
  void initState() {
    super.initState();
    _loadPosts();
  }

  Future<void> _loadPosts() async {
    setState(() {
      isLoading = true;
    });

    try {
      List<Post> fetchedPosts = await _fetchPosts(widget.challengeId);
      setState(() {
        posts = fetchedPosts;
        _sortPosts(); // Sort posts initially based on the default sort index
        logger.d("posts: ${posts.toString()}");
      });
    } catch (e) {
      logger.e('Failed to load posts: $e');
      // Optionally show an error message to the user
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  void _sortPosts() {
    if (_sortIndex == 0) {
      posts.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    } else if (_sortIndex == 1) {
      posts.sort((a, b) => b.likes.length.compareTo(a.likes.length));
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  final _selectedButtonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26.0),
      ),
      foregroundColor: Palette.white,
      backgroundColor: Palette.purPle400,
      disabledBackgroundColor: Palette.greySoft,
      disabledForegroundColor: Colors.white,
      minimumSize: const Size(60, 36));

  final _unselectedButtonStyle = ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        side: BorderSide.none,
        borderRadius: BorderRadius.circular(20.0),
      ),
      foregroundColor: Palette.grey200,
      backgroundColor: Palette.greySoft,
      shadowColor: Colors.transparent,
      minimumSize: const Size(60, 36));

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Palette.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            widget.isFromCreatePostingScreen
                ? Get.to(() => MainScreen())
                : Get.back();
          },
        ),
        title: const Text(
          "인증 커뮤니티",
          style: TextStyle(
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold,
              fontSize: 16),
        ),
      ),
      body: isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Palette.mainPurple))
          : Column(
              children: [
                _buildSortButtons(),
                Expanded(
                  child: ListView.builder(
                      itemCount: posts.length,
                      itemBuilder: (BuildContext context, int index) {
                        return PostCard(post: posts[index]);
                      }),
                ),
              ],
            ),
    );
  }

  Widget _buildSortButtons() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      color: Palette.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          ElevatedButton(
            onPressed: () {
              setState(() {
                _sortIndex = 0;
                _sortPosts();
              });
            },
            style:
                _sortIndex == 0 ? _selectedButtonStyle : _unselectedButtonStyle,
            child: const Text(
              '최신순',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Pretendard',
                  fontSize: 12),
            ),
          ),
          const SizedBox(width: 10),
          ElevatedButton(
            onPressed: () {
              setState(() {
                _sortIndex = 1;
                _sortPosts();
              });
            },
            style:
                _sortIndex == 1 ? _selectedButtonStyle : _unselectedButtonStyle,
            child: const Text(
              '인기순',
              style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontFamily: 'Pretendard',
                  fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }
}
