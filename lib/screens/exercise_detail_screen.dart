import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../core/network/dio_client.dart';
import '../core/theme/app_theme.dart';
import '../features/exercises/data/datasources/exercise_remote_datasource.dart';
import '../features/exercises/data/repositories/exercise_repository_impl.dart';
import '../features/exercises/domain/entities/exercise.dart';
import '../features/exercises/domain/repositories/exercise_repository.dart';
import '../widgets/app_bottom_navigation_bar.dart';
import '../widgets/exercise_video_player.dart';

class ExerciseDetailScreen extends StatefulWidget {
  final String exerciseId;
  final ValueChanged<int>? onTabChange;

  const ExerciseDetailScreen({
    super.key,
    required this.exerciseId,
    this.onTabChange,
  });

  @override
  State<ExerciseDetailScreen> createState() => _ExerciseDetailScreenState();
}

class _ExerciseDetailScreenState extends State<ExerciseDetailScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late final ExerciseRepository _exerciseRepository;
  Exercise? _exercise;
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _exerciseRepository = ExerciseRepositoryImpl(
      ExerciseRemoteDataSourceImpl(DioClient.instance),
    );
    _loadExerciseDetails();
  }

  Future<void> _loadExerciseDetails() async {
    debugPrint('');
    debugPrint('📱 [UI] Loading exercise details for ID: ${widget.exerciseId}...');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _exerciseRepository.getExerciseById(widget.exerciseId);

    if (!mounted) return;

    result.fold(
      (failure) {
        debugPrint('');
        debugPrint('🔴 [UI] Exercise detail loading failed');
        debugPrint('Failure type: ${failure.runtimeType}');
        debugPrint('Failure message: ${failure.message}');
        debugPrint('');

        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
      (exercise) {
        debugPrint('');
        debugPrint('✅ [UI] Successfully loaded exercise: ${exercise.name}');
        debugPrint('');

        setState(() {
          _isLoading = false;
          _exercise = exercise;
        });
      },
    );
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
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exercise Details'),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _errorMessage != null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.error_outline,
                        size: 60,
                        color: AppTheme.getErrorIconColor(context),
                      ),
                      const SizedBox(height: AppConstants.spacingMedium),
                      Text(
                        'Error loading exercise',
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: AppConstants.spacingSmall),
                      Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingXLarge,
                        ),
                        child: Text(
                          _errorMessage!,
                          style: TextStyle(
                              color: AppTheme.getMutedTextColor(context)),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingLarge),
                      ElevatedButton.icon(
                        onPressed: _loadExerciseDetails,
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                      ),
                    ],
                  ),
                )
              : _buildExerciseContent(),
      bottomNavigationBar: AppBottomNavigationBar(
        currentIndex: 1, // Exercises tab
        onTap: _onBottomNavTapped,
      ),
    );
  }

  Widget _buildExerciseContent() {
    final exercise = _exercise!;
    final difficultyColor = AppTheme.getDifficultyColor(exercise.difficultyLevel);

    return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Exercise Instruction Video or Image
          if (exercise.instructionVideoUrl != null)
            ExerciseVideoPlayer(
              videoUrl: exercise.instructionVideoUrl!,
            )
          else if (exercise.imageUrl != null)
            CachedNetworkImage(
              imageUrl: exercise.imageUrl!,
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
                    exercise.name,
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
                    exercise.difficultyLevel.toUpperCase(),
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
                  child: exercise.description != null
                      ? Text(
                          exercise.description!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.getMutedTextColor(context),
                                height: 1.5,
                              ),
                        )
                      : Center(
                          child: Text(
                            'No description available',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.getMutedTextColor(context),
                                ),
                          ),
                        ),
                ),
                // Instructions Tab
                SingleChildScrollView(
                  padding: const EdgeInsets.all(AppConstants.spacingLarge),
                  child: exercise.instructions != null
                      ? Text(
                          exercise.instructions!,
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.getMutedTextColor(context),
                                height: 1.5,
                              ),
                        )
                      : Center(
                          child: Text(
                            'No instructions available',
                            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                  color: AppTheme.getMutedTextColor(context),
                                ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        ],
      );
  }
}