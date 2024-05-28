import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';

class PostForm {
  final String title;
  final String content;
  final File image;

  PostForm({
    required this.title,
    required this.content,
    required this.image,
  });

  Map<String, dynamic> toJson() {
    return {
      'data': jsonEncode({
        'title': title,
        'content': content,
      }).toString(),
      'image': MultipartFile.fromFileSync(image.path,
          contentType: MediaType('image', 'jpeg'))
    };
  }
}
