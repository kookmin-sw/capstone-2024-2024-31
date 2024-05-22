import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/config/palette.dart';

class BuildImageContainer extends StatelessWidget {
  final String path;
  final Color color;
  final bool isSuccess;
  final Size screenSize;
  final bool isJoinScreen;

  const BuildImageContainer(
      {super.key,
      required this.path,
      required this.color,
      required this.isSuccess,
      required this.screenSize,
      this.isJoinScreen = false});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (isJoinScreen) Container(),
        if (!isJoinScreen)
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                isSuccess
                    ? 'assets/svgs/check_green.svg'
                    : 'assets/svgs/check_red.svg',
              ),
              const SizedBox(width: 3),
              Text(
                isSuccess ? "성공 예시" : "실패 예시",
                style: const TextStyle(
                    fontFamily: 'Pretendard',
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: Palette.grey500),
              ),
            ],
          ),
        const SizedBox(height: 5),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32.0),
            border: Border.all(
              color: color,
              width: 2.0,
            ),
          ),
          width: isJoinScreen ? screenSize.width * 0.9 : screenSize.width * 0.4,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(30.0),
            child: isJoinScreen
                ? Image.asset(
                    path,
                    fit: BoxFit.fill,
              height: screenSize.height * 0.20,
                  )
                : Image.network(
                    path,
                    fit: BoxFit.fill,
              height: screenSize.height * 0.20,

            ),
          ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
