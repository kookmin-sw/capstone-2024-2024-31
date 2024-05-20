
import 'package:flutter/material.dart';
import 'package:frontend/community/widget/post_card.dart';
import 'package:frontend/community/widget/report_post_btn.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';

import '../model/data/post/post.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final bool initialScroll;

  const PostDetailScreen(
      {super.key, required this.post, this.initialScroll = false});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentFocusNode = FocusNode();

  late Post _post;

  String _inputComment = '';

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    if (widget.initialScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _commentFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _commentFocusNode.dispose();
    super.dispose();
  }

  TextStyle postNameTextStyle = const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 10,
      fontWeight: FontWeight.w600,
      color: Palette.grey500);

  TextStyle postDateTextStyle = const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 10,
      fontWeight: FontWeight.w300,
      color: Palette.grey300);

  TextStyle postContentTextStyle = const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12,
      fontWeight: FontWeight.bold,
      color: Palette.grey300);

  TextStyle postButtonTextStyle = const TextStyle(
      fontFamily: 'Pretendard',
      fontSize: 12,
      fontWeight: FontWeight.w500,
      color: Palette.grey200);

  int _calculateCommentLength(List<Comment> comments) {
    int result = comments.length;
    for (final comment in comments) {
      if (comment.children.isNotEmpty) {
        result += _calculateCommentLength(comment.children);
      }
    }
    return result;
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
                        child: TextField(
                      scrollPadding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).viewInsets.bottom),
                      focusNode: _commentFocusNode,
                      style: const TextStyle(
                          fontWeight: FontWeight.w300,
                          fontSize: 11,
                          fontFamily: 'Pretender'),
                      decoration: InputDecoration(
                          hintText: "댓글을 입력해주세요.",
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
                      onChanged: (value) => setState(() {
                        _inputComment = value;
                      }),
                    )),
                    const SizedBox(width: 10),
                    GestureDetector(
                        child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                    color: Palette.grey50, width: 2.0)),
                            child: Icon(Icons.send,
                                color: _inputComment.isEmpty
                                    ? Palette.grey200
                                    : Palette.mainPurple)),
                        onTap: () {
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
                PostCard(
                  post: _post,
                  onPostDetail: true,
                  focusNode: _commentFocusNode,
                ),
                Padding(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
                    child: Text("댓글 ${_countComment(_post.comments)}개",
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
      children: _post.comments.map((comment) {
        List<Widget> commentAndReplies = [];
        String uploadTimeString = comment.createdDate;
        String beforeHours = _calculateBeforeHours(comment.createdDate);

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
                            backgroundImage: NetworkImage(comment.avatar),
                          ),
                          const SizedBox(width: 12),
                          SizedBox(
                              width: size.width * 0.6,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    comment.author,
                                    style: postNameTextStyle,
                                  ),
                                  Text(
                                    "$uploadTimeString | $beforeHours",
                                    style: postDateTextStyle,
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    comment.content,
                                    style: postContentTextStyle,
                                    softWrap: true,
                                    maxLines: 3,
                                    overflow: TextOverflow.visible,
                                  ),
                                  const SizedBox(height: 8),
                                  InkWell(
                                    splashColor: Palette.grey50,
                                    child: Text(
                                      "답글 달기",
                                      style: postButtonTextStyle,
                                    ),
                                    onTap: () {
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
                  if (comment.children.isNotEmpty)
                    ...comment.children.map<Widget>((childComment) {
                      String childUploadTimeString = childComment.createdDate;
                      String childBeforeHours =
                          _calculateBeforeHours(childUploadTimeString);
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const SizedBox(width: 50),
                            CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(childComment.avatar),
                            ),
                            const SizedBox(width: 12),
                            SizedBox(
                                width: size.width * 0.5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      childComment.author,
                                      style: postNameTextStyle,
                                    ),
                                    Text(
                                      "$childUploadTimeString | $childBeforeHours",
                                      style: postDateTextStyle,
                                    ),
                                    const SizedBox(height: 5),
                                    Text(
                                      childComment.content,
                                      softWrap: true,
                                      maxLines: 3,
                                      overflow: TextOverflow.visible,
                                      style: postContentTextStyle,
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

  int _countComment(List<Comment> comments) {
    int result = comments.length;
    for (final comment in comments) {
      if (comment.children.isNotEmpty) {
        result += _countComment(comment.children);
      }
    }
    return result;
  }

  String _calculateBeforeHours(String dateTimeStr) {
    DateTime dateTime = DateTime.parse(dateTimeStr);
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
