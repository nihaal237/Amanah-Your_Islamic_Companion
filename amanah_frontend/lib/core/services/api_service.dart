import 'package:dio/dio.dart';
import 'storage_service.dart';
import '../constants/api_constants.dart';

class ApiService {
  static final Dio _dio = Dio();

  static Future<void> init() async {
    _dio.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) async {
          final token = await StorageService.getAccessToken();
          if (token != null) {
            options.headers['Authorization'] = 'Bearer $token';
          }
          return handler.next(options);
        },
        onError: (error, handler) async {
          // Auto-refresh token on 401
          if (error.response?.statusCode == 401) {
            final refreshed = await _refreshToken();
            if (refreshed) {
              final token = await StorageService.getAccessToken();
              error.requestOptions.headers['Authorization'] = 'Bearer $token';
              final response = await _dio.fetch(error.requestOptions);
              return handler.resolve(response);
            }
          }
          return handler.next(error);
        },
      ),
    );
  }

  static Future<bool> _refreshToken() async {
    try {
      final refresh = await StorageService.getRefreshToken();
      if (refresh == null) return false;
      final response = await _dio.post(
        ApiConstants.refreshToken,
        data: {'refresh': refresh},
      );
      await StorageService.saveTokens(
        response.data['access'],
        refresh,
      );
      return true;
    } catch (_) {
      await StorageService.clearTokens();
      return false;
    }
  }

  static Future<Response> get(String url, {Map<String, dynamic>? params}) async {
    return await _dio.get(url, queryParameters: params);
  }

  static Future<Response> post(String url, {dynamic data}) async {
    return await _dio.post(url, data: data);
  }

  static Future<Response> patch(String url, {dynamic data}) async {
    return await _dio.patch(url, data: data);
  }

  static Future<Response> delete(String url) async {
    return await _dio.delete(url);
  }
}