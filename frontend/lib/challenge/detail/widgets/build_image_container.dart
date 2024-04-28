import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/model/config/palette.dart';
import 'dart:io';

class BuildImageContainer extends StatelessWidget {
  final String path;
  final Color color;
  final bool isSuccess;
  final Size screenSize;
  final bool isJoinScreen;

  const BuildImageContainer(
      {Key? key,
      required this.path,
      required this.color,
      required this.isSuccess,
      required this.screenSize,
      this.isJoinScreen = false})
      : super(key: key);

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
          padding: EdgeInsets.symmetric(horizontal: 0, vertical: 3),
          decoration: BoxDecoration(
            color: Palette.white,
            borderRadius: BorderRadius.circular(33.0),
            border: Border.all(
              color: path != null ? color : Palette.greySoft,
              width: 2.0,
            ),
          ),
          width: isJoinScreen ? screenSize.width * 0.9 : screenSize.width * 0.4,
          height: isJoinScreen ? screenSize.height * 0.5 : screenSize.height * 0.25,
          child: path != null
              ? ClipRRect(
                  borderRadius: BorderRadius.circular(30.0),

                  child: isJoinScreen
                      ? Image.asset(
                          path,
                          fit: BoxFit.fitHeight,
                        )
                      : Image.file(
                          File(path),
                          fit: BoxFit.fitWidth,
                        ),
                )
              : const Icon(
                  Icons.image,
                  size: 35,
                  color: Palette.grey300,
                ),
        ),
        const SizedBox(height: 5),
      ],
    );
  }
}
