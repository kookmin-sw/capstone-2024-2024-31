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

  static Future<List<Post>> fetchMyPosts(int challengeId, int userId) {
    final String uri = '/posts/users/$userId';

    try {
      return dioInstance.get(uri, queryParameters: {
        'challengeId': challengeId,
      }).then((response) {
        if (response.statusCode == 200) {
          List<dynamic> data = response.data;
          List<Post> posts = data.map((item) => Post.fromJson(item)).toList();

          logger.d("내 게시글 조회 성공: ${response.data}");
          return posts;
        } else {
          throw Exception('내 게시글 조회 실패: ${response.data}');
        }
      });
    } catch (e) {
      throw Exception('내 게시글 조회 실패: ${e.toString()}');
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

  static Future<Comment> createComment(int postId, String content,
      int? parentId) async {
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

  static Future<bool> checkPossibleCertification(int challengeId,
      int userId) async {
    try {
      List<Post> posts = await fetchPosts(challengeId);
      if (posts.isEmpty) {
        return true;
      }
      // 현재 날짜를 가져옵니다.
      DateTime today = DateTime.now();
      String todayStr = DateFormat('yyyy-MM-dd').format(today);
      // posts 중에 내 포스트만 필터링
      var myPosts = posts.where((post) => post.authorId == userId);

      // 필터링된 내 포스트 중에서 오늘 작성된 포스트가 있는지 검사
      for (var post in myPosts) {
        String postDateStr =
        DateFormat('yyyy-MM-dd').format(DateTime.parse(post.createdDate));
        if (postDateStr == todayStr) {
          return false; // 오늘 날짜 글 있으면 false
        }
      }
      return true; // 오늘 날짜 글 없으면 true
    } catch (e) {
      logger.e('Error: $e');
      throw Exception('게시글 조회 실패: ${e.toString()}');
    }
    return false;
  }

  static Future<bool> checkPossibleCommunityCertification(List<Post> posts,
      int userId) async {
    if (posts.isEmpty) {
      return true;
    }

    // 현재 날짜를 가져옵니다.
    DateTime today = DateTime.now();
    String todayStr = DateFormat('yyyy-MM-dd').format(today);
    // posts 중에 내 포스트만 필터링
    var myPosts = posts.where((post) => post.authorId == userId);

    // 필터링된 내 포스트 중에서 오늘 작성된 포스트가 있는지 검사
    for (var post in myPosts) {
      String postDateStr =
      DateFormat('yyyy-MM-dd').format(DateTime.parse(post.createdDate));
      if (postDateStr == todayStr) {
        return false; // 오늘 날짜 글 있으면 false
      }
    }
    return true; // 오늘 날짜 글 없으면 true
  }
}
