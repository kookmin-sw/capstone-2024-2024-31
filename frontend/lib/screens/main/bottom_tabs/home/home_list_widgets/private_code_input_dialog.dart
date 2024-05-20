import 'package:flutter/material.dart';
import 'package:frontend/screens/challenge/detail/challenge_detail_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:frontend/service/challenge_service.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

class PrivateCodeInputDialog extends StatefulWidget {
  const PrivateCodeInputDialog({super.key, required this.challengeId});

  final int challengeId;

  @override
  State<PrivateCodeInputDialog> createState() => _PrivateCodeInputDialogState();
}

class _PrivateCodeInputDialogState extends State<PrivateCodeInputDialog> {
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  final logger = Logger();
  Challenge? challenge;
  bool isPossibleJoin = false;

  TextStyle textStyle(double size, FontWeight weight, Color color) => TextStyle(
      fontFamily: "Pretender",
      fontSize: size,
      fontWeight: weight,
      color: color);

  Future<Challenge> _checkInputCode(String code) async {
    ChallengeService.fetchChallenge(widget.challengeId, code).then((challenge) {
      return challenge;
    }).catchError((err) {
      logger.e(err);
    });

    return Future.error("챌린지 정보를 불러오는데 실패했습니다.");
  }

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _checkInputCode("").then((challenge) {
      logger.d("챌린지 생성자여서 암호코드 없이 입장");
      Get.to(() => ChallengeDetailScreen(
          challenge: challenge,
          isFromMainScreen: true,
          isFromPrivateCodeDialog: true));
    });
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('비공개 암호를 입력하세요',
          style: textStyle(13.0, FontWeight.bold, Palette.purPle400)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: _passwordController,
            style: textStyle(14.0, FontWeight.w400, Palette.grey500),
            decoration: InputDecoration(
              labelText: '암호',
              labelStyle: textStyle(12.0, FontWeight.w400, Palette.grey300),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: Text('Cancel',
              style: textStyle(13.0, FontWeight.w400, Palette.grey300)),
        ),
        ElevatedButton(
          onPressed: () async {
            String password = _passwordController.text;

            _checkInputCode(password).then((challenge) {
              Get.to(() => ChallengeDetailScreen(
                    challenge: challenge,
                    isFromMainScreen: true,
                    isFromPrivateCodeDialog: true,
                  ));
            }).catchError((err) {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('비공개 암호가 일치하지 않습니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            });
          },
          child: Text('확인',
              style: textStyle(13.0, FontWeight.w500, Palette.purPle400)),
        ),
      ],
    );
  }
}
