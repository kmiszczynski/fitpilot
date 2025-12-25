import 'dart:async';
import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../core/network/dio_client.dart';
import '../core/theme/app_theme.dart';
import '../features/exercises/data/datasources/exercise_remote_datasource.dart';
import '../features/exercises/data/repositories/exercise_repository_impl.dart';
import '../features/exercises/domain/entities/exercise.dart';
import '../features/exercises/domain/repositories/exercise_repository.dart';
import '../widgets/exercise_video_player.dart';

class MountainClimbersTestScreen extends StatefulWidget {
  final int squatCount;
  final String pushupType;
  final int pushupCount;
  final int reverseSnowAngelsCount;
  final int plankTime;

  const MountainClimbersTestScreen({
    super.key,
    required this.squatCount,
    required this.pushupType,
    required this.pushupCount,
    required this.reverseSnowAngelsCount,
    required this.plankTime,
  });

  @override
  State<MountainClimbersTestScreen> createState() =>
      _MountainClimbersTestScreenState();
}

class _MountainClimbersTestScreenState
    extends State<MountainClimbersTestScreen> {
  bool _isTimerRunning = false;
  bool _isTimerFinished = false;
  int _secondsRemaining = 45;
  Timer? _timer;

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
    final result =
        await _exerciseRepository.getExerciseById('mountain_climbers');

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

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _showCountDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
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
            const Text('How many reps?'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Enter the number of mountain climbers you completed:',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppTheme.getMutedTextColor(context),
                  ),
            ),
            const SizedBox(height: AppConstants.spacingLarge),
            TextField(
              controller: controller,
              autofocus: true,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: 'Number of reps',
                hintText: 'e.g., 30',
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
              final count = int.tryParse(controller.text);
              if (count != null && count >= 0) {
                Navigator.pop(context);
                _saveCountAndFinish(count);
              } else {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Please enter a valid number'),
                    backgroundColor: Colors.red,
                  ),
                );
              }
            },
            child: const Text('Finish'),
          ),
        ],
      ),
    );
  }

  Future<void> _saveCountAndFinish(int count) async {
    // TODO: Save to persistent storage (shared preferences or database)
    debugPrint('💾 Saving fitness test data:');
    debugPrint('   Squats: ${widget.squatCount}');
    debugPrint('   Push-ups (${widget.pushupType}): ${widget.pushupCount}');
    debugPrint('   Reverse Snow Angels: ${widget.reverseSnowAngelsCount}');
    debugPrint('   Plank: ${widget.plankTime} seconds');
    debugPrint('   Mountain Climbers: $count');

    // Show success message
    if (!mounted) return;

    final String message = count == 0
        ? 'Don\'t worry, everyone starts somewhere! Keep it up! 💪'
        : 'Congratulations! You completed the fitness test! 💪';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
        duration: const Duration(seconds: 2),
      ),
    );

    // TODO: Navigate to completion/results screen
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Fitness test completed! Results screen coming soon...'),
      ),
    );
  }

  void _startTimer() {
    setState(() {
      _isTimerRunning = true;
      _secondsRemaining = 45;
      _isTimerFinished = false;
    });

    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_secondsRemaining > 0) {
          _secondsRemaining--;
        } else {
          _timer?.cancel();
          _isTimerRunning = false;
          _isTimerFinished = true;
        }
      });
    });
  }

  void _stopTimer() {
    _timer?.cancel();
    setState(() {
      _isTimerRunning = false;
      _isTimerFinished = true;
    });
  }

  void _showExitConfirmationDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        title: Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: AppTheme.warning,
            ),
            const SizedBox(width: AppConstants.spacingSmall),
            const Text('Exit fitness test?'),
          ],
        ),
        content: Text(
          'Your progress will not be saved.',
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                color: AppTheme.getMutedTextColor(context),
              ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
              Navigator.pop(context); // Exit to plank test
              Navigator.pop(context); // Exit to reverse snow angels
              Navigator.pop(context); // Exit to push-ups test
              Navigator.pop(context); // Exit to squat test
              Navigator.pop(context); // Exit to intro screen
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.warning,
            ),
            child: const Text(
              'Exit Test',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Test'),
        actions: [
          IconButton(
            icon: const Icon(Icons.close),
            onPressed: _showExitConfirmationDialog,
            tooltip: 'Exit test',
          ),
        ],
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
                      'Exercise 5 of 5',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),

                    // Exercise name
                    Text(
                      'Mountain Climbers',
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

                    // Timer Display (when running or finished)
                    if (_isTimerRunning || _isTimerFinished)
                      Center(
                        child: Container(
                          width: 200,
                          height: 200,
                          margin: const EdgeInsets.only(
                            bottom: AppConstants.spacingXLarge,
                          ),
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: _isTimerFinished
                                ? AppTheme.success.withOpacity(0.1)
                                : Theme.of(context)
                                    .colorScheme
                                    .primary
                                    .withOpacity(0.1),
                            border: Border.all(
                              color: _isTimerFinished
                                  ? AppTheme.success
                                  : Theme.of(context).colorScheme.primary,
                              width: 4,
                            ),
                          ),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                if (!_isTimerFinished) ...[
                                  Text(
                                    '$_secondsRemaining',
                                    style: Theme.of(context)
                                        .textTheme
                                        .displayLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .primary,
                                          fontSize: 72,
                                        ),
                                  ),
                                  Text(
                                    'seconds',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                ] else ...[
                                  Icon(
                                    Icons.check_circle,
                                    size: 80,
                                    color: AppTheme.success,
                                  ),
                                  const SizedBox(height: AppConstants.spacingSmall),
                                  Text(
                                    'Time\'s up!',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                          color: AppTheme.success,
                                        ),
                                  ),
                                ],
                              ],
                            ),
                          ),
                        ),
                      ),

                    // Goal section
                    if (!_isTimerRunning && !_isTimerFinished) ...[
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
                                text:
                                    'Perform as many controlled repetitions as you can in '),
                            TextSpan(
                              text: '45 seconds',
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
                          context, 'Start in a high plank position'),
                      _buildInstructionItem(
                          context, 'Bring one knee toward your chest, then switch legs'),
                      _buildInstructionItem(
                          context, 'Keep your core engaged and hips stable'),
                      _buildInstructionItem(context,
                          'Move at a steady, controlled pace'),
                      const SizedBox(height: AppConstants.spacingXLarge),

                      // Tips section
                      _buildSectionTitle(context, 'Tips:'),
                      const SizedBox(height: AppConstants.spacingMedium),
                      _buildTipCard(context, Icons.speed,
                          'Focus on control, not speed'),
                      const SizedBox(height: AppConstants.spacingSmall),
                      _buildTipCard(context, Icons.air,
                          'Breathe steadily'),
                      const SizedBox(height: AppConstants.spacingSmall),
                      _buildTipCard(context, Icons.warning_amber_outlined,
                          'Stop if you feel pain or dizziness'),
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
                              Icons.timer,
                              color: Theme.of(context).colorScheme.tertiary,
                              size: 32,
                            ),
                            const SizedBox(width: AppConstants.spacingMedium),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'You\'ll have 45 seconds',
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleMedium
                                        ?.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Tap Start when you\'re ready',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color:
                                              AppTheme.getMutedTextColor(context),
                                        ),
                                  ),
                                ],
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
                    onPressed: _isTimerRunning
                        ? _stopTimer
                        : _isTimerFinished
                            ? _showCountDialog
                            : _startTimer,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.spacingLarge,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusLarge,
                        ),
                      ),
                      backgroundColor: _isTimerFinished
                          ? AppTheme.success
                          : _isTimerRunning
                              ? AppTheme.warning
                              : null,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (!_isTimerRunning && !_isTimerFinished)
                          Icon(
                            Icons.play_arrow,
                            color: Theme.of(context).brightness == Brightness.light
                                ? Colors.white
                                : Color(0xFF0A0E12),
                          ),
                        if (_isTimerRunning)
                          Icon(
                            Icons.stop,
                            color: Colors.white,
                          ),
                        if (_isTimerFinished)
                          Icon(
                            Icons.check,
                            color: Colors.white,
                          ),
                        const SizedBox(width: AppConstants.spacingSmall),
                        Text(
                          _isTimerRunning
                              ? 'Stop early'
                              : _isTimerFinished
                                  ? 'I\'m finished'
                                  : 'Start',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: (_isTimerFinished || _isTimerRunning)
                                ? Colors.white
                                : null,
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
