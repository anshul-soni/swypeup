import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';
import '../screens/chat_screen.dart';

class ActivityListItem extends StatelessWidget {
  final Activity activity;

  const ActivityListItem({
    super.key,
    required this.activity,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          // TODO: Navigate to activity details screen
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Viewing ${activity.title}'),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header with title and status
              Row(
                children: [
                  Expanded(
                    child: Text(
                      activity.title,
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(activity.status).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      activity.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(activity.status),
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Description
              Text(
                activity.description,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[600],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              
              const SizedBox(height: 12),
              
              // Details row
              Row(
                children: [
                  // Location
                  Expanded(
                    child: Row(
                      children: [
                        Icon(
                          Icons.location_on,
                          size: 16,
                          color: Colors.grey[600],
                        ),
                        const SizedBox(width: 4),
                        Expanded(
                          child: Text(
                            activity.address,
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontSize: 12,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                  
                  const SizedBox(width: 16),
                  
                  // Time
                  Row(
                    children: [
                      Icon(
                        Icons.access_time,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        _formatDateTime(activity.startTime),
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              const SizedBox(height: 8),
              
              // Footer with host and participants
              Row(
                children: [
                  // Host info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Theme.of(context).colorScheme.primary.withOpacity(0.1),
                        child: activity.host.profilePictureUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  activity.host.profilePictureUrl!,
                                  width: 24,
                                  height: 24,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(
                                      activity.host.name.substring(0, 1).toUpperCase(),
                                      style: TextStyle(
                                        color: Theme.of(context).colorScheme.primary,
                                        fontSize: 12,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Text(
                                activity.host.name.substring(0, 1).toUpperCase(),
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.primary,
                                  fontSize: 12,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Hosted by ${activity.host.name}',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Participants
                  Row(
                    children: [
                      Icon(
                        Icons.people,
                        size: 16,
                        color: Colors.grey[600],
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '${activity.maxParticipants} max',
                        style: TextStyle(
                          color: Colors.grey[600],
                          fontSize: 12,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              
              // Chat button
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatScreen(activity: activity),
                      ),
                    );
                  },
                  icon: const Icon(Icons.chat_bubble_outline, size: 18),
                  label: const Text('Open Chat'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatDateTime(DateTime dateTime) {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    final activityDate = DateTime(dateTime.year, dateTime.month, dateTime.day);
    
    if (activityDate == today) {
      return 'Today ${DateFormat('h:mm a').format(dateTime)}';
    } else if (activityDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow ${DateFormat('h:mm a').format(dateTime)}';
    } else {
      return DateFormat('MMM d, h:mm a').format(dateTime);
    }
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'active':
        return Colors.green;
      case 'full':
        return Colors.orange;
      case 'expired':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
