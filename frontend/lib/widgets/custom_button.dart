import 'package:flutter/material.dart';
import 'package:frontend/model/config/palette.dart';

class CustomButton extends StatelessWidget {
  final Function onPressed;
  final String text;

  const CustomButton({super.key, required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Palette.mainPurple,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          padding: const EdgeInsets.symmetric(vertical: 16),
        ),
        child: Text(
          text,
          style: const TextStyle(
              fontSize: 14,
              color: Colors.white,
              fontFamily: 'Pretendard',
              fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}
