import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/activities_provider.dart';
import '../widgets/activity_list_item.dart';

class MyActivitiesScreen extends ConsumerStatefulWidget {
  const MyActivitiesScreen({super.key});

  @override
  ConsumerState<MyActivitiesScreen> createState() => _MyActivitiesScreenState();
}

class _MyActivitiesScreenState extends ConsumerState<MyActivitiesScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    
    // Load user activities when screen initializes
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(activitiesProvider.notifier).loadUserActivities();
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final activitiesState = ref.watch(activitiesProvider);
    
    return Scaffold(
      body: Column(
        children: [
          // Tab bar
          Container(
            color: Theme.of(context).colorScheme.surface,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor: Colors.grey,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(
                  icon: const Icon(Icons.person),
                  text: 'Hosting (${activitiesState.hostingActivities.length})',
                ),
                Tab(
                  icon: const Icon(Icons.people),
                  text: 'Participating (${activitiesState.participatingActivities.length})',
                ),
              ],
            ),
          ),
          
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
          
          // Tab content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Hosting tab
                _buildActivitiesList(
                  activities: activitiesState.hostingActivities,
                  isLoading: activitiesState.isLoading,
                  emptyMessage: 'You haven\'t hosted any activities yet.',
                  emptyIcon: Icons.person_add,
                ),
                
                // Participating tab
                _buildActivitiesList(
                  activities: activitiesState.participatingActivities,
                  isLoading: activitiesState.isLoading,
                  emptyMessage: 'You haven\'t joined any activities yet.',
                  emptyIcon: Icons.people_outline,
                ),
              ],
            ),
          ),
        ],
      ),
      
      // Floating action button to create new activity
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // TODO: Navigate to create activity screen
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Create Activity feature coming soon!'),
            ),
          );
        },
        icon: const Icon(Icons.add),
        label: const Text('Create Activity'),
      ),
    );
  }

  Widget _buildActivitiesList({
    required List activities,
    required bool isLoading,
    required String emptyMessage,
    required IconData emptyIcon,
  }) {
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (activities.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              emptyIcon,
              size: 64,
              color: Colors.grey[400],
            ),
            const SizedBox(height: 16),
            Text(
              emptyMessage,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Start exploring activities in the Discover tab!',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: Colors.grey[500],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        await ref.read(activitiesProvider.notifier).loadUserActivities();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: activities.length,
        itemBuilder: (context, index) {
          final activity = activities[index];
          return Padding(
            padding: const EdgeInsets.only(bottom: 16),
            child: ActivityListItem(activity: activity),
          );
        },
      ),
    );
  }
}
