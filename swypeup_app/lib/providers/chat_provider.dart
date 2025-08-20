import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../services/chat_service.dart';
import 'auth_provider.dart';

class ChatNotifier extends StateNotifier<ChatState> {
  final ChatService _chatService;
  final Ref _ref;
  StreamChatClient? _client;

  ChatNotifier(this._chatService, this._ref) : super(ChatState.initial());

  Future<void> initializeChat(String authToken) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      // Get Stream token from backend
      final tokenData = await _chatService.generateToken(authToken);
      final streamToken = tokenData['token'];
      final user = tokenData['user'];

      // Initialize Stream Chat client
      _client = StreamChatClient(
        'your-stream-api-key', // Replace with your Stream API key
        logLevel: Level.INFO,
      );

      // Connect user to Stream
      await _client!.connectUser(
        User(id: user['id'], name: user['name']),
        streamToken,
      );

      state = state.copyWith(
        client: _client,
        isConnected: true,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> joinActivityChat(String activityId) async {
    try {
      state = state.copyWith(isLoading: true, error: null);

      final authState = _ref.read(authProvider);
      if (authState.token == null) {
        throw Exception('Not authenticated');
      }

      // Join chat channel via backend
      await _chatService.joinChannel(activityId, authState.token!);

      // Get channel in Stream
      final channel = _client!.channel('messaging', id: 'activity-$activityId');
      await channel.watch();

      state = state.copyWith(
        currentChannel: channel,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        error: e.toString(),
        isLoading: false,
      );
    }
  }

  Future<void> leaveActivityChat(String activityId) async {
    try {
      final authState = _ref.read(authProvider);
      if (authState.token == null) {
        throw Exception('Not authenticated');
      }

      // Leave chat channel via backend
      await _chatService.leaveChannel(activityId, authState.token!);

      // Stop watching channel in Stream
      if (state.currentChannel != null) {
        await state.currentChannel!.stopWatching();
      }

      state = state.copyWith(currentChannel: null);
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  Future<void> sendMessage(String message) async {
    try {
      if (state.currentChannel == null) {
        throw Exception('No active chat channel');
      }

      await state.currentChannel!.sendMessage(
        Message(text: message),
      );
    } catch (e) {
      state = state.copyWith(error: e.toString());
    }
  }

  void clearError() {
    state = state.copyWith(error: null);
  }

  void dispose() {
    _client?.dispose();
  }
}

class ChatState {
  final StreamChatClient? client;
  final Channel? currentChannel;
  final bool isConnected;
  final bool isLoading;
  final String? error;

  ChatState({
    this.client,
    this.currentChannel,
    required this.isConnected,
    required this.isLoading,
    this.error,
  });

  factory ChatState.initial() {
    return ChatState(
      isConnected: false,
      isLoading: false,
    );
  }

  ChatState copyWith({
    StreamChatClient? client,
    Channel? currentChannel,
    bool? isConnected,
    bool? isLoading,
    String? error,
  }) {
    return ChatState(
      client: client ?? this.client,
      currentChannel: currentChannel ?? this.currentChannel,
      isConnected: isConnected ?? this.isConnected,
      isLoading: isLoading ?? this.isLoading,
      error: error ?? this.error,
    );
  }
}

// Provider
final chatProvider = StateNotifierProvider<ChatNotifier, ChatState>((ref) {
  final chatService = ChatService();
  return ChatNotifier(chatService, ref);
});
