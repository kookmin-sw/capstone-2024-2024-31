import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:get/get.dart';

class PostTopWidget extends StatefulWidget {
  final String image;
  final String name;
  final String createdAt;
  final bool isInitiallyFollowing;
  final ValueChanged<bool> onFollowingChanged; // Callback to notify the parent

  const PostTopWidget({
    super.key,
    required this.image,
    required this.name,
    required this.createdAt,
    required this.isInitiallyFollowing,
    required this.onFollowingChanged,
  });

  @override
  _PostTopWidgetState createState() => _PostTopWidgetState();
}

class _PostTopWidgetState extends State<PostTopWidget> {
  late bool isFollowing;

  @override
  void initState() {
    super.initState();
    isFollowing = widget.isInitiallyFollowing;
  }

  void toggleFollowing() {
    setState(() {
      isFollowing = !isFollowing;
      widget.onFollowingChanged(isFollowing); // Notify the parent
    });
  }

  @override
  Widget build(BuildContext context) {
    String uploadTimeString = widget.createdAt;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundImage: NetworkImage(widget.image),
            ),
            const SizedBox(width: 13),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.name,
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
              ],
            ),
          ],
        ),
        GestureDetector(
          onTap: () {
            isFollowing
                ? Get.snackbar("팔로우", "취소되었습니다.",
                    duration: const Duration(seconds: 1))
                : Get.snackbar("팔로우", "성공했습니다.",
                    duration: const Duration(seconds: 1));

            toggleFollowing(); // Use the new toggle function
          },
          child: SvgPicture.asset(isFollowing
              ? "assets/svgs/follow_disable_btn.svg"
              : "assets/svgs/follow_able_btn.svg"),
        )
      ],
    );
  }

  String formatDate(DateTime dateTime) {
    return "${dateTime.year}.${dateTime.month.toString().padLeft(2, '0')}.${dateTime.day.toString().padLeft(2, '0')}";
  }
}
