import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/community/post_detail_screen.dart';
import 'package:frontend/community/widget/post_button_widget.dart';
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

  PostCard({required this.number, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return InkWell(
      onTap: () {
        // 게시물 상세 정보 페이지로 이동하는 코드 추가
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) =>
                PostDetailPage(), // PostDetailPage는 상세 정보 페이지의 이름입니다.
          ),
        );
      },
      child: Column(
        children: [
          Container(
            color: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
            child: Column(
              children: [
                post_top(PostCard.imageUrl, PostCard.userName,
                    DateTime(2024, 4, 4, 9, 23, 40)),
                const SizedBox(height: 10),
                post_text(PostCard.postText),
                const SizedBox(height: 17),
                post_image(PostCard.authImage),
                const SizedBox(height: 20),
                PostBtnWidget(
                    likeNum: PostCard.likeNum, commentNum: PostCard.commentNum),
                const SizedBox(height: 15),
              ],
            ),
          ),
          const Divider(height: 0, thickness: 7, color: Palette.greySoft, indent: 0, endIndent: 0),
        ],
      ),
    );
  }
}

Widget post_top(String image, String name, DateTime uploadTime) {
  String uploadTimeString = formatDate(uploadTime);
  String BeforeHours = calculateBeforeHours(uploadTime);

  return Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: AssetImage(image),
          ),
          const SizedBox(width: 13), // Add some space between the image and text
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              name,
              style: const TextStyle(
                  fontFamily: 'Pretender',
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              uploadTimeString,
              style: const TextStyle(
                  fontFamily: 'Pretender',
                  fontSize: 11,
                  color: Palette.grey200),
            ),
          ]),
        ],
      ),
      Text(
        '${BeforeHours}',
        style: const TextStyle(
            fontFamily: 'Pretender', fontSize: 10, color: Palette.grey200),
      ),
    ],
  );
}

Widget post_text(String post_text) {
  return Text(
    post_text,
    maxLines: 5,
    textAlign: TextAlign.left,
    overflow: TextOverflow.ellipsis,
    style: TextStyle(
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
