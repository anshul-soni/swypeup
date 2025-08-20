import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/user.dart';
import '../models/activity.dart';

class ApiService {
  static const String baseUrl = 'http://localhost:3000';
  late final Dio _dio;

  ApiService() {
    _dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));

    _dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        // Add auth token if available
        // This will be implemented when we add token storage
        handler.next(options);
      },
      onError: (error, handler) {
        print('API Error: ${error.message}');
        handler.next(error);
      },
    ));
  }

  // Authentication
  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/register', data: {
        'name': name,
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });
      return response.data;
    } catch (e) {
      throw _handleError(e);
    }
  }

  // User Profile
  Future<User> getProfile(String token) async {
    try {
      final response = await _dio.get(
        '/users/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<User> updateProfile({
    required String token,
    String? name,
    String? bio,
    String? profilePictureUrl,
  }) async {
    try {
      final response = await _dio.put(
        '/users/me',
        data: {
          if (name != null) 'name': name,
          if (bio != null) 'bio': bio,
          if (profilePictureUrl != null) 'profilePictureUrl': profilePictureUrl,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return User.fromJson(response.data);
    } catch (e) {
      throw _handleError(e);
    }
  }

  // Activities
  Future<List<Activity>> getFeed({
    required String token,
    required double lat,
    required double lon,
  }) async {
    try {
      final response = await _dio.get(
        '/activities/feed',
        queryParameters: {'lat': lat, 'lon': lon},
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      final List<dynamic> activitiesData = response.data['data'];
      return activitiesData.map((json) => Activity.fromJson(json)).toList();
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Activity> createActivity({
    required String token,
    required String title,
    required String description,
    required List<double> location,
    required String address,
    required DateTime startTime,
    required DateTime endTime,
    required int maxParticipants,
  }) async {
    try {
      final response = await _dio.post(
        '/activities',
        data: {
          'title': title,
          'description': description,
          'location': location,
          'address': address,
          'startTime': startTime.toIso8601String(),
          'endTime': endTime.toIso8601String(),
          'maxParticipants': maxParticipants,
        },
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      return Activity.fromJson(response.data['data']);
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<void> joinActivity({
    required String token,
    required String activityId,
  }) async {
    try {
      await _dio.post(
        '/activities/$activityId/join',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
    } catch (e) {
      throw _handleError(e);
    }
  }

  Future<Map<String, List<Activity>>> getUserActivities(String token) async {
    try {
      final response = await _dio.get(
        '/activities/me',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      
      final data = response.data['data'];
      final List<dynamic> hostingData = data['hosting'];
      final List<dynamic> participatingData = data['participating'];
      
      return {
        'hosting': hostingData.map((json) => Activity.fromJson(json)).toList(),
        'participating': participatingData.map((json) => Activity.fromJson(json)).toList(),
      };
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
