import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../env.dart';
import '../model/data/post.dart';

class CommunityService {
  Future<List<SimplePost>> getPostsForChallenge(
      int challengeId, Logger logger) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();

    dio.options.headers['Authorization'] =
        'Bearer ${prefs.getString('access_token')}';

    try {
      final response = await dio.get('/challenges/$challengeId/posts');

      if (response.statusCode == 200) {
        List<SimplePost> posts = (response.data as List)
            .map((post) => SimplePost.fromJson(post))
            .toList();
        return posts;
      } else if (response.statusCode == 404) {
        // 404 Not Found 에러 처리
        throw Exception("해당 챌린지의 게시물을 찾을 수 없습니다.");
      } else {
        // 기타 에러 처리
        throw Exception("게시물 가져오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("게시물 가져오는 중 에러 발생: $e");
      rethrow;
    }
  }

  Future<List<SimplePost>> getPost(
      int challengeId, Logger logger) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Dio dio = Dio();

    dio.options.headers['Authorization'] =
    'Bearer ${prefs.getString('access_token')}';

    try {
      final response = await dio.get('/challenges/$challengeId/posts');

      if (response.statusCode == 200) {
        List<SimplePost> posts = (response.data as List)
            .map((post) => SimplePost.fromJson(post))
            .toList();
        return posts;
      } else if (response.statusCode == 404) {
        // 404 Not Found 에러 처리
        throw Exception("해당 챌린지의 게시물을 찾을 수 없습니다.");
      } else {
        // 기타 에러 처리
        throw Exception("게시물 가져오기 실패: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("게시물 가져오는 중 에러 발생: $e");
      rethrow;
    }
  }
}
