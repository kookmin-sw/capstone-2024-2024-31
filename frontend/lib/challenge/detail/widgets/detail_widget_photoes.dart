import 'package:flutter/material.dart';

class PhotoesWidget extends StatelessWidget {
  final double screenHeight;
  final String imageUrl;

  const PhotoesWidget({Key? key, required this.screenHeight, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage(imageUrl),
          fit: BoxFit.fitWidth,
        ),
      ),
    );  }
}