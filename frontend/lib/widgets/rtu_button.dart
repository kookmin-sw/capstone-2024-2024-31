import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';

class RtuButton extends StatelessWidget {
  final Function onPressed;
  final String text;
  bool disabled;
  Color color;

  RtuButton(
      {super.key,
      required this.onPressed,
      required this.text,
      this.disabled = false,
      this.color = Palette.mainPurple});

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: () {
              if (!disabled) {
                onPressed();
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: disabled == false ? color : Palette.greySoft,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding: const EdgeInsets.symmetric(vertical: 10),
            ),
            child: Text(
              text,
              style: TextStyle(
                  fontSize: 14,
                  color: disabled == false ? Colors.white : Colors.grey,
                  fontFamily: 'Pretendard',
                  fontWeight: FontWeight.bold),
            ),
          ),
        ));
  }
}
