import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../core/network/dio_client.dart';
import '../core/theme/app_theme.dart';
import '../features/exercises/data/datasources/exercise_remote_datasource.dart';
import '../features/exercises/data/repositories/exercise_repository_impl.dart';
import '../features/exercises/domain/entities/exercise.dart';
import '../features/exercises/domain/repositories/exercise_repository.dart';
import '../widgets/exercise_video_player.dart';

class PushupsTestScreen extends StatefulWidget {
  final int squatCount;

  const PushupsTestScreen({
    super.key,
    required this.squatCount,
  });

  @override
  State<PushupsTestScreen> createState() => _PushupsTestScreenState();
}

class _PushupsTestScreenState extends State<PushupsTestScreen> {
  bool _hasStarted = false;
  bool _isFinished = false;

  late final ExerciseRepository _exerciseRepository;
  Exercise? _exercise;
  bool _isLoadingExercise = true;
  String? _exerciseLoadError;

  @override
  void initState() {
    super.initState();
    _exerciseRepository = ExerciseRepositoryImpl(
      ExerciseRemoteDataSourceImpl(DioClient.instance),
    );
    _loadExerciseDetails();
  }

  Future<void> _loadExerciseDetails() async {
    final result = await _exerciseRepository.getExerciseById('pushups');

    if (!mounted) return;

    result.fold(
      (failure) {
        setState(() {
          _isLoadingExercise = false;
          _exerciseLoadError = failure.message;
        });
      },
      (exercise) {
        setState(() {
          _isLoadingExercise = false;
          _exercise = exercise;
        });
      },
    );
  }

  void _startExercise() {
    setState(() {
      _hasStarted = true;
      _isFinished = false;
    });
  }

  void _showPushupDetailsDialog() {
    String? selectedType;
    final TextEditingController repsController = TextEditingController();
    String? errorMessage;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
          ),
          title: Row(
            children: [
              Icon(
                Icons.edit_note,
                color: Theme.of(context).colorScheme.primary,
              ),
              const SizedBox(width: AppConstants.spacingSmall),
              const Text('Push-up details'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
              Text(
                'Select the type of push-ups you performed:',
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppTheme.getMutedTextColor(context),
                    ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),

              // Push-up type selection
              _buildTypeOption(
                context,
                'Classic',
                'Regular push-ups',
                Icons.fitness_center,
                selectedType == 'classic',
                () {
                  setDialogState(() {
                    selectedType = 'classic';
                    errorMessage = null; // Clear error when selection is made
                  });
                },
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              _buildTypeOption(
                context,
                'Knee',
                'Push-ups on knees',
                Icons.accessibility_new,
                selectedType == 'knee',
                () {
                  setDialogState(() {
                    selectedType = 'knee';
                    errorMessage = null; // Clear error when selection is made
                  });
                },
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              _buildTypeOption(
                context,
                'Incline',
                'Hands elevated',
                Icons.trending_up,
                selectedType == 'incline',
                () {
                  setDialogState(() {
                    selectedType = 'incline';
                    errorMessage = null; // Clear error when selection is made
                  });
                },
              ),
              const SizedBox(height: AppConstants.spacingSmall),
              _buildTypeOption(
                context,
                'Wall',
                'Against wall',
                Icons.crop_portrait,
                selectedType == 'wall',
                () {
                  setDialogState(() {
                    selectedType = 'wall';
                    errorMessage = null; // Clear error when selection is made
                  });
                },
              ),

              const SizedBox(height: AppConstants.spacingLarge),

              // Error message
              if (errorMessage != null)
                Container(
                  padding: const EdgeInsets.all(AppConstants.spacingMedium),
                  margin: const EdgeInsets.only(bottom: AppConstants.spacingMedium),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
                    border: Border.all(
                      color: Theme.of(context).colorScheme.error.withOpacity(0.5),
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        Icons.error_outline,
                        color: Theme.of(context).colorScheme.error,
                        size: 20,
                      ),
                      const SizedBox(width: AppConstants.spacingSmall),
                      Expanded(
                        child: Text(
                          errorMessage!,
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Theme.of(context).colorScheme.error,
                              ),
                        ),
                      ),
                    ],
                  ),
                ),

              // Reps input
              TextField(
                controller: repsController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Number of reps',
                  hintText: 'e.g., 15',
                  prefixIcon: Icon(
                    Icons.numbers,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(
                      AppConstants.borderRadiusMedium,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text(
                'Cancel',
                style: TextStyle(
                  color: AppTheme.getMutedTextColor(context),
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                final reps = int.tryParse(repsController.text);
                if (selectedType == null) {
                  setDialogState(() {
                    errorMessage = 'Please select a push-up type';
                  });
                } else if (reps == null || reps < 0) {
                  setDialogState(() {
                    errorMessage = 'Please enter a valid number of reps';
                  });
                } else {
                  Navigator.pop(context);
                  _savePushupDetailsAndContinue(selectedType!, reps);
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeOption(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
    bool isSelected,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primary.withOpacity(0.1)
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : AppTheme.getDividerColor(context),
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isSelected
                  ? Theme.of(context).colorScheme.primary
                  : AppTheme.getIconColor(context),
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          fontWeight:
                              isSelected ? FontWeight.bold : FontWeight.normal,
                        ),
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppTheme.getMutedTextColor(context),
                        ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
              ),
          ],
        ),
      ),
    );
  }

  Future<void> _savePushupDetailsAndContinue(String type, int reps) async {
    // TODO: Save to persistent storage along with squat count
    debugPrint('💾 Saving fitness test data:');
    debugPrint('   Squats: ${widget.squatCount}');
    debugPrint('   Push-ups ($type): $reps');

    // Show success message
    if (!mounted) return;

    final String message = reps == 0
        ? 'Don\'t worry, everyone starts somewhere! Keep it up! 💪'
        : 'Awesome! You did $reps $type push-ups 💪';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
      ),
    );

    // Navigate to next exercise
    // TODO: Navigate to next exercise screen (exercise 3 of 5)
    await Future.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Next exercise coming soon...'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Test'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacingXLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Progress indicator
                    Text(
                      'Exercise 2 of 5',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),

                    // Exercise name
                    Text(
                      'Push-Ups',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: AppConstants.spacingXLarge),

                    // Instruction Video
                    if (_isLoadingExercise)
                      Center(
                        child: Container(
                          height: 200,
                          alignment: Alignment.center,
                          child: const CircularProgressIndicator(),
                        ),
                      )
                    else if (_exercise?.instructionVideoUrl != null)
                      Container(
                        margin: const EdgeInsets.only(
                          bottom: AppConstants.spacingXLarge,
                        ),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge,
                          ),
                          child: ExerciseVideoPlayer(
                            videoUrl: _exercise!.instructionVideoUrl!,
                          ),
                        ),
                      )
                    else if (_exerciseLoadError != null)
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacingLarge),
                        margin: const EdgeInsets.only(
                          bottom: AppConstants.spacingXLarge,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .error
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge,
                          ),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .error
                                .withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.error_outline,
                              color: Theme.of(context).colorScheme.error,
                            ),
                            const SizedBox(width: AppConstants.spacingMedium),
                            Expanded(
                              child: Text(
                                'Could not load video: $_exerciseLoadError',
                                style: Theme.of(context).textTheme.bodySmall,
                              ),
                            ),
                          ],
                        ),
                      ),

                    // In Progress Indicator
                    if (_hasStarted && !_isFinished)
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.only(
                            bottom: AppConstants.spacingXLarge,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.1),
                            border: Border.all(
                              color: Theme.of(context).colorScheme.primary,
                              width: 4,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.self_improvement,
                                  size: 80,
                                  color: Theme.of(context).colorScheme.primary,
                                ),
                                const SizedBox(height: AppConstants.spacingSmall),
                                Text(
                                  'In progress...',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color:
                                            Theme.of(context).colorScheme.primary,
                                      ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Instructions (before start)
                    if (!_hasStarted) ...[
                      _buildSectionTitle(context, 'Goal:'),
                      const SizedBox(height: AppConstants.spacingSmall),
                      RichText(
                        text: TextSpan(
                          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                color: AppTheme.getMutedTextColor(context),
                                height: 1.5,
                              ),
                          children: [
                            const TextSpan(
                                text: 'Perform as many push-ups as you can with '),
                            TextSpan(
                              text: 'good form',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context).colorScheme.primary,
                              ),
                            ),
                            const TextSpan(text: '.'),
                          ],
                        ),
                      ),
                      const SizedBox(height: AppConstants.spacingXLarge),

                      // How to do it section
                      _buildSectionTitle(context, 'How to do it:'),
                      const SizedBox(height: AppConstants.spacingMedium),
                      _buildInstructionItem(
                          context, 'Start in a plank position'),
                      _buildInstructionItem(
                          context, 'Keep your body in a straight line'),
                      _buildInstructionItem(context,
                          'Lower your chest toward the floor, then push back up'),
                      _buildInstructionItem(context,
                          'Choose the hardest variation you can perform safely'),
                      const SizedBox(height: AppConstants.spacingXLarge),

                      // Important section
                      _buildSectionTitle(context, 'Important:'),
                      const SizedBox(height: AppConstants.spacingMedium),
                      _buildTipCard(
                          context,
                          Icons.info_outline,
                          'If you can\'t do a regular push-up, try knee, incline, or wall push-ups'),
                      const SizedBox(height: AppConstants.spacingSmall),
                      _buildTipCard(context, Icons.verified,
                          'Quality matters more than the number of reps'),
                      const SizedBox(height: AppConstants.spacingSmall),
                      _buildTipCard(context, Icons.warning_amber_outlined,
                          'Stop if you feel pain in your shoulders or wrists'),
                      const SizedBox(height: AppConstants.spacingXLarge),

                      // Ready section
                      Container(
                        padding: const EdgeInsets.all(AppConstants.spacingLarge),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .colorScheme
                              .tertiary
                              .withOpacity(0.1),
                          borderRadius: BorderRadius.circular(
                            AppConstants.borderRadiusLarge,
                          ),
                          border: Border.all(
                            color: Theme.of(context)
                                .colorScheme
                                .tertiary
                                .withOpacity(0.3),
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.play_circle_outline,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 32,
                            ),
                            const SizedBox(width: AppConstants.spacingMedium),
                            Expanded(
                              child: Text(
                                'Tap Start when you\'re ready',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],

                    const SizedBox(height: AppConstants.spacingXLarge),
                  ],
                ),
              ),
            ),

            // Bottom Button
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingLarge),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: SafeArea(
                top: false,
                child: SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: !_hasStarted
                        ? _startExercise
                        : _showPushupDetailsDialog,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.spacingLarge,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusLarge,
                        ),
                      ),
                      backgroundColor: _hasStarted ? AppTheme.success : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_hasStarted)
                          Icon(
                            Icons.play_arrow,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Color(0xFF0A0E12),
                          ),
                        if (_hasStarted)
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        const SizedBox(width: AppConstants.spacingSmall),
                        Text(
                          !_hasStarted ? 'Start' : 'I\'m finished',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: _hasStarted ? Colors.white : null,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionTitle(BuildContext context, String title) {
    return Text(
      title,
      style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
    );
  }

  Widget _buildInstructionItem(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 6),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: AppTheme.getMutedTextColor(context),
                    height: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(BuildContext context, IconData icon, String text) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingMedium),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: AppTheme.getDividerColor(context),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: Theme.of(context).colorScheme.secondary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: Text(
              text,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}