import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/community/post_detail_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';

class PostBtnWidget extends StatefulWidget {
  int likeNum;
  int commentNum;
  final FocusNode? commentFocusNode;

  PostBtnWidget({
    super.key,
    required this.likeNum,
    required this.commentNum,
    this.commentFocusNode,
  });

  @override
  _PostBtnWidgetState createState() => _PostBtnWidgetState();
}

class _PostBtnWidgetState extends State<PostBtnWidget> {
  bool isLiked = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: Palette.greySoft,
        border: Border.all(color: Colors.transparent),
        borderRadius: BorderRadius.circular(15.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildButtonWithText(
            svgPicturePath: "assets/svgs/icon_like.svg",
            text: widget.likeNum.toString(),
            isLikeBtn: true,
            onPressed: () {
              setState(() {
                _handleLike();
              });
            },
          ),
          _buildButtonWithText(
            isLikeBtn: false,
            svgPicturePath: "assets/svgs/icon_comment.svg",
            text: widget.commentNum.toString(),
            onPressed: () {
             widget.commentFocusNode == null
                  ? Get.to(() => const PostDetailPage())
                  : widget.commentFocusNode?.requestFocus();
            },
          ),
          _buildButtonWithText(
            isLikeBtn: false,
            svgPicturePath: "assets/svgs/icon_share.svg",
            text: "공유",
            onPressed: () {
              // 공유 버튼 동작
            },
          ),
        ],
      ),
    );
  }

  void _handleLike() {
    setState(() {
      if (isLiked) {
        widget.likeNum--;
      } else {
        widget.likeNum++;
      }
      isLiked = !isLiked;
    });
  }

  Widget _buildButtonWithText({
    required String svgPicturePath,
    required String text,
    required bool isLikeBtn,
    required VoidCallback? onPressed,
  }) {
    return Material(
      clipBehavior: Clip.none,
      color: Palette.greySoft,
      child: InkWell(
        onTap: onPressed,
        focusColor: Palette.purPle100,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            isLikeBtn
                ? SvgPicture.asset(
                    svgPicturePath,
                    color: isLiked ? Palette.mainPurple : null,
                  )
                : SvgPicture.asset(svgPicturePath),
            const SizedBox(width: 7),
            Text(
              text,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 11,
                fontFamily: 'Pretendard',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
