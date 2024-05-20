import 'package:flutter/material.dart';
import 'package:frontend/screens/community/widget/post_card.dart';
import 'package:frontend/screens/community/widget/report_post_btn.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/service/post_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../model/data/post/post.dart';

class PostDetailScreen extends StatefulWidget {
  final Post post;
  final bool initialScroll;

  const PostDetailScreen(
      {super.key, required this.post, this.initialScroll = false});

  @override
  State<PostDetailScreen> createState() => _PostDetailScreenState();
}

class _PostDetailScreenState extends State<PostDetailScreen> {
  final _commentInputFocusNode = FocusNode();
  final logger = Logger();

  late Post _post;

  String _inputComment = '';
  final _textFieldController = TextEditingController();
  int _replyCommentId = 0;
  String _replyAuthor = '';
  bool _isreplayAurhorVisible = false;

  @override
  void initState() {
    super.initState();
    _post = widget.post;
    if (widget.initialScroll) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _commentInputFocusNode.requestFocus();
      });
    }
  }

  @override
  void dispose() {
    _commentInputFocusNode.dispose();
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
            bottom: 10 + MediaQuery.of(context).viewInsets.bottom,
            top: 10),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          Row(crossAxisAlignment: CrossAxisAlignment.center, children: [
            Visibility(
                visible: _isreplayAurhorVisible,
                child: Container(
                  padding: const EdgeInsets.only(top: 10),
                  height: 25,
                  child: Row(children: [
                    RichText(
                        text: TextSpan(
                      children: [
                        TextSpan(
                            text: _replyAuthor,
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pretendard',
                              color: Palette.grey300,
                            )),
                        const TextSpan(
                            text: '님께 답글을 달고있어요.',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w200,
                              fontFamily: 'Pretendard',
                              color: Palette.grey300,
                            ))
                      ],
                    )),
                    GestureDetector(
                      child: const Icon(
                        Icons.close,
                        color: Palette.red,
                        size: 15,
                      ),
                      onTap: () {
                        setState(() {
                          _isreplayAurhorVisible = false;
                          _replyAuthor = '';
                          _replyCommentId = 0;
                        });
                      },
                    )
                  ]),
                )),
          ]),
          _isreplayAurhorVisible
              ? const Column(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    Divider(
                      height: 1,
                      color: Palette.greySoft,
                      thickness: 1,
                    ),
                    SizedBox(
                      height: 5,
                    ),
                  ],
                )
              : const SizedBox.shrink(),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: _textFieldController,
                scrollPadding: EdgeInsets.only(
                    bottom: MediaQuery.of(context).viewInsets.bottom),
                focusNode: _commentInputFocusNode,
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
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                    filled: true,
                    fillColor: Palette.greySoft,
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12.0),
                        borderSide: const BorderSide(color: Palette.greySoft)),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12.0),
                      borderSide:
                          const BorderSide(color: Palette.grey50, width: 2),
                    )),
                onChanged: (value) => setState(() {
                  _inputComment = value;
                }),
              )),
              const SizedBox(width: 10),
              GestureDetector(
                  child: Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border:
                              Border.all(color: Palette.grey50, width: 2.0)),
                      child: Icon(Icons.send,
                          color: _inputComment.isEmpty
                              ? Palette.grey200
                              : Palette.mainPurple)),
                  onTap: () {
                    PostService.createComment(_post.id, _inputComment,
                            _isreplayAurhorVisible ? _replyCommentId : null)
                        .then((comment) {
                      setState(() {
                        if (comment.parentId != null) {
                          for (final c in _post.comments) {
                            if (c.id == comment.parentId) {
                              c.children.add(comment);
                              break;
                            }
                          }
                        } else {
                          _post.comments.add(comment);
                        }
                      });
                    }).catchError((err) {
                      logger.e(err);
                      Get.snackbar('댓글 생성 실패', '다시 시도해주세요');
                    }).whenComplete(() {
                      setState(() {
                        _inputComment = '';
                        _textFieldController.clear();
                        _replyCommentId = 0;
                        _replyAuthor = '';
                        _isreplayAurhorVisible = false;
                      });
                      _commentInputFocusNode.unfocus();
                    });
                  })
            ],
          )
        ]),
      )),
      body: SingleChildScrollView(
        child: Container(
            color: Palette.greyBG,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PostCard(
                  post: _post,
                  onPostDetail: true,
                  focusNode: _commentInputFocusNode,
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
                                      _commentInputFocusNode
                                          .requestFocus(); // 포커스 요청
                                      setState(() {
                                        _replyCommentId = comment.id;
                                        _replyAuthor = comment.author;
                                        _isreplayAurhorVisible = true;
                                      });
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
