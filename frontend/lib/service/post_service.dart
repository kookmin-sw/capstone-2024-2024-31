import 'package:dio/dio.dart' as dio;
import 'package:frontend/model/data/post/post.dart';
import 'package:frontend/model/data/post/post_form.dart';
import 'package:frontend/service/dio_service.dart';
import 'package:logger/logger.dart';

class PostService {
  static final dio.Dio dioInstance = DioService().dio;
  static final Logger logger = Logger();

  static Future<List<Post>> fetchPosts(int challengeId) async {
    const String uri = '/posts';

    try {
      final response = await dioInstance.get(uri, queryParameters: {
        'challengeId': challengeId,
      });

      if (response.statusCode == 200) {
        List<dynamic> data = response.data;
        List<Post> posts = data.map((item) => Post.fromJson(item)).toList();

        logger.d("게시글 조회 성공: ${response.data}");
        return posts;
      } else {
        throw Exception('게시글 조회 실패: ${response.data}');
      }
    } catch (e) {
      throw Exception('게시글 조회 실패: ${e.toString()}');
    }
  }

  static Future<Post> createPost(int challengeId, PostForm form) async {
    const String uri = '/posts';

    final data = dio.FormData.fromMap(form.toJson());
    try {
      final response = await dioInstance.post(uri,
          queryParameters: {
            'challengeId': challengeId,
          },
          options: dio.Options(headers: {
            'Content-Type': 'multipart/form-data',
          }),
          data: data);

      if (response.statusCode == 201) {
        logger.d('게시글 생성 성공: ${response.data}');
        return Post.fromJson(response.data);
      } else {
        throw Exception('게시글 생성 실패: ${response.data}');
      }
    } catch (e) {
      throw Exception('게시글 생성 실패: ${e.toString()}');
    }
  }
}
