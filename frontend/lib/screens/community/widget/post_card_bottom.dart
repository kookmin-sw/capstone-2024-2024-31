import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';

class PostCardBottom extends StatelessWidget {
  final bool isLiked;
  final int countLike;
  final int countComment;
  final Function handleLike;
  final Function handleComment;

  const PostCardBottom({
    super.key,
    required this.isLiked,
    required this.countLike,
    required this.countComment,
    required this.handleLike,
    required this.handleComment,
  });

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
            icon: Icon(
              Icons.favorite,
              color: isLiked ? Palette.mainPurple : Palette.black,
            ),
            text: countLike.toString(),
            onPressed: () {
              handleLike(!isLiked);
            },
          ),
          _buildButtonWithText(
            icon: const Icon(Icons.mode_comment_outlined),
            text: countComment.toString(),
            onPressed: () {
              handleComment();
            },
          ),
          _buildButtonWithText(
            icon: const Icon(Icons.share),
            text: "공유",
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildButtonWithText({
    required Icon icon,
    required String text,
    required Function onPressed,
  }) {
    return Material(
      clipBehavior: Clip.none,
      color: Palette.greySoft,
      child: InkWell(
        onTap: () => onPressed(),
        focusColor: Palette.purPle100,
        customBorder: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            icon,
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
