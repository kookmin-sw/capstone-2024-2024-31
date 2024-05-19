import 'package:flutter/material.dart';

class ImageDetailPage extends StatelessWidget {
  final String imagePath;

  const ImageDetailPage({super.key, required this.imagePath});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Center(
          child: Image.network(
            imagePath,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }
}
