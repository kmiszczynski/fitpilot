import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import '../features/fitness_test/data/models/fitness_test_response_model.dart';
import '../features/fitness_test/domain/models/category_info.dart';
import 'squat_test_screen.dart';

class FitnessTestSummaryScreen extends StatelessWidget {
  final FitnessTestResponseModel testResponse;

  const FitnessTestSummaryScreen({
    super.key,
    required this.testResponse,
  });

  String _formatGlobalLevel(String level) {
    return level
        .split('_')
        .map((word) => word[0].toUpperCase() + word.substring(1).toLowerCase())
        .join(' ');
  }

  List<MapEntry<String, String>> _getStrengths() {
    return testResponse.levels.perCategory.entries
        .where((entry) =>
            entry.value == 'ADVANCED' || entry.value == 'INTERMEDIATE')
        .toList();
  }

  List<MapEntry<String, String>> _getWeaknesses() {
    return testResponse.levels.perCategory.entries
        .where((entry) => entry.value == 'BEGINNER')
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    final strengths = _getStrengths();
    final weaknesses = _getWeaknesses();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Results'),
        automaticallyImplyLeading: false,
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
                    // Header
                    Text(
                      'Your Personalized Results ✨',
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: AppConstants.spacingLarge),

                    // Overall Level Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(AppConstants.spacingLarge),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: [
                            Theme.of(context).colorScheme.primary,
                            Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.8),
                          ],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusLarge,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Theme.of(context)
                                .colorScheme
                                .primary
                                .withOpacity(0.3),
                            blurRadius: 12,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Text(
                            'Overall Fitness Level',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.9),
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: AppConstants.spacingSmall),
                          Text(
                            _formatGlobalLevel(
                                testResponse.levels.globalLevel),
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXLarge),

                    // Introduction
                    Text(
                      'You\'ve just completed a full-body fitness assessment — great work.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),
                    Text(
                      'Based on your results, we\'ve analyzed how your body performs across key movement patterns and created a plan tailored specifically to you.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.getMutedTextColor(context),
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),
                    Text(
                      'This is not a generic program. It\'s designed around your current abilities, so you can train safely and make real progress.',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.getMutedTextColor(context),
                            height: 1.6,
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingXXLarge),

                    // Strengths Section
                    if (strengths.isNotEmpty) ...[
                      Row(
                        children: [
                          const Text('💪', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: AppConstants.spacingSmall),
                          Text(
                            'Where You\'re Strong',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingLarge),
                      ...strengths.map((entry) {
                        final info = CategoryInfo.categoryMapping[entry.key];
                        if (info == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppConstants.spacingLarge),
                          child: _buildStrengthCard(
                            context,
                            info.strengthTitle,
                            info.strengthReason,
                          ),
                        );
                      }),
                      Text(
                        'These areas give you a solid foundation to build on.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.getMutedTextColor(context),
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: AppConstants.spacingXXLarge),
                    ],

                    // Weaknesses Section
                    if (weaknesses.isNotEmpty) ...[
                      Row(
                        children: [
                          const Text('🎯', style: TextStyle(fontSize: 24)),
                          const SizedBox(width: AppConstants.spacingSmall),
                          Text(
                            'Where We\'ll Focus Next',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingLarge),
                      ...weaknesses.map((entry) {
                        final info = CategoryInfo.categoryMapping[entry.key];
                        if (info == null) return const SizedBox.shrink();
                        return Padding(
                          padding: const EdgeInsets.only(
                              bottom: AppConstants.spacingLarge),
                          child: _buildWeaknessCard(
                            context,
                            info.weaknessTitle,
                            info.weaknessReason,
                          ),
                        );
                      }),
                      Text(
                        'This doesn\'t mean you\'re "bad" at it — it simply shows where the biggest improvements can happen with the right approach.',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.getMutedTextColor(context),
                              fontStyle: FontStyle.italic,
                              height: 1.5,
                            ),
                      ),
                      const SizedBox(height: AppConstants.spacingXXLarge),
                    ],

                    // Your Plan Section
                    Text(
                      'Your Plan Is Ready',
                      style:
                          Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: AppConstants.spacingLarge),
                    Text(
                      'Using your test results, we\'ve prepared a training plan that:',
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                            color: AppTheme.getMutedTextColor(context),
                            height: 1.6,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),
                    _buildBulletPoint(context,
                        'matches your exact fitness level'),
                    _buildBulletPoint(context,
                        'adapts exercise difficulty to your strengths and limits'),
                    _buildBulletPoint(
                        context, 'progresses gradually, week by week'),
                    _buildBulletPoint(context,
                        'helps you improve weak areas without overloading your body'),
                    const SizedBox(height: AppConstants.spacingXLarge),

                    // CTA Box
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingLarge),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.5),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusLarge,
                        ),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.3),
                          width: 2,
                        ),
                      ),
                      child: Row(
                        children: [
                          const Text('🔒', style: TextStyle(fontSize: 32)),
                          const SizedBox(width: AppConstants.spacingMedium),
                          Expanded(
                            child: Text(
                              'Unlock your personalized training plan and start your first workout today.',
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.w500,
                                    height: 1.5,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXXLarge),
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
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          // TODO: Navigate to subscription/unlock screen
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Unlock plan feature coming soon...'),
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                            vertical: AppConstants.spacingLarge,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusLarge,
                            ),
                          ),
                        ),
                        child: const Text(
                          'Unlock My Plan',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).popUntil((route) => route.isFirst);
                      },
                      child: Text(
                        'Cancel anytime.',
                        style: TextStyle(
                          color: AppTheme.getMutedTextColor(context),
                        ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    TextButton(
                      onPressed: () => _showRepeatTestDialog(context),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.refresh,
                            size: 18,
                            color: AppTheme.getMutedTextColor(context),
                          ),
                          const SizedBox(width: AppConstants.spacingSmall),
                          Text(
                            'Repeat Test',
                            style: TextStyle(
                              color: AppTheme.getMutedTextColor(context),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStrengthCard(
      BuildContext context, String title, String reason) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: AppTheme.success.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: AppTheme.success.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppTheme.success.withOpacity(0.9),
                ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            reason,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeaknessCard(
      BuildContext context, String title, String reason) {
    return Container(
      padding: const EdgeInsets.all(AppConstants.spacingLarge),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.secondary.withOpacity(0.1),
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: Theme.of(context).colorScheme.secondary.withOpacity(0.3),
          width: 1.5,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.secondary,
                ),
          ),
          const SizedBox(height: AppConstants.spacingSmall),
          Text(
            reason,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  height: 1.5,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppConstants.spacingSmall),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 8),
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
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
            ),
          ),
        ],
      ),
    );
  }

  void _showRepeatTestDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusLarge),
        ),
        title: const Row(
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Colors.orange,
              size: 28,
            ),
            SizedBox(width: AppConstants.spacingSmall),
            Flexible(
              child: Text('Repeat Fitness Test?'),
            ),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Are you sure you want to repeat the fitness test from the beginning?',
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    height: 1.5,
                  ),
            ),
            const SizedBox(height: AppConstants.spacingMedium),
            Container(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.error.withOpacity(0.1),
                borderRadius:
                    BorderRadius.circular(AppConstants.borderRadiusMedium),
                border: Border.all(
                  color: Theme.of(context).colorScheme.error.withOpacity(0.3),
                  width: 1.5,
                ),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.info_outline,
                    size: 20,
                    color: Theme.of(context).colorScheme.error,
                  ),
                  const SizedBox(width: AppConstants.spacingSmall),
                  Expanded(
                    child: Text(
                      'Your current test results will be replaced with the new test results.',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Theme.of(context).colorScheme.error,
                            height: 1.4,
                          ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(),
            child: Text(
              'Cancel',
              style: TextStyle(
                color: AppTheme.getMutedTextColor(context),
              ),
            ),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(dialogContext).pop();
              // Navigate back to home first, then to squat test
              Navigator.of(context).popUntil((route) => route.isFirst);
              // Navigate to the first test screen (squats)
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => const SquatTestScreen(),
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.error,
              foregroundColor: Colors.white,
            ),
            child: const Text('Repeat Test'),
          ),
        ],
      ),
    );
  }
}
