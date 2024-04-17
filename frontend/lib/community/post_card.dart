import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/community/widget/post_button_widget.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';

class PostCard extends StatefulWidget {
  int number;

  PostCard({required this.number, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  bool isLiked = false;
  int likeNum = 19;
  int commentNum = 1;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Column(children: [
      Container(
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 15),
        child: Column(
          children: [
            post_top('assets/images/24.png', "챌린지장인",
                DateTime(2024, 4, 4, 9, 23, 40)),
            const SizedBox(height: 10),
            post_text(
                "오늘도 인증 완료입니다 아니근데 진짜 오늘 개 힘들었는데 그ㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴㄴ래서 지금 이게 5줄이 넘을지 모르겟쯘올ㅇ"),
            const SizedBox(height: 17),
            post_image('assets/images/challenge_image.png'),
            const SizedBox(height: 20),
            PostBtnWidget(likeNum: likeNum, commentNum: commentNum),
            const SizedBox(height: 15),
          ],
        ),
      ),
      Divider(thickness: 5, height: 15, color: Palette.greySoft),
    ]);
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
          Image.asset(
            image,
            width: 35,
          ),
          SizedBox(width: 8), // Add some space between the image and text
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              name,
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 14,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            Text(
              uploadTimeString,
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 11,
                  color: Palette.grey200),
            ),
          ]),
        ],
      ),
      Text(
        '${BeforeHours}',
        style: TextStyle(
            fontFamily: 'Pretendard', fontSize: 10, color: Palette.grey200),
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
    borderRadius: BorderRadius.circular(20.0),
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
