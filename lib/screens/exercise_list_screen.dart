import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../constants/app_constants.dart';
import '../core/network/dio_client.dart';
import '../core/theme/app_theme.dart';
import '../features/exercises/data/datasources/exercise_remote_datasource.dart';
import '../features/exercises/data/repositories/exercise_repository_impl.dart';
import '../features/exercises/domain/entities/exercise.dart';
import '../features/exercises/domain/repositories/exercise_repository.dart';
import 'exercise_detail_screen.dart';

class ExerciseListScreen extends StatefulWidget {
  final ValueChanged<int>? onTabChange;

  const ExerciseListScreen({
    super.key,
    this.onTabChange,
  });

  @override
  State<ExerciseListScreen> createState() => _ExerciseListScreenState();
}

class _ExerciseListScreenState extends State<ExerciseListScreen> {
  late final ExerciseRepository _exerciseRepository;
  List<Exercise>? _exercises;
  bool _isLoading = true;
  String? _errorMessage;
  String? _selectedDifficulty; // null means "All"

  @override
  void initState() {
    super.initState();
    _exerciseRepository = ExerciseRepositoryImpl(
      ExerciseRemoteDataSourceImpl(DioClient.instance),
    );
    _loadExercises();
  }

  Future<void> _loadExercises() async {
    debugPrint('');
    debugPrint('📱 [UI] Loading exercises...');
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    final result = await _exerciseRepository.getExercises();

    if (!mounted) return;

    result.fold(
      (failure) {
        debugPrint('');
        debugPrint('🔴 [UI] Exercise loading failed');
        debugPrint('Failure type: ${failure.runtimeType}');
        debugPrint('Failure message: ${failure.message}');
        debugPrint('');

        setState(() {
          _isLoading = false;
          _errorMessage = failure.message;
        });
      },
      (exercises) {
        debugPrint('');
        debugPrint('✅ [UI] Successfully loaded ${exercises.length} exercises');
        debugPrint('');

        setState(() {
          _isLoading = false;
          _exercises = exercises;
        });
      },
    );
  }

  List<Exercise> _getFilteredExercises() {
    if (_exercises == null) return [];
    if (_selectedDifficulty == null) return _exercises!;

    return _exercises!
        .where((exercise) =>
            exercise.difficultyLevel.toLowerCase() == _selectedDifficulty!.toLowerCase())
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLarge),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'My Exercises',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),
                  Text(
                    'All available exercises',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.getMutedTextColor(context),
                        ),
                  ),
                ],
              ),
            ),

            // Difficulty Filter Chips
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppConstants.spacingLarge,
              ),
              child: Wrap(
                spacing: AppConstants.spacingSmall,
                runSpacing: AppConstants.spacingSmall,
                children: [
                  FilterChip(
                    label: Text(
                      'All',
                      style: TextStyle(
                        color: _selectedDifficulty == null
                            ? Theme.of(context).colorScheme.onPrimary
                            : null,
                      ),
                    ),
                    selected: _selectedDifficulty == null,
                    onSelected: (selected) {
                      setState(() {
                        _selectedDifficulty = null;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text(
                      'Beginner',
                      style: TextStyle(
                        color: _selectedDifficulty?.toLowerCase() == 'beginner'
                            ? Theme.of(context).colorScheme.onPrimary
                            : null,
                      ),
                    ),
                    selected: _selectedDifficulty?.toLowerCase() == 'beginner',
                    onSelected: (selected) {
                      setState(() {
                        _selectedDifficulty = selected ? 'beginner' : null;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text(
                      'Intermediate',
                      style: TextStyle(
                        color: _selectedDifficulty?.toLowerCase() == 'intermediate'
                            ? Theme.of(context).colorScheme.onPrimary
                            : null,
                      ),
                    ),
                    selected: _selectedDifficulty?.toLowerCase() == 'intermediate',
                    onSelected: (selected) {
                      setState(() {
                        _selectedDifficulty = selected ? 'intermediate' : null;
                      });
                    },
                  ),
                  FilterChip(
                    label: Text(
                      'Advanced',
                      style: TextStyle(
                        color: _selectedDifficulty?.toLowerCase() == 'advanced'
                            ? Theme.of(context).colorScheme.onPrimary
                            : null,
                      ),
                    ),
                    selected: _selectedDifficulty?.toLowerCase() == 'advanced',
                    onSelected: (selected) {
                      setState(() {
                        _selectedDifficulty = selected ? 'advanced' : null;
                      });
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),

            // Exercise List
            Expanded(
              child: _isLoading
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
                                'Error loading exercises',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
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
                                  style: TextStyle(color: AppTheme.getMutedTextColor(context)),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              const SizedBox(height: AppConstants.spacingLarge),
                              ElevatedButton.icon(
                                onPressed: _loadExercises,
                                icon: const Icon(Icons.refresh),
                                label: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : Builder(
                          builder: (context) {
                            final filteredExercises = _getFilteredExercises();

                            if (filteredExercises.isEmpty) {
                              return Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.fitness_center,
                                      size: 80,
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary
                                          .withOpacity(0.5),
                                    ),
                                    const SizedBox(
                                        height: AppConstants.spacingLarge),
                                    Text(
                                      _selectedDifficulty == null
                                          ? 'No exercises available'
                                          : 'No ${_selectedDifficulty!.toLowerCase()} exercises found',
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleLarge
                                          ?.copyWith(
                                            color: AppTheme.getMutedTextColor(context),
                                            fontWeight: FontWeight.bold,
                                          ),
                                    ),
                                  ],
                                ),
                              );
                            }

                            return RefreshIndicator(
                              onRefresh: _loadExercises,
                              child: ListView.builder(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: AppConstants.spacingLarge,
                                ),
                                itemCount: filteredExercises.length,
                                itemBuilder: (context, index) {
                                  final exercise = filteredExercises[index];
                                  return _ExerciseListItem(
                                    exercise: exercise,
                                    difficultyColor:
                                        AppTheme.getDifficultyColor(exercise.difficultyLevel),
                                    onTap: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ExerciseDetailScreen(
                                            exercise: exercise,
                                            onTabChange: widget.onTabChange,
                                          ),
                                        ),
                                      );
                                    },
                                  );
                                },
                              ),
                            );
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ExerciseListItem extends StatelessWidget {
  final Exercise exercise;
  final Color difficultyColor;
  final VoidCallback onTap;

  const _ExerciseListItem({
    required this.exercise,
    required this.difficultyColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Row(
            children: [
              // Thumbnail Image
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: exercise.thumbnailImageUrl != null
                    ? CachedNetworkImage(
                        imageUrl: exercise.thumbnailImageUrl!,
                        width: 80,
                        height: 80,
                        fit: BoxFit.cover,
                        placeholder: (context, url) => Container(
                          width: 80,
                          height: 80,
                          color: AppTheme.getPlaceholderColor(context),
                          child: const Center(
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                        ),
                        errorWidget: (context, url, error) => Container(
                          width: 80,
                          height: 80,
                          color: AppTheme.getPlaceholderColor(context),
                          child: Icon(
                            Icons.fitness_center,
                            color: AppTheme.getIconColor(context),
                            size: 32,
                          ),
                        ),
                      )
                    : Container(
                        width: 80,
                        height: 80,
                        color: AppTheme.getPlaceholderColor(context),
                        child: Icon(
                          Icons.fitness_center,
                          color: AppTheme.getIconColor(context),
                          size: 32,
                        ),
                      ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),

              // Exercise Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      exercise.name,
                      style: Theme
                          .of(context)
                          .textTheme
                          .titleMedium
                          ?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: difficultyColor.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(
                          color: difficultyColor.withOpacity(0.3),
                          width: 1,
                        ),
                      ),
                      child: Text(
                        exercise.difficultyLevel.toUpperCase(),
                        style: TextStyle(
                          color: difficultyColor,
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Arrow Icon
              Icon(
                Icons.chevron_right,
                color: AppTheme.getIconColor(context),
              ),
            ],
          ),
        ),
      ),
    );
  }
}