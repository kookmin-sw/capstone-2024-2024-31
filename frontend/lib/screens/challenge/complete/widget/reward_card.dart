import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';
import '../../../../model/data/sms/sms.dart';
import 'package:chat_bubbles/chat_bubbles.dart';

class RewardCard extends StatelessWidget {
  final bool isSuccess;
  final Sms sms;

  RewardCard({super.key, required this.isSuccess, required this.sms});

  TextStyle titleStyle = const TextStyle(
      fontSize: 18,
      fontFamily: "Pretender",
      fontWeight: FontWeight.bold,
      color: Palette.grey300);
  TextStyle smallTextStyle = const TextStyle(
      fontSize: 18,
      fontFamily: "Pretender",
      fontWeight: FontWeight.bold,
      color: Palette.purPle400);

  String smsText(bool isSuccess) {
    String baseMessage =
        "성장을 위한 좋은 습관,루틴업\n\n${sms.receiverName}의 ${sms.relationship} ${sms.userName}께서 <${sms.challengeName}> 챌린지를 ";
    String resultMessage = isSuccess ? "성공했어요👏🏻" : "실패했어요😭";
    String personalMessage =
        "\n\n💌 ${sms.userName}님이 ${sms.receiverName}님께 각오를 남겼어요!\n----------------------------\n${sms.letter}\n----------------------------\n\n여러분의 갓생을 루틴업이 응원합니다🔥";

    return "$baseMessage$resultMessage$personalMessage";
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
          Text("포인트", style: titleStyle),
          Text(
            isSuccess ? "+ 100point" : "0point",
            style: smallTextStyle,
          )
        ]),
        const SizedBox(height: 20),
        Text("전송된 결과 메시지", style: titleStyle),
        const SizedBox(height: 10),
        BubbleSpecialThree(
          text: smsText(isSuccess),
          color: const Color(0xFFE8E8EE),
          tail: true,
          isSender: false,
          textStyle: const TextStyle(fontSize: 12, fontFamily: 'Pretender'),
        ),
        const SizedBox(height: 30),
      ],
    );
  }
}
