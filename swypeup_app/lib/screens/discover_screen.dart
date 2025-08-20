import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:appinio_swiper/appinio_swiper.dart';
import '../models/activity.dart';
import '../providers/activities_provider.dart';
import '../widgets/activity_card.dart';

class DiscoverScreen extends ConsumerStatefulWidget {
  const DiscoverScreen({super.key});

  @override
  ConsumerState<DiscoverScreen> createState() => _DiscoverScreenState();
}

class _DiscoverScreenState extends ConsumerState<DiscoverScreen> {
  final AppinioSwiperController _swiperController = AppinioSwiperController();

  @override
  void initState() {
    super.initState();
    // Load activities when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadActivities();
    });
  }

  void _loadActivities() {
    // For demo purposes, using a default location (San Francisco)
    // In a real app, you'd get the user's current location
    ref.read(activitiesProvider.notifier).loadFeed(
      lat: 37.7749,
      lon: -122.4194,
    );
  }

  void _onSwipeRight(Activity activity) async {
    try {
      await ref.read(activitiesProvider.notifier).joinActivity(activity.id);
      
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Joined ${activity.title}!'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Failed to join activity: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  void _onSwipeLeft(Activity activity) {
    // Activity dismissed, no action needed
  }

  @override
  Widget build(BuildContext context) {
    final activitiesState = ref.watch(activitiesProvider);
    
    return Scaffold(
      body: Column(
        children: [
          // Error message
          if (activitiesState.error != null) ...[
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              margin: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.red[50],
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.red[200]!),
              ),
              child: Row(
                children: [
                  Icon(Icons.error, color: Colors.red[700]),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      activitiesState.error!,
                      style: TextStyle(color: Colors.red[700]),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close),
                    onPressed: () {
                      ref.read(activitiesProvider.notifier).clearError();
                    },
                  ),
                ],
              ),
            ),
          ],
          
          // Swipeable cards
          Expanded(
            child: activitiesState.isLoading
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : activitiesState.feedActivities.isEmpty
                    ? Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.explore_off,
                              size: 64,
                              color: Colors.grey[400],
                            ),
                            const SizedBox(height: 16),
                            Text(
                              'No activities nearby',
                              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Check back later for new activities!',
                              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Colors.grey[500],
                              ),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: _loadActivities,
                              icon: const Icon(Icons.refresh),
                              label: const Text('Refresh'),
                            ),
                          ],
                        ),
                      )
                    : AppinioSwiper(
                        controller: _swiperController,
                        cards: activitiesState.feedActivities.map((activity) {
                          return ActivityCard(
                            activity: activity,
                            onSwipeRight: () => _onSwipeRight(activity),
                            onSwipeLeft: () => _onSwipeLeft(activity),
                          );
                        }).toList(),
                        onSwipe: (index, direction) {
                          final activity = activitiesState.feedActivities[index];
                          if (direction == AppinioSwiperDirection.right) {
                            _onSwipeRight(activity);
                          } else {
                            _onSwipeLeft(activity);
                          }
                        },
                        padding: const EdgeInsets.all(20),
                        maxAngle: 30,
                        threshold: 50,
                        duration: const Duration(milliseconds: 300),
                        onEnd: () {
                          // All cards swiped, could reload or show message
                        },
                      ),
          ),
          
          // Swipe instructions
          if (activitiesState.feedActivities.isNotEmpty) ...[
            Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildSwipeInstruction(
                    icon: Icons.close,
                    label: 'Skip',
                    color: Colors.red,
                  ),
                  _buildSwipeInstruction(
                    icon: Icons.favorite,
                    label: 'Join',
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildSwipeInstruction({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: color,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _swiperController.dispose();
    super.dispose();
  }
}
