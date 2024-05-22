import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:frontend/screens/community/post_detail_screen.dart';
import 'package:frontend/screens/community/widget/post_card_bottom.dart';
import 'package:frontend/screens/community/widget/post_card_top.dart';
import 'package:frontend/env.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/post/post.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PostCard extends StatefulWidget {
  final Post post;
  final bool onPostDetail;
  FocusNode? focusNode;

  PostCard(
      {super.key,
      required this.post,
      this.onPostDetail = false,
      this.focusNode});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  final controller = Get.find<UserController>();
  final logger = Logger();

  late Post _post;
  bool _isFollowing = false;
  bool _isLiked = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    _isLiked = _post.likes.any((like) => like.userId == controller.user.id);
    if( controller.user.id == _post.authorId){ //작성자가 본인이면 following 버튼 비활성화
      _isFollowing = true;
    }
    for (final user in controller.user.following) {
      if (user.friendName == _post.author ) {
        _isFollowing = true;
        break;
      }
    }
  }

  void _handleFollow(bool isFollowing) {
    setState(() {
      _isFollowing = isFollowing;
    });
  }

  Future<void> _handleLike(bool isLiked) async {
    final prefs = await SharedPreferences.getInstance();
    final dio = Dio(
      BaseOptions(
          method: isLiked ? 'POST' : 'DELETE',
          baseUrl: Env.serverUrl,
          receiveTimeout: const Duration(seconds: 3),
          headers: {
            'Content-Type': 'application/json',
            'Authorization': 'Bearer ${prefs.getString('access_token')}',
          }),
    );

    try {
      final response = await dio.request('/posts/${_post.id}/likes');

      if (response.statusCode == 200) {
        logger.d(_isLiked ? '좋아요 취소 성공' : '좋아요 성공');
        setState(() {
          _isLiked = isLiked;
          if (_isLiked) {
            _post.likes.add(Like(userId: controller.user.id));
          } else {
            _post.likes
                .removeWhere((like) => like.userId == controller.user.id);
          }
        });
      } else {
        throw Exception('${response.statusCode}: ${response.statusMessage}');
      }
    } catch (e) {
      logger.e('handleLike 실패: $e');
      Get.snackbar('좋아요 및 취소 실패', '다시 시도해주세요');
    }
  }

  void _handleComment() {
    if (!widget.onPostDetail) {
      Get.to(() => PostDetailScreen(
            post: _post,
            initialScroll: !widget.onPostDetail,
          ));
    } else {
      widget.focusNode?.requestFocus();
    }
  }

  int _countLike() {
    return _post.likes.length;
  }

  int _countComment(List<Comment> comments) {
    int result = comments.length;
    for (final comment in comments) {
      if (comment.children.isNotEmpty) {
        result += _countComment(comment.children);
      }
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          GestureDetector(
            onTap: () {
              if (!widget.onPostDetail) {
                Get.to(() => PostDetailScreen(
                      post: _post,
                      initialScroll: false,
                    ));
              }
            },
            child: Column(
              children: [
                PostCardTop(
                  image: _post.avatar,
                  name: _post.author,
                  createdAt: _post.createdDate,
                  isInitiallyFollowing: _isFollowing,
                  onFollowingChanged: _handleFollow,
                ),
                const SizedBox(height: 10),
                postCardContent(_post.title, _post.content),
                const SizedBox(height: 10),
                postCardImage(_post.image),
              ],
            ),
          ),
          const SizedBox(height: 10),
          PostCardBottom(
            isLiked: _isLiked,
            countLike: _countLike(),
            countComment: _countComment(_post.comments),
            handleLike: _handleLike,
            handleComment: _handleComment,
          ),
        ]));
  }
}

Widget postCardContent(String postTitle, String postText) {
  return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(children: [
        Text(
          postTitle,
          maxLines: 1,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontWeight: FontWeight.bold ,fontFamily: 'Pretendard', fontSize: 16, height: 1.3, // 줄간격 조정
          ),
        ),
        Text(
          postText,
          maxLines: 5,
          textAlign: TextAlign.left,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontFamily: 'Pretendard', fontSize: 12, height: 1.3, // 줄간격 조정
          ),
        )
      ],));
}

Widget postCardImage(String image) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12.0),
    child: Container(
      width: double.infinity,
      color: Colors.grey[200], // 테두리 색상
      child: Image.network(
        image,
        fit: BoxFit.fitWidth,
      ),
    ),
  );
}

String calculateBeforeHours(DateTime uploadTime) {
  DateTime now = DateTime.now();
  Duration difference = now.difference(uploadTime);

  if (difference.inHours >= 24) {
    int days = difference.inDays;
    return '$days 일전';
  } else {
    return '${difference.inHours} 시간전';
  }
}
