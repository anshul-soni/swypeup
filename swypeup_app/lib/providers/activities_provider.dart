import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/activity.dart';
import '../services/api_service.dart';
import 'auth_provider.dart';

class ActivitiesNotifier extends StateNotifier<ActivitiesState> {
  final ApiService _apiService;
  final Ref _ref;
  
  ActivitiesNotifier(this._apiService, this._ref) : super(ActivitiesState.initial());

  Future<void> loadFeed({required double lat, required double lon}) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final authState = _ref.read(authProvider);
      if (authState.token == null) {
        throw Exception('Not authenticated');
      }
      
      final activities = await _apiService.getFeed(
        token: authState.token!,
        lat: lat,
        lon: lon,
      );
      
      state = state.copyWith(
        feedActivities: activities,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> loadUserActivities() async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final authState = _ref.read(authProvider);
      if (authState.token == null) {
        throw Exception('Not authenticated');
      }
      
      final activities = await _apiService.getUserActivities(authState.token!);
      
      state = state.copyWith(
        hostingActivities: activities['hosting'],
        participatingActivities: activities['participating'],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> joinActivity(String activityId) async {
    try {
      final authState = _ref.read(authProvider);
      if (authState.token == null) {
        throw Exception('Not authenticated');
      }
      
      await _apiService.joinActivity(
        token: authState.token!,
        activityId: activityId,
      );
      
      // Remove the activity from feed since user joined it
      final updatedFeed = state.feedActivities
          .where((activity) => activity.id != activityId)
          .toList();
      
      state = state.copyWith(feedActivities: updatedFeed);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> createActivity({
    required String title,
    required String description,
    required List<double> location,
    required String address,
    required DateTime startTime,
    required DateTime endTime,
    required int maxParticipants,
  }) async {
    try {
      state = state.copyWith(isLoading: true, error: null);
      
      final authState = _ref.read(authProvider);
      if (authState.token == null) {
        throw Exception('Not authenticated');
      }
      
      final activity = await _apiService.createActivity(
        token: authState.token!,
        title: title,
        description: description,
        location: location,
        address: address,
        startTime: startTime,
        endTime: endTime,
        maxParticipants: maxParticipants,
      );
      
      // Add to hosting activities
      final updatedHosting = [...state.hostingActivities, activity];
      
      state = state.copyWith(
        hostingActivities: updatedHosting,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }
}

class ActivitiesState {
  final List<Activity> feedActivities;
  final List<Activity> hostingActivities;
  final List<Activity> participatingActivities;
  final bool isLoading;
  final String? error;

  ActivitiesState({
    required this.feedActivities,
    required this.hostingActivities,
    required this.participatingActivities,
    required this.isLoading,
    this.error,
  });

  factory ActivitiesState.initial() {
    return ActivitiesState(
      feedActivities: [],
      hostingActivities: [],
      participatingActivities: [],
      isLoading: false,
    );
  }

  ActivitiesState copyWith({
    List<Activity>? feedActivities,
    List<Activity>? hostingActivities,
    List<Activity>? participatingActivities,
    bool? isLoading,
    String? error,
  }) {
    return ActivitiesState(
      feedActivities: feedActivities ?? this.feedActivities,
      hostingActivities: hostingActivities ?? this.hostingActivities,
      participatingActivities: participatingActivities ?? this.participatingActivities,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Provider
final activitiesProvider = StateNotifierProvider<ActivitiesNotifier, ActivitiesState>((ref) {
  final apiService = ref.watch(apiServiceProvider);
  return ActivitiesNotifier(apiService, ref);
});
