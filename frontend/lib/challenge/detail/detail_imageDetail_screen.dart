import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  final String imagePath;

  ImageDetailPage({required this.imagePath});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
          onTap: () {
            Navigator.pop(context);
          },
          child: Center(
            child: Container(
              width: screenWidth,
              child: Image.asset(
                imagePath,
                fit: BoxFit.fill,
              ),
            ),
          )),
    );
  }
}
