import 'dart:io';
import 'package:flutter/material.dart';

class ImageFromFile extends StatelessWidget {
  final String filePath;

  const ImageFromFile(this.filePath, {super.key});

  @override
  Widget build(BuildContext context) {
    File file = File(filePath);
    if (file.existsSync()) {
      return Image.file(file);
    } else {
      return const Text('파일을 찾을 수 없습니다.');
    }
  }
}