import 'package:flutter/material.dart';

class PhotoesWidget extends StatelessWidget {
  final double screenHeight;
  final String imageUrl;

  const PhotoesWidget(
      {super.key, required this.screenHeight, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight * 0.3,
      decoration: BoxDecoration(
        image: DecorationImage(
          image: NetworkImage(imageUrl),
          fit: BoxFit.fitWidth,
        ),
      ),
    );
  }
}
