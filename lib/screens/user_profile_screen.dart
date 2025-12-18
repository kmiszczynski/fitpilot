import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../core/theme/app_theme.dart';

class UserProfileScreen extends StatelessWidget {
  const UserProfileScreen({super.key});

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
                'Profile',
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppConstants.spacingLarge),

              // Profile Avatar
              Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundColor: Theme.of(context).colorScheme.primaryContainer,
                  child: Icon(
                    Icons.person,
                    size: 60,
                    color: Theme.of(context).colorScheme.onPrimaryContainer,
                  ),
                ),
              ),
              const SizedBox(height: AppConstants.spacingLarge),

              // Profile Info Cards
              _ProfileInfoCard(
                icon: Icons.person_outline,
                title: 'Personal Information',
                subtitle: 'Name, age, and basic details',
                onTap: () {
                  // TODO: Navigate to edit personal info
                },
              ),
              const SizedBox(height: AppConstants.spacingMedium),

              _ProfileInfoCard(
                icon: Icons.fitness_center,
                title: 'Fitness Goals',
                subtitle: 'Training frequency and targets',
                onTap: () {
                  // TODO: Navigate to edit fitness goals
                },
              ),
              const SizedBox(height: AppConstants.spacingMedium),

              _ProfileInfoCard(
                icon: Icons.home_repair_service_outlined,
                title: 'Equipment',
                subtitle: 'Available exercise equipment',
                onTap: () {
                  // TODO: Navigate to edit equipment
                },
              ),
              const SizedBox(height: AppConstants.spacingLarge),

              // Settings Section
              Text(
                'Settings',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppTheme.getMutedTextColor(context),
                    ),
              ),
              const SizedBox(height: AppConstants.spacingMedium),

              _ProfileInfoCard(
                icon: Icons.notifications_outlined,
                title: 'Notifications',
                subtitle: 'Manage notification preferences',
                onTap: () {
                  // TODO: Navigate to notifications settings
                },
              ),
              const SizedBox(height: AppConstants.spacingMedium),

              _ProfileInfoCard(
                icon: Icons.help_outline,
                title: 'Help & Support',
                subtitle: 'Get help and contact support',
                onTap: () {
                  // TODO: Navigate to help
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ProfileInfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _ProfileInfoCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        side: BorderSide(
          color: AppTheme.getDividerColor(context),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        child: Padding(
          padding: const EdgeInsets.all(AppConstants.spacingMedium),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(
                  icon,
                  color: Theme.of(context).colorScheme.onPrimaryContainer,
                  size: 24,
                ),
              ),
              const SizedBox(width: AppConstants.spacingMedium),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      subtitle,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: AppTheme.getMutedTextColor(context),
                          ),
                    ),
                  ],
                ),
              ),
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