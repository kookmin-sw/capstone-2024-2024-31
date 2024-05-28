// import 'package:flutter/material.dart';
// import 'package:frontend/model/config/palette.dart';
//
// class FollowButton extends StatefulWidget {
//   FollowButton( {super.key, required this.isFollowing});
//
//   bool isFollowing;
//
//   @override
//   State<FollowButton> createState() => _FollowButtonState();
// }
//
// class _FollowButtonState extends State<FollowButton> {
//
//   ButtonStyle followBtnStyle(
//       Color backgroundColor, Color borderColor, Color textColor) =>
//       ButtonStyle(
//         textStyle: MaterialStateProperty.all<TextStyle>(TextStyle(
//             fontFamily: 'Pretender',
//             fontSize: 12,
//             color: textColor,
//             fontWeight: FontWeight.bold)),
//         padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
//             const EdgeInsets.symmetric(horizontal: 10)),
//         shape: MaterialStateProperty.all<OutlinedBorder>(
//           RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(15),
//               side: BorderSide(color: borderColor, width: 2)),
//         ),
//         backgroundColor: MaterialStateProperty.all<Color>(backgroundColor),
//       );
//
//
//   @override
//   Widget build(BuildContext context) {
//     return  ElevatedButton(
//       onPressed: () {
//         isFollowing = != isFollowing;
//       },
//       style: widget.isFollowing
//           ? followBtnStyle(Palette.greyBG, Palette.greyBG, Palette.grey500)
//           : followBtnStyle(Palette.white, Palette.white, Palette.purPle400),
//       child: Text(widget.isFollowing ? "팔로잉" : "팔로우"),
//     );
//   }
// }
