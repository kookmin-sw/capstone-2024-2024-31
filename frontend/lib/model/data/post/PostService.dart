import 'package:dio/dio.dart';
import 'package:frontend/model/data/post/post.dart';
import 'package:logger/logger.dart';

import '../../../env.dart';

class PostService{


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