import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/community/post_detail_screen.dart';
import 'package:frontend/community/widget/follow_btn.dart';
import 'package:frontend/community/widget/post_button_widget.dart';
import 'package:frontend/community/widget/post_top.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';

class PostCard extends StatefulWidget {
  int number;
  static bool isLiked = false;
  static int likeNum = 19;
  static int commentNum = 1;
  static String imageUrl = 'assets/images/image.png';
  static String userName = '챌린지장인';
  static String postText = "ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ래서 지금 이게 5줄이 넘을지 모르겟쯘올ㅇ";
  static String authImage = 'assets/images/challenge_image.png';
  final FocusNode? commentFocusNode;

  PostCard({required this.number, super.key, this.commentFocusNode});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isFollowing = false;

  void handleFollowingChanged(bool newFollowingStatus) {
    setState(() {
      isFollowing = newFollowingStatus;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        // 게시물 상세 정보 페이지로 이동하는 코드 추가
        widget.commentFocusNode != null
            ? null
            : Get.to(() => const PostDetailPage());
      },
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                PostTopWidget(
                  image: PostCard.imageUrl,
                  name: PostCard.userName,
                  uploadTime: DateTime(2024, 5, 15),
                  isInitiallyFollowing: isFollowing,
                  onFollowingChanged: handleFollowingChanged,
                ),
                const SizedBox(height: 10),
                post_text(PostCard.postText),
                const SizedBox(height: 17),
                post_image(PostCard.authImage),
                const SizedBox(height: 20),
                widget.commentFocusNode == null
                    ? PostBtnWidget(
                        likeNum: PostCard.likeNum,
                        commentNum: PostCard.commentNum,
                      )
                    : PostBtnWidget(
                        likeNum: PostCard.likeNum,
                        commentNum: PostCard.commentNum,
                        commentFocusNode: widget.commentFocusNode),
                const SizedBox(height: 15),
              ],
            ),
          ),
          const Divider(
              height: 0,
              thickness: 7,
              color: Palette.greySoft,
              indent: 0,
              endIndent: 0),
        ],
      ),
    );
  }
}

Widget post_text(String post_text) {
  return Text(
    post_text,
    maxLines: 5,
    textAlign: TextAlign.left,
    overflow: TextOverflow.ellipsis,
    style: const TextStyle(
      fontFamily: 'Pretendard', fontSize: 12, height: 1.3, // 줄간격 조정
    ),
  );
}

Widget post_image(String image) {
  return ClipRRect(
    borderRadius: BorderRadius.circular(12.0),
    child: Container(
      width: double.infinity,
      color: Colors.grey[200], // 테두리 색상
      child: Image.asset(
        image,
        fit: BoxFit.fitWidth,
      ),
    ),
  );
}

String formatDate(DateTime dateTime) {
  return "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
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
