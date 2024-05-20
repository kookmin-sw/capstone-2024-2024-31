import 'package:dio/dio.dart' as dio;
import 'package:frontend/model/data/post/post.dart';
import 'package:frontend/model/data/post/post_form.dart';
import 'package:frontend/service/dio_service.dart';
import 'package:intl/intl.dart';
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

  static Future<Comment> createComment(
      int postId, String content, int? parentId) async {
    final String uri = '/posts/$postId/comments';

    try {
      final response = await dioInstance.post(uri, queryParameters: {
        'parentId': parentId,
      }, data: {
        'content': content,
      });

      if (response.statusCode == 201) {
        logger.d('댓글 생성 성공: ${response.data}');
        return Comment.fromJson(response.data);
      } else {
        throw Exception('댓글 생성 실패: ${response.data}');
      }
    } catch (err) {
      throw Exception('댓글 생성 실패: ${err.toString()}');
    }
  }

  static Future<bool> checkPossibleCertification(
      //오늘 인증 이미 있으면 false, 없으면 true 반환
      int challengeId,
      int userId) async {
    final dio.Dio dioInstance = DioService().dio;
    final String uri = '/challenges/$challengeId/posts';
    final Logger logger = Logger();

    try {
      final response = await dioInstance.get(uri);

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
          if (postDateStr == todayStr && post.authorId == userId) {
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
}
