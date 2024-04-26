import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';

class PostCard extends StatefulWidget {
  int number;

  PostCard({required this.number, super.key});

  @override
  State<PostCard> createState() => _PostCardState();
}

class _PostCardState extends State<PostCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      child: Column(
        children: [
          post_top(
              'assets/images/24.png', "챌린지장인", DateTime(2024, 4, 4, 9, 23, 40)),
          post_text("오늘도 인증 완료입니다"),
          post_image('assets/images/challenge_image.png'),
          SizedBox(height: 10),
          post_bottom_actionButtons()
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
          Image.asset(image),
          SizedBox(width: 8), // Add some space between the image and text
          Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(
              name,
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 15, color: Colors.black,
              fontWeight: FontWeight.w500),
            ),
            Text(
              uploadTimeString,
              style: TextStyle(
                  fontFamily: 'Pretendard',
                  fontSize: 12,
                  color: Palette.grey200),
            ),
          ]),
        ],
      ),
      Text(
        '${BeforeHours}',
        style: TextStyle(
            fontFamily: 'Pretendard', fontSize: 12, color: Palette.grey200),
      ),
    ],
  );
}

Widget post_text(String post_text){
  return Container(
    width: double.infinity,
    padding: EdgeInsets.symmetric(vertical: 10),
    child: Text(
      post_text,
      textAlign: TextAlign.left,
      style: TextStyle(fontFamily: 'Pretendard', fontSize: 14),
    ),
  );
}

Widget post_image(String image){
  return Container(
    width: double.infinity,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(50.0), // 테두리를 둥글게 만듦
      color: Colors.grey[200], // 이미지의 배경색 (테두리 색상)
    ),
    child: Image.asset(
      image, // 이미지 경로
      fit: BoxFit.fitWidth, // 이미지를 테두리에 맞게 조절
    ),
  );

}


Widget post_bottom_actionButtons() {
  return Container(
    padding: EdgeInsets.symmetric(vertical: 2),
    decoration: BoxDecoration(
      color: Palette.grey50,
      border: Border.all(color: Colors.transparent), // 버튼 영역에 테두리 추가
      borderRadius: BorderRadius.circular(15.0), // 테두리를 둥글게 만듦
    ),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly, // 버튼을 수평으로 고르게 정렬
      children: [
        IconButton(
          onPressed: () {
            // 좋아요 버튼 동작
          },
          icon: Icon(Icons.thumb_up), // 좋아요 아이콘
        ),
        VerticalDivider(color: Colors.grey), // 첫 번째 버튼과 두 번째 버튼 사이에 세로 선 추가
        IconButton(
          onPressed: () {
            // 댓글 버튼 동작
          },
          icon: Icon(Icons.comment), // 댓글 아이콘
        ),
        VerticalDivider(color: Colors.black), // 첫 번째 버튼과 두 번째 버튼 사이에 세로 선 추가
        IconButton(
          onPressed: () {
            // 공유 버튼 동작
          },
          icon: Icon(Icons.share), // 공유 아이콘
        ),
      ],
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
