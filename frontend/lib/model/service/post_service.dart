import 'package:dio/dio.dart';
import 'package:frontend/model/data/post/post.dart';
import 'package:intl/intl.dart';
import 'package:logger/logger.dart';

import '../../env.dart';

class PostService {
  static Future<bool> checkPossibleCertification( //오늘 인증 이미 있으면 false, 없으면 true 반환
      int challengeId, int userId) async {
    final Dio dio = Dio();
    final String url = '${Env.serverUrl}/challenges/$challengeId/posts';
    Logger logger = Logger();

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Post> posts = data.map((item) => Post.fromJson(item)).toList();

        logger.d("response.data: ${response.data}");

        // 현재 날짜를 가져옵니다.
        DateTime today = DateTime.now();
        String todayStr = DateFormat('yyyy-MM-dd').format(today);

        // 오늘 날짜와 일치하고 author가 userId와 일치하는 게시물이 있는지 확인합니다.
        for (var post in posts) {
          String postDateStr =
              DateFormat('yyyy-MM-dd').format(post.createdDate as DateTime);
          if (postDateStr == todayStr && post.authorId  == userId) {
            return false;
          }
        }
        return true;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      logger.e('Error: $e');
      throw Exception('Failed to load posts');
    }
  }

  static Future<List<Post>> fetchPosts(int challengeId) async {
    final Dio dio = Dio();
    final String url = '${Env.serverUrl}/challenges/$challengeId/posts';
    Logger logger = Logger();
    logger.d("111111111111111111111111111111111111");

    try {
      final response = await dio.get(url);

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Post> posts = data.map((item) => Post.fromJson(item)).toList();

        logger.d("response.data: ${response.data}");
        return posts;
      } else {
        throw Exception('Failed to load posts');
      }
    } catch (e) {
      print('Error: $e');
      throw Exception('Failed to load posts');
    }
  }
}
