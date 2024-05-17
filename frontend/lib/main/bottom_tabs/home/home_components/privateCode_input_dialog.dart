import 'package:flutter/material.dart';
import 'package:frontend/challenge/detail/detail_challenge_screen.dart';
import 'package:frontend/model/config/palette.dart';
import 'package:frontend/model/data/challenge/challenge.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:frontend/env.dart';

class PasswordInputDialog extends StatefulWidget {
  const PasswordInputDialog({super.key, required this.challengeId});

  final int challengeId;

  @override
  _PasswordInputDialogState createState() => _PasswordInputDialogState();
}

class _PasswordInputDialogState extends State<PasswordInputDialog> {
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

  Future<bool> _fetchChallenge(String inputCode) async {
    bool canAccess = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();
    dio.options.headers['content-Type'] = 'application/json';
    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString('access_token')}';

    try {
      final response = await dio.get(
          '${Env.serverUrl}/challenges/${widget.challengeId}',
          queryParameters: {"code": inputCode});

      if (response.statusCode == 200) {
        logger.d('$inputCode : ${response.data}코드 일치');
        logger.d(response.data);
        canAccess = true;
      } else if (response.statusCode == 403) {
        logger.d('코드 불일치');
        logger.d(response.data);
        canAccess = false;
      }
    } catch (e) {
      logger.e(e);
    }

    return canAccess;
  }

  @override
  void initState() {
    super.initState();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();

    _fetchChallenge("아무거나101010101").then((value) {
      if (value == true) {
        setState(() {
          Get.snackbar("챌린지 생성자", "암호코드 없이 입장");
          Get.to(() => ChallengeDetailScreen(
              challengeId: widget.challengeId, isFromMainScreen: true));
        });
      }
    }); //c챌린지 생성자인지 확인 용.
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

            if (await _fetchChallenge(password)) {
              // Passwords match, handle confirmation
              Get.to(() => ChallengeDetailScreen(
                  challengeId: widget.challengeId, isFromMainScreen: true));
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('비공개 암호가 일치하지 않습니다'),
                  duration: Duration(seconds: 2),
                ),
              );
            }
          },
          child: Text('확인',
              style: textStyle(13.0, FontWeight.w500, Palette.purPle400)),
        ),
      ],
    );
  }
}
