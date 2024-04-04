import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:frontend/model/config/palette.dart';
class BodyPart1 extends StatefulWidget {
  final bool? isPublicSelected;
  final bool showAdditionalWidgets;
  final Function(bool, bool) onDisclosureButtonPressed;

  const BodyPart1({
    required this.isPublicSelected,
    required this.showAdditionalWidgets,
    required this.onDisclosureButtonPressed,
  });

  @override
  State<StatefulWidget> createState() => _BodyPart1State();
}

class _BodyPart1State extends State<BodyPart1> {
  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            child: SvgPicture.asset('assets/svgs/create_challenge_level1.svg'),
          ),
          disclosureButton(
            "public",
            "공개",
            "원하는 사람은 누구든지 참여할 수 있어요.",
            Icons.lock_open_rounded,
          ),
          disclosureButton(
            "private",
            "비공개",
            "암호를 아는 사람만 참여할 수 있어요.",
            Icons.lock_outline_rounded,
          ),
          if (widget.showAdditionalWidgets) ...[
            // Show additional widgets when '비공개' button is selected
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
              child: Row(
                children: [
                  const Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                          labelText: '암호',
                          labelStyle: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              fontFamily: 'Pretendard'
                          ),
                          hintText: '루티너 간 공유할 암호를 입력하세요',
                          hintStyle: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w200,
                          )
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  // Add spacing between text field and button
                  ElevatedButton(
                    onPressed: () {
                      // Perform action on confirmation button press
                    },
                    style: ElevatedButton.styleFrom(
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15)
                        )
                    ),
                    child: const Text(
                      '확인',
                      style: TextStyle(fontWeight: FontWeight.bold,
                          color: Palette.mainPurple),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget disclosureButton(
      String isOpened,
      String title,
      String memo,
      IconData iconData,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      height: 120,
      child: ElevatedButton.icon(
        onPressed: () {
          bool isPublic = isOpened == "public";
          bool showWidgets = isOpened == "private";
          widget.onDisclosureButtonPressed(isPublic, showWidgets);
        },
        icon: Icon(
          iconData,
          size: 40,
          color: widget.isPublicSelected == (isOpened == "public")
              ? Palette.mainPurple
              : Colors.black,
        ),
        label: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "$title 챌린지",
                    style: TextStyle(
                      color: widget.isPublicSelected == (isOpened == "public")
                          ? Palette.mainPurple
                          : Colors.black,
                      fontFamily: 'Pretendard',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    memo,
                    style: const TextStyle(
                      fontSize: 10,
                      color: Colors.grey,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        style: ElevatedButton.styleFrom(
          foregroundColor: Palette.mainPurple,
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }
}
