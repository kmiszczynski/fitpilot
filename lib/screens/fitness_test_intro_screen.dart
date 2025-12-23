import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import 'squat_test_screen.dart';

class FitnessTestIntroScreen extends StatelessWidget {
  const FitnessTestIntroScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fitness Assessment'),
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
                    // Main Title
                    Text(
                      'Fitness Test',
                      style:
                          Theme.of(context).textTheme.headlineLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),

                    // Intro Text
                    Text(
                      'In a moment, you\'ll complete a short fitness test so we can personalize your workouts.',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: AppTheme.getMutedTextColor(context),
                            height: 1.5,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingXLarge),

                    // What you need to know section
                    _buildSectionTitle(context, 'What you need to know:'),
                    const SizedBox(height: AppConstants.spacingMedium),
                    _buildInfoCard(
                      context,
                      icon: Icons.list_alt,
                      title: '5 simple bodyweight exercises',
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    _buildInfoCard(
                      context,
                      icon: Icons.fitness_center_outlined,
                      title: 'No equipment required',
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    _buildInfoCard(
                      context,
                      icon: Icons.timer_outlined,
                      title: 'About 10 minutes total',
                      highlight: true,
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    _buildInfoCard(
                      context,
                      icon: Icons.speed,
                      title: 'Do it at your own pace',
                    ),
                    const SizedBox(height: AppConstants.spacingXLarge),

                    // Why this matters section
                    _buildSectionTitle(context, 'Why this matters:'),
                    const SizedBox(height: AppConstants.spacingMedium),
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingLarge),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(0.05),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusLarge,
                        ),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.1),
                        ),
                      ),
                      child: Text(
                        'The test helps us choose the right difficulty level, keep your training safe, and help you progress over time.',
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                              color: AppTheme.getMutedTextColor(context),
                              height: 1.5,
                            ),
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXLarge),

                    // Important Notice
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingLarge),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .secondary
                            .withOpacity(0.05),
                        borderRadius: BorderRadius.circular(
                          AppConstants.borderRadiusLarge,
                        ),
                        border: Border.all(
                          color: Theme.of(context)
                              .colorScheme
                              .secondary
                              .withOpacity(0.2),
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline,
                            color: Theme.of(context).colorScheme.secondary,
                            size: 24,
                          ),
                          const SizedBox(width: AppConstants.spacingMedium),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'This is not a competition.',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Do your best and stop if anything feels painful.',
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
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SquatTestScreen(),
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
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          'Begin a test',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingSmall),
                        Icon(
                          Icons.arrow_forward,
                          color: Theme.of(context)
                              .elevatedButtonTheme
                              .style
                              ?.foregroundColor
                              ?.resolve({}),
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

  Widget _buildInfoCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    bool highlight = false,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppConstants.spacingMedium,
        vertical: AppConstants.spacingMedium,
      ),
      decoration: BoxDecoration(
        color: highlight
            ? Theme.of(context).colorScheme.tertiary.withOpacity(0.1)
            : Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        border: Border.all(
          color: highlight
              ? Theme.of(context).colorScheme.tertiary.withOpacity(0.3)
              : AppTheme.getDividerColor(context),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: highlight
                ? Theme.of(context).colorScheme.tertiary
                : Theme.of(context).colorScheme.primary,
            size: 24,
          ),
          const SizedBox(width: AppConstants.spacingMedium),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: highlight ? FontWeight.w600 : FontWeight.normal,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}