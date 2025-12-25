import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../core/network/dio_client.dart';
import '../core/theme/app_theme.dart';
import '../features/exercises/data/datasources/exercise_remote_datasource.dart';
import '../features/exercises/data/repositories/exercise_repository_impl.dart';
import '../features/exercises/domain/entities/exercise.dart';
import '../features/exercises/domain/repositories/exercise_repository.dart';
import '../widgets/exercise_video_player.dart';
import 'mountain_climbers_test_screen.dart';

class PlankTestScreen extends StatefulWidget {
  final int squatCount;
  final String pushupType;
  final int pushupCount;
  final int reverseSnowAngelsCount;

  const PlankTestScreen({
    super.key,
    required this.squatCount,
    required this.pushupType,
    required this.pushupCount,
    required this.reverseSnowAngelsCount,
  });

  @override
  State<PlankTestScreen> createState() => _PlankTestScreenState();
}

class _PlankTestScreenState extends State<PlankTestScreen> {
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
    final result = await _exerciseRepository.getExerciseById('plank');

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

  void _showTimeDialog() {
    final TextEditingController controller = TextEditingController();
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
              const Text('How long?'),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Enter how many seconds you held the plank:',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppTheme.getMutedTextColor(context),
                      ),
                ),
                const SizedBox(height: AppConstants.spacingLarge),

                // Error message
                if (errorMessage != null)
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingMedium),
                    margin:
                        const EdgeInsets.only(bottom: AppConstants.spacingMedium),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                      borderRadius:
                          BorderRadius.circular(AppConstants.borderRadiusMedium),
                      border: Border.all(
                        color:
                            Theme.of(context).colorScheme.error.withOpacity(0.5),
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
                            style:
                                Theme.of(context).textTheme.bodySmall?.copyWith(
                                      color: Theme.of(context).colorScheme.error,
                                    ),
                          ),
                        ),
                      ],
                    ),
                  ),

                TextField(
                  controller: controller,
                  autofocus: true,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Time in seconds',
                    hintText: 'e.g., 45',
                    prefixIcon: Icon(
                      Icons.timer,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusMedium,
                      ),
                    ),
                  ),
                  onChanged: (value) {
                    if (errorMessage != null) {
                      setDialogState(() {
                        errorMessage = null;
                      });
                    }
                  },
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
                final seconds = int.tryParse(controller.text);
                if (seconds == null || seconds < 0) {
                  setDialogState(() {
                    errorMessage = 'Please enter a valid number of seconds';
                  });
                } else {
                  Navigator.pop(context);
                  _saveTimeAndContinue(seconds);
                }
              },
              child: const Text('Continue'),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveTimeAndContinue(int seconds) async {
    // TODO: Save to persistent storage (shared preferences or database)
    debugPrint('💾 Saving fitness test data:');
    debugPrint('   Squats: ${widget.squatCount}');
    debugPrint('   Push-ups (${widget.pushupType}): ${widget.pushupCount}');
    debugPrint('   Reverse Snow Angels: ${widget.reverseSnowAngelsCount}');
    debugPrint('   Plank: $seconds seconds');

    // Show success message
    if (!mounted) return;

    final String message = seconds == 0
        ? 'Don\'t worry, everyone starts somewhere! Keep it up! 💪'
        : 'Great job! You held the plank for $seconds seconds 💪';

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: AppTheme.success,
      ),
    );

    // Navigate to mountain climbers test
    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => MountainClimbersTestScreen(
          squatCount: widget.squatCount,
          pushupType: widget.pushupType,
          pushupCount: widget.pushupCount,
          reverseSnowAngelsCount: widget.reverseSnowAngelsCount,
          plankTime: seconds,
        ),
      ),
    );
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
                      'Exercise 4 of 5',
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: Theme.of(context).colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),

                    // Exercise name
                    Text(
                      'Plank',
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
                                  'Hold strong!',
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
                                text:
                                    'Hold the plank position for as long as you can with '),
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
                          context, 'Place your forearms on the floor'),
                      _buildInstructionItem(context,
                          'Keep your body in a straight line from head to heels'),
                      _buildInstructionItem(
                          context, 'Engage your core and glutes'),
                      _buildInstructionItem(context, 'Breathe normally'),
                      const SizedBox(height: AppConstants.spacingXLarge),

                      // Important section
                      _buildSectionTitle(context, 'Important:'),
                      const SizedBox(height: AppConstants.spacingMedium),
                      _buildTipCard(context, Icons.warning_amber_outlined,
                          'Stop when you lose form or feel pain'),
                      const SizedBox(height: AppConstants.spacingSmall),
                      _buildTipCard(context, Icons.info_outline,
                          'You may perform the plank on your knees if needed'),
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
                        : _showTimeDialog,
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