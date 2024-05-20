import 'package:dio/dio.dart';
import 'package:frontend/env.dart';
import 'package:logger/logger.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioService {
  static final logger = Logger();
  static final _instance = DioService();
  static final Dio _dio = Dio();

  static Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    BaseOptions options = BaseOptions(
      baseUrl: Env.serverUrl,
      connectTimeout: const Duration(seconds: 5),
      receiveTimeout: const Duration(seconds: 3),
      headers: {
        'Authorization': 'Bearer ${prefs.getString('access_token')}',
      },
    );
    _dio.options = options;
  }

  factory() {
    return _instance;
  }

  Dio get dio => _dio;
}
