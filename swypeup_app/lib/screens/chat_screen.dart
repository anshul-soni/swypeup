import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:stream_chat_flutter/stream_chat_flutter.dart';
import '../models/activity.dart';
import '../providers/chat_provider.dart';
import '../providers/auth_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  final Activity activity;

  const ChatScreen({
    super.key,
    required this.activity,
  });

  @override
  ConsumerState<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends ConsumerState<ChatScreen> {
  @override
  void initState() {
    super.initState();
    _initializeChat();
  }

  Future<void> _initializeChat() async {
    final authState = ref.read(authProvider);
    if (authState.token != null) {
      // Initialize chat if not already connected
      final chatState = ref.read(chatProvider);
      if (!chatState.isConnected) {
        await ref.read(chatProvider.notifier).initializeChat(authState.token!);
      }
      
      // Join the activity chat
      await ref.read(chatProvider.notifier).joinActivityChat(widget.activity.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final chatState = ref.watch(chatProvider);
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.activity.title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
            Text(
              'Group Chat',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.info_outline),
            onPressed: () {
              _showActivityInfo();
            },
          ),
        ],
      ),
      body: _buildChatBody(chatState, authState),
    );
  }

  Widget _buildChatBody(ChatState chatState, AuthState authState) {
    if (chatState.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (chatState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Failed to load chat',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              chatState.error!,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                ref.read(chatProvider.notifier).clearError();
                _initializeChat();
              },
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (!chatState.isConnected || chatState.client == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'Connecting to chat...',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(),
          ],
        ),
      );
    }

    if (chatState.currentChannel == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              'No active chat',
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Join the activity to start chatting',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
            ),
          ],
        ),
      );
    }

    // Stream Chat UI
    return StreamChat(
      client: chatState.client!,
      child: StreamChannel(
        channel: chatState.currentChannel!,
        child: Column(
          children: [
            Expanded(
              child: StreamChannelListView(),
            ),
            StreamMessageInput(),
          ],
        ),
      ),
    );
  }

  void _showActivityInfo() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.activity.title,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.activity.description,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),
            _buildInfoRow(
              icon: Icons.location_on,
              text: widget.activity.address,
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.access_time,
              text: _formatDateTime(widget.activity.startTime),
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.people,
              text: '${widget.activity.maxParticipants} participants max',
            ),
            const SizedBox(height: 8),
            _buildInfoRow(
              icon: Icons.person,
              text: 'Hosted by ${widget.activity.host.name}',
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          size: 20,
          color: Colors.grey[600],
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.grey[600],
              fontSize: 14,
            ),
          ),
        ),
      ],
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final activityDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (activityDate == today) {
      return 'Today at ${_formatTime(dateTime)}';
    } else if (activityDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow at ${_formatTime(dateTime)}';
    } else {
      return '${_formatDate(dateTime)} at ${_formatTime(dateTime)}';
    }
  }

  String _formatTime(DateTime dateTime) {
    final hour = dateTime.hour;
    final minute = dateTime.minute;
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour == 0 ? 12 : (hour > 12 ? hour - 12 : hour);
    return '${displayHour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')} $period';
  }

  String _formatDate(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}';
  }

  @override
  void dispose() {
    // Leave the chat when leaving the screen
    ref.read(chatProvider.notifier).leaveActivityChat(widget.activity.id);
    super.dispose();
  }
}
