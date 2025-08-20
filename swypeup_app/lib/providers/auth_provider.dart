import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthNotifier extends StateNotifier<AuthState> {
  final ApiService _apiService;
  
  AuthNotifier(this._apiService) : super(AuthState.initial());

  Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final response = await _apiService.register(
        name: name,
        email: email,
        password: password,
      );
      
      final user = User.fromJson(response['user']);
      final token = response['access_token'];
      
      // Save token to local storage
      await _saveToken(token);
      
      state = state.copyWith(
        user: user,
        token: token,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> login({
    required String email,
    required String password,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final response = await _apiService.login(
        email: email,
        password: password,
      );
      
      final user = User.fromJson(response['user']);
      final token = response['access_token'];
      
      // Save token to local storage
      await _saveToken(token);
      
      state = state.copyWith(
        user: user,
        token: token,
        isAuthenticated: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> logout() async {
    // Clear token from local storage
    await _clearToken();
    
    state = AuthState.initial();
  }

  Future<void> checkAuthStatus() async {
    try {
      final token = await _getToken();
      if (token != null) {
        final user = await _apiService.getProfile(token);
        state = state.copyWith(
          user: user,
          token: token,
          isAuthenticated: true,
        );
      }
    } catch (e) {
      // Token is invalid, clear it
      await _clearToken();
      state = AuthState.initial();
    }
  }

  Future<void> _saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('auth_token', token);
  }

  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  Future<void> _clearToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
  }
}

class AuthState {
  final User? user;
  final String? token;
  final bool isAuthenticated;
  final bool isLoading;
  final String? error;

  AuthState({
    this.user,
    this.token,
    required this.isAuthenticated,
    required this.isLoading,
    this.error,
  });

  factory AuthState.initial() {
    return AuthState(
      isAuthenticated: false,
      isLoading: false,
    );
  }

  AuthState copyWith({
    User? user,
    String? token,
    bool? isAuthenticated,
    bool? isLoading,
    String? error,
  }) {
    return AuthState(
      user: user ?? this.user,
      token: token ?? this.token,
      isAuthenticated: isAuthenticated ?? this.isAuthenticated,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Providers
final apiServiceProvider = Provider<ApiService>((ref) {
  return ApiService();
});

final authProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return AuthNotifier(apiService);
});
