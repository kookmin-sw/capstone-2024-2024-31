import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/community/widget/post_card.dart';
import 'package:frontend/community/widget/report_post_btn.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PostDetailScreen extends StatefulWidget {
  const PostDetailScreen({super.key});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  bool _isTapSendCommentBtn = false;
  Timer? _timer;

  final _commentFocusNode = FocusNode();
  final TextEditingController _commentController = TextEditingController();

  late String textFieldHintText;

  @override
  void dispose() {
    _commentFocusNode.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> comment_list = [
    {
      'index': 0,
      'image': 'assets/images/challenge_image.png',
      'nickname': '왕감자통자',
      'dateTime': DateTime(2024, 4, 6, 13, 40),
      'text': '대단합니다.'
    },
    {
      'index': 1,
      'image': 'assets/images/challenge_image.png',
      'nickname': '왕감자13통자',
      'dateTime': DateTime(2024, 4, 6, 13, 40),
      'text': '대단합니다2342.'
    },
    {
      'index': 2,
      'image': 'assets/images/challenge_image.png',
      'nickname': '왕통자',
      'dateTime': DateTime(2024, 4, 9, 13, 40),
      'text': '대단합니다. 어쩌면ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ'
    },
    {
      'index': 3,
      'image': 'assets/images/challenge_image.png',
      'nickname': '왕감자',
      'dateTime': DateTime(2024, 4, 13, 17, 40),
      'text': '대단합니다ㅇㅁㄴㄹㄹ.'
    },
    {
      'index': 4,
      'image': 'assets/images/challenge_image.png',
      'nickname': '왕감통자',
      'dateTime': DateTime(2024, 3, 6, 13, 40),
      'text': '대단ㅁㄴㅁㄴㄻㄴㅇㄻㄴㅇㄹ합니다.'
    },
    {
      'index': 5,
      'image': 'assets/images/challenge_image.png',
      'nickname': '자통자',
      'dateTime': DateTime(2024, 4, 6, 20, 40),
      'text': '대단합ㅁㄴㅇㄻㅇㄴㄹ니다.'
    },
  ];

  List<Map<String, dynamic>> re_comment_list = [
    {
      'index': 0,
      'image': 'assets/images/image.png',
      'nickname': '너비아니',
      'dateTime': DateTime(2024, 4, 6, 18, 40),
      'text': 'ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ.'
    },
    {
      'index': 1,
      'image': 'assets/images/image.png',
      'nickname': '너비아니22222',
      'dateTime': DateTime(2024, 4, 7, 13, 40),
      'text': '대단합니다2342.'
    },
    {
      'index': 1,
      'image': 'assets/images/image.png',
      'nickname': '왕너비아니통slslslls자',
      'dateTime': DateTime(2024, 4, 10, 13, 40),
      'text': '대단합니다. 어쩌면ㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋㅋ'
    },
    {
      'index': 1,
      'image': 'assets/images/image.png',
      'nickname': '왕감너비아니자',
      'dateTime': DateTime(2024, 4, 23, 17, 40),
      'text': '대단합니다ㅇㅁㄴㄹㄹ.'
    },
    {
      'index': 4,
      'image': 'assets/images/image.png',
      'nickname': '왕감통자너비아니',
      'dateTime': DateTime(2024, 3, 6, 13, 40),
      'text': '대단ㅁㄴㅁㄴㄻㄴㅇㄻㄴㅇㄹ합니다.'
    },
    {
      'index': 5,
      'image': 'assets/images/image.png',
      'nickname': '너비아니자통자',
      'dateTime': DateTime(2024, 4, 6, 20, 40),
      'text': '대단합ㅁㄴㅇㄻㅇㄴㄹ니다.'
    },
  ];

  TextStyle name_textStyle = const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: Palette.grey500);

  TextStyle date_textStyle = const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 10,
      fontWeight: FontWeight.w300,
      color: Palette.grey300);

  TextStyle text_textStyle = const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Palette.grey300);

  TextStyle btn_textStyle = const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Palette.grey200);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    textFieldHintText = "댓글을 남겨보세요";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      appBar: AppBar(
        backgroundColor: Palette.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios),
          onPressed: () {
            Get.back();
          },
        ),
        title: const Text(
          '게시글 자세히 보기',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            fontFamily: 'Pretendard',
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {
                repostPostButtonPress(context, 1010, 1010);
              },
              icon: const Icon(
                Icons.report_problem_outlined,
                color: Palette.red,
              ))
        ],
      ),
      bottomNavigationBar: SafeArea(
          child: Padding(
              padding: EdgeInsets.only(
                  left: 15,
                  right: 15,
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: SizedBox(
                height: 70,
                child: Row(
                  children: [
                    Expanded(
                        child: TextFormField(
                      controller: _commentController,
                      focusNode: _commentFocusNode,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                          fontFamily: 'Pretender'),
                      decoration: InputDecoration(
                          hintText: textFieldHintText,
                          hintStyle: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w300,
                            color: Palette.grey200,
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 0, horizontal: 10),
                          filled: true,
                          fillColor: Palette.greySoft,
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12.0),
                              borderSide:
                                  const BorderSide(color: Palette.greySoft)),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12.0),
                            borderSide: const BorderSide(
                                color: Palette.grey50, width: 2),
                          )),
                      validator: (value) =>
                          value!.isEmpty ? textFieldHintText : null,
                    )),
                    const SizedBox(width: 10),
                    GestureDetector(
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: _isTapSendCommentBtn
                                    ? Border.all(
                                        color: Palette.grey50, width: 2.0)
                                    : Border.all(
                                        color: Palette.greyBG, width: 2.0)),
                            child: SvgPicture.asset(
                                "assets/svgs/comment_send_btn.svg")),
                        onTap: () {
                          setState(() {
                            _isTapSendCommentBtn = true;
                          });
                          _timer?.cancel();
                          _timer = Timer(const Duration(milliseconds: 300), () {
                            setState(() {
                              _isTapSendCommentBtn = false;
                            });
                          });
                          _commentController.clear();
                          _commentFocusNode.unfocus();
                        })
                  ],
                ),
              ))),
      body: SingleChildScrollView(
        child: Container(
            color: Palette.greyBG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostCard(number: 10, commentFocusNode: _commentFocusNode),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text(
                        "댓글 ${(comment_list.length + re_comment_list.length)}개",
                        style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontFamily: 'Pretendard',
                            fontSize: 15))),
                Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: commentWidget())
              ],
            )),
      ),
    );
  }

  Widget commentWidget() {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: comment_list.map((comment) {
        List<Widget> commentAndReplies = [];
        String uploadTimeString = formatDate(comment['dateTime']);
        String beforeHours = calculateBeforeHours(comment['dateTime']);

        // Add the main comment
        commentAndReplies.add(
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5),
            child: Container(
              width: size.width,
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20.0),
                // Adjust the radius as needed
                border: Border.all(
                    color: Palette.greySoft), // Add border color here
              ),
              child: Column(
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          const SizedBox(width: 10),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                              comment['image'],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                              width: size.width * 0.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment['nickname'],
                                    style: name_textStyle,
                                  ),
                                  Text(
                                    "$uploadTimeString | $beforeHours",
                                    style: date_textStyle,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    comment['text'],
                                    style: text_textStyle,
                                    softWrap: true,
                                    maxLines: 3,
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    splashColor: Palette.grey50,
                                    child: Text(
                                      "답글 달기",
                                      style: btn_textStyle,
                                    ),
                                    onTap: () {
                                      _commentController.clear();
                                      _commentFocusNode
                                          .requestFocus(); // 포커스 요청
                                    },
                                  ),
                                ],
                              )),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 5),
                  ...re_comment_list
                      .where((reply) => reply['index'] == comment['index'])
                      .map((reply) {
                    String reUploadTimeString = formatDate(reply['dateTime']);
                    String reBeforeHours =
                        calculateBeforeHours(reply['dateTime']);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SizedBox(width: 50),
                          CircleAvatar(
                            radius: 20,
                            backgroundImage: AssetImage(
                              reply['image'],
                            ),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                              width: size.width * 0.5,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    reply['nickname'],
                                    style: name_textStyle,
                                  ),
                                  Text(
                                    "$reUploadTimeString | $reBeforeHours",
                                    style: date_textStyle,
                                  ),
                                  const SizedBox(height: 5),
                                  Text(
                                    reply['text'],
                                    softWrap: true,
                                    maxLines: 3,
                                    overflow: TextOverflow.visible,
                                    style: text_textStyle,
                                  ),
                                ],
                              )),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),
        );
        return Column(
          children: commentAndReplies,
        );
      }).toList(),
    );
  }

  String formatDate(DateTime dateTime) {
    return DateFormat('yyyy.MM.dd').format(dateTime);
  }

  String calculateBeforeHours(DateTime dateTime) {
    Duration difference = DateTime.now().difference(dateTime);
    if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }
}
