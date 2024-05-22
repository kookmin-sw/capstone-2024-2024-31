import 'package:flutter/material.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:frontend/screens/community/create_posting_screen.dart';
import 'package:frontend/screens/community/widget/post_card.dart';
import 'package:frontend/screens/main/main_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge_simple.dart';
import 'package:frontend/service/post_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:frontend/model/controller/user_controller.dart';
import '../../model/data/post/post.dart';

class CommunityScreen extends StatefulWidget {
  const CommunityScreen(
      {super.key,
      this.isFromCreatePostingScreen = false,
      required this.challenge});

  final Challenge challenge;
  final bool isFromCreatePostingScreen;

  @override
  State<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends State<CommunityScreen>
    with TickerProviderStateMixin {
  final logger = Logger();
  final controller = Get.find<UserController>();

  late bool isPossibleCreateButtonClick;
  late Challenge _challenge;
  List<Post> _posts = [];
  bool _isLoading = false;
  int _sortIndex = 0; // 정렬 방식 인덱스

  @override
  void initState() {
    super.initState();
    _challenge = widget.challenge;

    _initialize();
  }

  Future<void> _initialize() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final posts = await PostService.fetchPosts(_challenge.id);
      setState(() {
        _posts = posts;
        _sortPosts();
      });

      isPossibleCreateButtonClick =
          await PostService.checkPossibleCommunityCertification(
              _posts, controller.user.id);
    } catch (e) {
      // Handle errors if necessary
      print("Error during initialization: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _sortPosts() {
    if (_sortIndex == 0) {
      _posts.sort((a, b) => b.createdDate.compareTo(a.createdDate));
    } else if (_sortIndex == 1) {
      _posts.sort((a, b) => b.likes.length.compareTo(a.likes.length));
    }
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
                ? Get.to(() => const MainScreen(
                      tabNumber: 0,
                    ))
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
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              isPossibleCreateButtonClick
                  ? Get.to(CreatePostingScreen(challenge: _challenge))
                  : Get.snackbar("오늘은 인증이 완료된 챌린지입니다.", "1일 1회 인증 가능합니다.");
            },
          ),
        ],
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Palette.mainPurple))
          : Column(
              children: [
                _buildSortButtons(),
                Expanded(
                  child: ListView.separated(
                    itemCount: _posts.length,
                    itemBuilder: (BuildContext context, int index) {
                      return PostCard(post: _posts[index]);
                    },
                    separatorBuilder: (BuildContext context, int index) {
                      return const Divider(
                        height: 1,
                        color: Palette.greySoft,
                      );
                    },
                  ),
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
