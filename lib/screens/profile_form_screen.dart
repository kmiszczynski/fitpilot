import 'package:flutter/material.dart';
import '../constants/app_constants.dart';
import '../services/auth_service.dart';
import 'login_screen.dart';

class ProfileFormScreen extends StatefulWidget {
  const ProfileFormScreen({super.key});

  @override
  State<ProfileFormScreen> createState() => _ProfileFormScreenState();
}

class _ProfileFormScreenState extends State<ProfileFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _authService = AuthService();

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
        automaticallyImplyLeading: false, // Disable back button
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(AppConstants.spacingLarge),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    Icons.person_add,
                    size: 100,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                  const SizedBox(height: AppConstants.spacingLarge),

                  Text(
                    'Create Your Profile',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingMedium),

                  Text(
                    'Please complete your profile to continue',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Colors.grey[600],
                        ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: AppConstants.spacingXXLarge),

                  // Placeholder for profile form fields
                  Container(
                    padding: const EdgeInsets.all(AppConstants.spacingLarge),
                    decoration: BoxDecoration(
                      color: Theme.of(context).colorScheme.secondaryContainer,
                      borderRadius: BorderRadius.circular(
                        AppConstants.borderRadiusLarge,
                      ),
                    ),
                    child: Column(
                      children: [
                        Icon(
                          Icons.construction,
                          size: 48,
                          color:
                              Theme.of(context).colorScheme.onSecondaryContainer,
                        ),
                        const SizedBox(height: AppConstants.spacingMedium),
                        Text(
                          'Profile Form Coming Soon',
                          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSecondaryContainer,
                              ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'We\'re building an amazing profile form for you!',
                          style: TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onSecondaryContainer,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: AppConstants.spacingXXLarge),

                  // Placeholder submit button
                  ElevatedButton(
                    onPressed: () {
                      // TODO: Implement profile creation
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Profile form will be implemented soon'),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                        vertical: AppConstants.spacingMedium,
                      ),
                    ),
                    child: const Text(
                      'Save Profile',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}