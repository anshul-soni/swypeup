import 'package:dio/dio.dart';
import '../models/user.dart';

class ChatService {
  static const String baseUrl = 'http://localhost:3000';
  late final Dio _dio;

  ChatService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
  }

  Future<Map<String, dynamic>> generateToken(String authToken) async {
    try {
      final response = await _dio.post(
        '/chat/token',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );
      return response.data['data'];
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> joinChannel(String activityId, String authToken) async {
    try {
      await _dio.post(
        '/chat/channels/$activityId/join',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> leaveChannel(String activityId, String authToken) async {
    try {
      await _dio.post(
        '/chat/channels/$activityId/leave',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> getChannelInfo(String activityId, String authToken) async {
    try {
      final response = await _dio.get(
        '/chat/channels/$activityId',
        options: Options(headers: {'Authorization': 'Bearer $authToken'}),
      );
      return response.data['data'];
    } catch (e) {
      throw _handleError(e);
    }
  }

  Exception _handleError(dynamic error) {
    if (error is DioException) {
      if (error.response != null) {
        final statusCode = error.response!.statusCode;
        final data = error.response!.data;
        
        switch (statusCode) {
          case 400:
            return Exception(data['message'] ?? 'Bad request');
          case 401:
            return Exception('Unauthorized');
          case 404:
            return Exception('Not found');
          case 409:
            return Exception(data['message'] ?? 'Conflict');
          default:
            return Exception('Server error');
        }
      } else {
        return Exception('Network error');
      }
    }
    return Exception('Unknown error');
  }
}
