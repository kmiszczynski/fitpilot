import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../constants/app_constants.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../features/profile/data/datasources/profile_remote_datasource.dart';
import '../features/profile/data/repositories/profile_repository_impl.dart';
import '../features/profile/domain/repositories/profile_repository.dart';
import '../features/profile/domain/entities/user_profile.dart';
import '../core/network/dio_client.dart';
import '../services/storage_service.dart';
import '../widgets/loading_overlay.dart';

class ProfileFormStep3Screen extends StatefulWidget {
  final String name;
  final int age;
  final String sex;
  final int trainingFrequency;
  final String target;

  const ProfileFormStep3Screen({
    super.key,
    required this.name,
    required this.age,
    required this.sex,
    required this.trainingFrequency,
    required this.target,
  });

  @override
  State<ProfileFormStep3Screen> createState() => _ProfileFormStep3ScreenState();
}

class _ProfileFormStep3ScreenState extends State<ProfileFormStep3Screen> {
  late final AuthRepository _authRepository;
  late final ProfileRepository _profileRepository;
  bool _isLoading = false;

  final Set<String> _selectedEquipment = {};

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl(AuthRemoteDataSourceImpl());
    _profileRepository = ProfileRepositoryImpl(
      ProfileRemoteDataSourceImpl(DioClient.instance),
    );
  }

  void _toggleEquipment(String equipment) {
    setState(() {
      if (_selectedEquipment.contains(equipment)) {
        _selectedEquipment.remove(equipment);
      } else {
        _selectedEquipment.add(equipment);
      }
    });
  }

  Future<void> _onComplete() async {
    setState(() => _isLoading = true);

    try {
      // Get user email from storage
      final email = await StorageService.getUserEmail();

      if (email == null) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User email not found. Please login again.'),
            backgroundColor: Colors.red,
          ),
        );
        return;
      }

      // Create profile entity with all collected data
      final profile = UserProfile(
        name: widget.name,
        email: email,
        age: widget.age,
        sex: widget.sex,
        trainingFrequency: widget.trainingFrequency,
        target: widget.target,
        equipment: _selectedEquipment.toList(),
      );

      // Debug: Log the profile data being sent
      print('DEBUG - Creating profile with:');
      print('  target: ${widget.target}');
      print('  trainingFrequency: ${widget.trainingFrequency}');
      print('  equipment: ${_selectedEquipment.toList()}');

      // Call profile repository
      final result = await _profileRepository.createProfile(profile);

      if (!mounted) return;

      result.fold(
        (failure) {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(failure.message),
              backgroundColor: Colors.red,
            ),
          );
        },
        (createdProfile) {
          // Profile created successfully, navigate to dashboard
          context.go('/dashboard');
        },
      );
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _logout() async {
    await _authRepository.logout();

    if (!mounted) return;

    context.go('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text('Complete Your Profile'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          tooltip: 'Back',
          onPressed: () => context.pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: Stack(
        children: [
          SafeArea(
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
                                color: Theme.of(context).colorScheme.primary,
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: AppConstants.spacingSmall),
                      Text(
                        'Step 3 of 3',
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
                          Icons.home_repair_service,
                          size: 80,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                        const SizedBox(height: AppConstants.spacingLarge),

                        Text(
                          'Your home equipment',
                          style: Theme.of(context)
                              .textTheme
                              .headlineSmall
                              ?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppConstants.spacingSmall),

                        Text(
                          'Select the equipment you have available',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    color: Colors.grey[600],
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppConstants.spacingXXLarge),

                        Text(
                          'What equipment do you have at home?',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                        ),
                        const SizedBox(height: AppConstants.spacingSmall),
                        Text(
                          'You can select multiple options (optional)',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: Colors.grey[600],
                              ),
                        ),
                        const SizedBox(height: AppConstants.spacingMedium),

                        _EquipmentCard(
                          label: 'Exercise Band',
                          icon: Icons.gesture,
                          description: 'Resistance bands for stretching',
                          isSelected:
                              _selectedEquipment.contains('exercise_band'),
                          onTap: () => _toggleEquipment('exercise_band'),
                        ),
                        const SizedBox(height: AppConstants.spacingMedium),

                        _EquipmentCard(
                          label: 'Exercise Bar',
                          icon: Icons.remove,
                          description: 'Pull-up bar or barbell',
                          isSelected:
                              _selectedEquipment.contains('exercise_bar'),
                          onTap: () => _toggleEquipment('exercise_bar'),
                        ),
                        const SizedBox(height: AppConstants.spacingMedium),

                        _EquipmentCard(
                          label: 'Dumbbells',
                          icon: Icons.fitness_center,
                          description: 'Free weights for various exercises',
                          isSelected: _selectedEquipment.contains('dumbbells'),
                          onTap: () => _toggleEquipment('dumbbells'),
                        ),
                        const SizedBox(height: AppConstants.spacingMedium),

                        _EquipmentCard(
                          label: 'Kettlebell',
                          icon: Icons.remove_circle,
                          description: 'Weight with handle for swings',
                          isSelected: _selectedEquipment.contains('kettlebell'),
                          onTap: () => _toggleEquipment('kettlebell'),
                        ),
                        const SizedBox(height: AppConstants.spacingXXLarge),
                      ],
                    ),
                  ),
                ),

                // Complete button
                Padding(
                  padding: const EdgeInsets.all(AppConstants.spacingLarge),
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _isLoading ? null : _onComplete,
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          vertical: AppConstants.spacingMedium,
                        ),
                      ),
                      child: const Text(
                        'Complete Profile',
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          LoadingOverlay(isLoading: _isLoading),
        ],
      ),
    );
  }
}

class _EquipmentCard extends StatelessWidget {
  final String label;
  final IconData icon;
  final String description;
  final bool isSelected;
  final VoidCallback onTap;

  const _EquipmentCard({
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
            if (isSelected)
              Icon(
                Icons.check_circle,
                color: Theme.of(context).colorScheme.primary,
                size: 28,
              )
            else
              Icon(
                Icons.circle_outlined,
                color: Colors.grey[400],
                size: 28,
              ),
          ],
        ),
      ),
    );
  }
}