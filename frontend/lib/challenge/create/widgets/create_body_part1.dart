// import 'package:flutter/material.dart';
// import 'package:flutter_svg/svg.dart';
// import 'package:frontend/model/config/palette.dart';
//
// class BodyPart1 extends StatefulWidget {
//   final bool? isPrivateSelected;
//   final Function(bool, String) onPrivateButtonPressed;
//
//   const BodyPart1({
//     required this.isPrivateSelected,
//     required this.onPrivateButtonPressed,
//   });
//
//   @override
//   State<StatefulWidget> createState() => _BodyPart1State();
// }
//
// class _BodyPart1State extends State<BodyPart1> {
//   late String privateCode = '';
//   bool showCodeInput = false; // 코드 입력 창 보여주기 여부
//   late FocusNode _focusNode; // 텍스트 필드의 포커스를 제어하기 위한 FocusNode
//
//   @override
//   void initState() {
//     super.initState();
//     _focusNode = FocusNode(); // FocusNode 초기화
//   }
//
//   @override
//   void dispose() {
//     _focusNode.dispose(); // FocusNode 해제
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return
//   }
//
//   Widget disclosureButton(
//     String isOpened,
//     String title,
//     String memo,
//     IconData iconData,
//   ) {
//     return Container(
//       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
//       height: 120,
//       child: ElevatedButton.icon(
//         onPressed: () {
//           bool isPrivate = isOpened == "private";
//           bool showWidgets = isOpened == "private";
//           widget.onPrivateButtonPressed(isPrivate, privateCode);
//           if (showWidgets) {
//             setState(() {
//               showCodeInput = true; // 코드 입력 창 표시
//             });
//         }else{
//             setState(() {
//               showCodeInput = false; // 코드 입력 창 표시
//             });
//           }
//           },
//         icon: Icon(
//           iconData,
//           size: 40,
//           color: widget.isPrivateSelected == (isOpened == "private")
//               ? Palette.mainPurple
//               : Colors.black,
//         ),
//         label: Container(
//           width: double.infinity,
//           padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
//           child: Row(
//             children: [
//               Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Text(
//                     "$title 챌린지",
//                     style: TextStyle(
//                       color: widget.isPrivateSelected == (isOpened == "private")
//                           ? Palette.mainPurple
//                           : Colors.black,
//                       fontFamily: 'Pretendard',
//                       fontSize: 16,
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   Text(
//                     memo,
//                     style: const TextStyle(
//                       fontSize: 10,
//                       color: Colors.grey,
//                       fontWeight: FontWeight.w300,
//                     ),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//         ),
//         style: ElevatedButton.styleFrom(
//           foregroundColor: Palette.mainPurple,
//           backgroundColor: Colors.white,
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//       ),
//     );
//   }
// }
