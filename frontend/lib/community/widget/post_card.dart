import 'package:flutter/material.dart';
import 'package:frontend/community/widget/post_button_widget.dart';
import 'package:frontend/community/widget/post_top.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/controller/user_controller.dart';
import 'package:frontend/model/data/post/post.dart';
import 'package:get/get.dart';

class PostCard extends StatefulWidget {
  final FocusNode? commentFocusNode;
  final Post post;

  const PostCard({super.key, required this.post, this.commentFocusNode});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  late Post post;
  bool isFollowing = false;

  final controller = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    post = widget.post;
    for (final user in controller.user.following) {
      if (user.friendName == post.author) {
        isFollowing = true;
        break;
      }
    }
  }

  void handleFollowingChanged(bool isFollowing) {
    setState(() {
      this.isFollowing = isFollowing;
    });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {

        // widget.commentFocusNode != null
        //     ? null
        //     : Get.to(() => const PostDetailScreen());
      },
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                PostTopWidget(
                  image: post.image,
                  name: post.author,
                  createdAt: post.createdDate,
                  isInitiallyFollowing: isFollowing,
                  onFollowingChanged: handleFollowingChanged,
                ),
                const SizedBox(height: 10),
                post_text(post.content),
                const SizedBox(height: 17),
                post_image(post.image),
                const SizedBox(height: 20),
                widget.commentFocusNode == null
                    ? PostBtnWidget(
                        likeNum: post.likes.length,
                        commentNum: post.comments.length,
                      )
                    : PostBtnWidget(
                        likeNum: post.likes.length,
                        commentNum: post.comments.length,
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

Widget post_text(String postText) {
  return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        postText,
        maxLines: 5,
        textAlign: TextAlign.left,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontFamily: 'Pretendard', fontSize: 12, height: 1.3, // 줄간격 조정
        ),
      ));
}

Widget post_image(String image) {
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
