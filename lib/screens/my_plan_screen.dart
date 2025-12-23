import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../core/theme/app_theme.dart';
import 'fitness_test_intro_screen.dart';

class MyPlanScreen extends StatelessWidget {
  const MyPlanScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppConstants.spacingLarge),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Training Plan',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),

              Text(
                'Your personalized weekly workout schedule',
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: AppTheme.getMutedTextColor(context),
                    ),
              ),
              const SizedBox(height: AppConstants.spacingLarge),

              // Weekly Overview Card
              Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLarge),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(
                            Icons.calendar_today,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          const SizedBox(width: AppConstants.spacingSmall),
                          Text(
                            'This Week',
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingMedium),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          _StatCard(
                            label: 'Completed',
                            value: '0',
                            color: AppTheme.success,
                          ),
                          _StatCard(
                            label: 'Remaining',
                            value: '0',
                            color: AppTheme.warning,
                          ),
                          _StatCard(
                            label: 'Total',
                            value: '0',
                            color: Theme.of(context).colorScheme.primary,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLarge),

              // Placeholder for training plan
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(AppConstants.spacingXLarge),
                      decoration: BoxDecoration(
                        color: Theme.of(context)
                            .colorScheme
                            .primaryContainer
                            .withOpacity(0.3),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.event_note,
                        size: 80,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLarge),

                    Text(
                      'No training plan yet',
                      style: Theme.of(context).textTheme.titleLarge?.copyWith(
                            color: AppTheme.getMutedTextColor(context),
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),

                    Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppConstants.spacingXLarge,
                      ),
                      child: Text(
                        'Your personalized training plan will be generated based on your profile and goals',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                              color: AppTheme.getMutedTextColor(context),
                            ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingXLarge),

                    ElevatedButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const FitnessTestIntroScreen(),
                          ),
                        );
                      },
                      icon: Icon(
                        Icons.auto_awesome,
                        color: Theme.of(context).brightness == Brightness.light
                            ? Colors.white
                            : Color(0xFF0A0E12),
                      ),
                      label: const Text('Generate Plan'),
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppConstants.spacingXLarge,
                          vertical: AppConstants.spacingMedium,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatCard({
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: color,
              ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: AppTheme.getMutedTextColor(context),
              ),
        ),
      ],
    );
  }
}