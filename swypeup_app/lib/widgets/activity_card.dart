import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/activity.dart';

class ActivityCard extends StatelessWidget {
  final Activity activity;
  final VoidCallback onSwipeRight;
  final VoidCallback onSwipeLeft;

  const ActivityCard({
    super.key,
    required this.activity,
    required this.onSwipeRight,
    required this.onSwipeLeft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            // Background image or gradient
            Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Theme.of(context).colorScheme.primary.withOpacity(0.8),
                    Theme.of(context).colorScheme.secondary.withOpacity(0.6),
                  ],
                ),
              ),
            ),
            
            // Content
            Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Host info
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 20,
                        backgroundColor: Colors.white.withOpacity(0.2),
                        child: activity.host.profilePictureUrl != null
                            ? ClipOval(
                                child: Image.network(
                                  activity.host.profilePictureUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) {
                                    return Text(
                                      activity.host.name.substring(0, 1).toUpperCase(),
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    );
                                  },
                                ),
                              )
                            : Text(
                                activity.host.name.substring(0, 1).toUpperCase(),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Hosted by',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.8),
                                fontSize: 12,
                              ),
                            ),
                            Text(
                              activity.host.name,
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  
                  const Spacer(),
                  
                  // Activity title
                  Text(
                    activity.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  // Activity description
                  Text(
                    activity.description,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.9),
                      fontSize: 16,
                      height: 1.4,
                    ),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Activity details
                  _buildDetailRow(
                    icon: Icons.location_on,
                    text: activity.address,
                  ),
                  
                  const SizedBox(height: 8),
                  
                  _buildDetailRow(
                    icon: Icons.access_time,
                    text: _formatDateTime(activity.startTime),
                  ),
                  
                  const SizedBox(height: 8),
                  
                  _buildDetailRow(
                    icon: Icons.people,
                    text: '${activity.maxParticipants} participants max',
                  ),
                  
                  const SizedBox(height: 24),
                  
                  // Status badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: _getStatusColor(activity.status).withOpacity(0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: _getStatusColor(activity.status),
                        width: 1,
                      ),
                    ),
                    child: Text(
                      activity.status.toUpperCase(),
                      style: TextStyle(
                        color: _getStatusColor(activity.status),
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow({
    required IconData icon,
    required String text,
  }) {
    return Row(
      children: [
        Icon(
          icon,
          color: Colors.white.withOpacity(0.8),
          size: 20,
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white.withOpacity(0.9),
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
      return 'Today at ${DateFormat('h:mm a').format(dateTime)}';
    } else if (activityDate == today.add(const Duration(days: 1))) {
      return 'Tomorrow at ${DateFormat('h:mm a').format(dateTime)}';
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
