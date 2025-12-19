import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../features/exercises/domain/entities/exercise.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/exercise_video_player.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final Exercise exercise;
  final ValueChanged<int>? onTabChange;

  const ExerciseDetailScreen({
    super.key,
    required this.exercise,
    this.onTabChange,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  void _onBottomNavTapped(int index) {
    if (index == 1) {
      // Already on Exercises tab, just pop back
      Navigator.pop(context);
    } else {
      // Pop back and change tab
      Navigator.pop(context);
      widget.onTabChange?.call(index);
    }
  }

  @override
  Widget build(BuildContext context) {
    final difficultyColor = AppTheme.getDifficultyColor(widget.exercise.difficultyLevel);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Details'),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Instruction Video or Image
          if (widget.exercise.instructionVideoUrl != null)
            ExerciseVideoPlayer(
              videoUrl: widget.exercise.instructionVideoUrl!,
            )
          else if (widget.exercise.imageUrl != null)
            CachedNetworkImage(
              imageUrl: widget.exercise.imageUrl!,
              width: double.infinity,
              height: 300,
              fit: BoxFit.cover,
              placeholder: (context, url) => Container(
                width: double.infinity,
                height: 300,
                color: AppTheme.getPlaceholderColor(context),
                child: const Center(
                  child: CircularProgressIndicator(),
                ),
              ),
              errorWidget: (context, url, error) => Container(
                width: double.infinity,
                height: 300,
                color: AppTheme.getPlaceholderColor(context),
                child: Icon(
                  Icons.fitness_center,
                  color: AppTheme.getIconColor(context),
                  size: 80,
                ),
              ),
            )
          else
            Container(
              width: double.infinity,
              height: 300,
              color: AppTheme.getPlaceholderColor(context),
              child: Icon(
                Icons.fitness_center,
                color: AppTheme.getIconColor(context),
                size: 80,
              ),
            ),

          // Exercise Name and Difficulty
          Padding(
            padding: const EdgeInsets.all(AppConstants.spacingLarge),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    widget.exercise.name,
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                ),
                const SizedBox(width: AppConstants.spacingMedium),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: difficultyColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium,
                    ),
                    border: Border.all(
                      color: difficultyColor.withOpacity(0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    widget.exercise.difficultyLevel.toUpperCase(),
                    style: TextStyle(
                      color: difficultyColor,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.5,
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Tabs
          TabBar(
            controller: _tabController,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: AppTheme.getMutedTextColor(context),
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Description'),
              Tab(text: 'Instructions'),
            ],
          ),

          // Tab Content
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                // Description Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingLarge),
                  child: Text(
                    widget.exercise.description,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.getMutedTextColor(context),
                          height: 1.5,
                        ),
                  ),
                ),
                // Instructions Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingLarge),
                  child: Text(
                    widget.exercise.instructions,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.getMutedTextColor(context),
                          height: 1.5,
                        ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 1, // Exercises tab
        onTap: _onBottomNavTapped,
      ),
    );
  }
}