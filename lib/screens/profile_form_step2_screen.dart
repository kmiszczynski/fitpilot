import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';
import 'profile_form_step3_screen.dart';

class ProfileFormStep2Screen extends StatefulWidget {
  final String name;
  final int age;
  final String sex;

  const ProfileFormStep2Screen({
    super.key,
    required this.name,
    required this.age,
    required this.sex,
  });

  @override
  State<ProfileFormStep2Screen> createState() => _ProfileFormStep2ScreenState();
}

class _ProfileFormStep2ScreenState extends State<ProfileFormStep2Screen> {
  final _authService = AuthService();

  int? _selectedTrainingFrequency;
  String? _selectedTarget;

  bool get _isFormValid =>
      _selectedTrainingFrequency != null && _selectedTarget != null;

  void _onContinue() {
    if (_isFormValid) {
      // Navigate to step 3 with all collected data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ProfileFormStep3Screen(
            name: widget.name,
            age: widget.age,
            sex: widget.sex,
            trainingFrequency: _selectedTrainingFrequency!,
            target: _selectedTarget!,
          ),
        ),
      );
    }
  }

  Future<void> _logout() async {
    await _authService.logout();

    if (!mounted) return;

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => const LoginScreen(title: 'FitPilot'),
      ),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Complete Your Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            // Progress indicator
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingMedium),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.primary,
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                      const SizedBox(width: 4),
                      Expanded(
                        child: Container(
                          height: 4,
                          decoration: BoxDecoration(
                            color: Colors.grey[300],
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppConstants.spacingSmall),
                  Text(
                    'Step 2 of 3',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                ],
              ),
            ),

            // Form content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppConstants.spacingLarge),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Icon(
                      Icons.fitness_center,
                      size: 80,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    const SizedBox(height: AppConstants.spacingLarge),

                    Text(
                      'Your fitness goals',
                      style:
                          Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),

                    Text(
                      'Help us create the perfect plan for you',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            color: Colors.grey[600],
                          ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppConstants.spacingXXLarge),

                    // Training frequency
                    Text(
                      'How often do you want to train per week?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),

                    Row(
                      children: [
                        Expanded(
                          child: _FrequencyCard(
                            frequency: 1,
                            isSelected: _selectedTrainingFrequency == 1,
                            onTap: () {
                              setState(() {
                                _selectedTrainingFrequency = 1;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMedium),
                        Expanded(
                          child: _FrequencyCard(
                            frequency: 2,
                            isSelected: _selectedTrainingFrequency == 2,
                            onTap: () {
                              setState(() {
                                _selectedTrainingFrequency = 2;
                              });
                            },
                          ),
                        ),
                        const SizedBox(width: AppConstants.spacingMedium),
                        Expanded(
                          child: _FrequencyCard(
                            frequency: 3,
                            isSelected: _selectedTrainingFrequency == 3,
                            onTap: () {
                              setState(() {
                                _selectedTrainingFrequency = 3;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingXXLarge),

                    // Target
                    Text(
                      'What is your main goal?',
                      style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),

                    _TargetCard(
                      label: 'Building Strength',
                      icon: Icons.fitness_center,
                      description: 'Increase muscle mass and power',
                      isSelected: _selectedTarget == 'building_strength',
                      onTap: () {
                        setState(() {
                          _selectedTarget = 'building_strength';
                        });
                      },
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),

                    _TargetCard(
                      label: 'Lose Weight',
                      icon: Icons.monitor_weight_outlined,
                      description: 'Burn fat and get leaner',
                      isSelected: _selectedTarget == 'lose_weight',
                      onTap: () {
                        setState(() {
                          _selectedTarget = 'lose_weight';
                        });
                      },
                    ),
                    const SizedBox(height: AppConstants.spacingMedium),

                    _TargetCard(
                      label: 'Improving Endurance',
                      icon: Icons.directions_run,
                      description: 'Build stamina and cardiovascular health',
                      isSelected: _selectedTarget == 'improving_endurance',
                      onTap: () {
                        setState(() {
                          _selectedTarget = 'improving_endurance';
                        });
                      },
                    ),
                    const SizedBox(height: AppConstants.spacingXXLarge),
                  ],
                ),
              ),
            ),

            // Continue button
            Padding(
              padding: const EdgeInsets.all(AppConstants.spacingLarge),
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isFormValid ? _onContinue : null,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      vertical: AppConstants.spacingMedium,
                    ),
                  ),
                  child: const Text(
                    'Continue',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FrequencyCard extends StatelessWidget {
  final int frequency;
  final bool isSelected;
  final VoidCallback onTap;

  const _FrequencyCard({
    required this.frequency,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: AppConstants.spacingLarge,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.grey[100],
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        child: Column(
          children: [
            Text(
              '$frequency',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[700],
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'day${frequency > 1 ? 's' : ''}',
              style: TextStyle(
                fontSize: 12,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TargetCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _TargetCard({
    required this.label,
    required this.icon,
    required this.description,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
      child: Container(
        padding: const EdgeInsets.all(AppConstants.spacingMedium),
        decoration: BoxDecoration(
          color: isSelected
              ? Theme.of(context).colorScheme.primaryContainer
              : Colors.grey[100],
          border: Border.all(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Colors.grey[300]!,
            width: 2,
          ),
          borderRadius: BorderRadius.circular(AppConstants.borderRadiusMedium),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isSelected
                    ? Theme.of(context).colorScheme.primary.withOpacity(0.2)
                    : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 32,
                color: isSelected
                    ? Theme.of(context).colorScheme.primary
                    : Colors.grey[600],
              ),
            ),
            const SizedBox(width: AppConstants.spacingMedium),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[800],
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    description,
                    style: TextStyle(
                      fontSize: 13,
                      color: isSelected
                          ? Theme.of(context).colorScheme.primary
                          : Colors.grey[600],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}