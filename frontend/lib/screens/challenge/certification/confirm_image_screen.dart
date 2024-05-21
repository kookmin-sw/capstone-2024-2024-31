import 'package:flutter/material.dart';
import 'dart:io';

import 'run_model_by_camera_demo.dart';

class ConfirmImageScreen extends StatelessWidget {
  final File image;

  const ConfirmImageScreen({super.key, required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('이미지 확인'),
      ),
      body: Column(
        children: [
          Expanded(
            child: Image.file(image),
          ),
          const Text('이 이미지로 하시겠습니까?'),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                child: const Text('다시 찍기'),
                onPressed: () {
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const RunModelByCameraDemo(),
                    ),
                  );
                },
              ),
              TextButton(
                child: const Text('예'),
                onPressed: () {
                  print(image);
                  Navigator.pop(context, image); // 이미지 반환하고 이전 화면으로 돌아가기
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
