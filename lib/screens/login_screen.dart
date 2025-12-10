import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../core/utils/navigation_utils.dart';
import '../widgets/app_logo.dart';
import '../widgets/social_login_button.dart';
import '../widgets/custom_text_field.dart';
import '../widgets/loading_button.dart';
import '../widgets/loading_overlay.dart';
import '../constants/app_constants.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key, required this.title});

  final String title;

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  late final AuthRepository _authRepository;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl(AuthRemoteDataSourceImpl());
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _loginWithEmail() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final result = await _authRepository.login(
          email: _emailController.text.trim(),
          password: _passwordController.text,
        );

        if (!mounted) return;

        result.fold(
          (failure) {
            setState(() => _isLoading = false);
            _showError(failure.message);
          },
          (tokens) async {
            // Check profile and navigate appropriately
            await NavigationUtils.navigateAfterLogin(context);
          },
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loginWithFacebook() async {
    setState(() => _isLoading = true);

    try {
      final result = await _authRepository.loginWithFacebook();

      if (!mounted) return;

      result.fold(
        (failure) {
          setState(() => _isLoading = false);
          _showError(failure.message);
        },
        (tokens) async {
          await NavigationUtils.navigateAfterLogin(context);
        },
      );
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _loginWithGoogle() async {
    setState(() => _isLoading = true);

    try {
      final result = await _authRepository.loginWithGoogle();

      if (!mounted) return;

      result.fold(
        (failure) {
          setState(() => _isLoading = false);
          _showError(failure.message);
        },
        (tokens) async {
          await NavigationUtils.navigateAfterLogin(context);
        },
      );
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  void _navigateToRegister() {
    context.go('/register');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const AppLogo(),
                    const SizedBox(height: AppConstants.spacingXXLarge),

                    // Social login buttons
                    SocialLoginButton.facebook(
                      onPressed: _isLoading ? null : _loginWithFacebook,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: AppConstants.spacingSmall),
                    SocialLoginButton.google(
                      onPressed: _isLoading ? null : _loginWithGoogle,
                      isLoading: _isLoading,
                    ),
                    const SizedBox(height: AppConstants.spacingLarge),

                    // Divider
                    Row(
                      children: [
                        Expanded(child: Divider(color: Colors.grey[400])),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          child: Text(
                            'OR',
                            style: TextStyle(
                              color: Colors.grey[600],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                        Expanded(child: Divider(color: Colors.grey[400])),
                      ],
                    ),
                    const SizedBox(height: AppConstants.spacingLarge),

                    // Email/Password form
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          CustomTextField(
                            controller: _emailController,
                            labelText: 'Email',
                            prefixIcon: Icons.email_outlined,
                            keyboardType: TextInputType.emailAddress,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your email';
                              }
                              if (!value.contains('@')) {
                                return 'Please enter a valid email';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppConstants.spacingMedium),
                          PasswordTextField(
                            controller: _passwordController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your password';
                              }
                              if (value.length < AppConstants.passwordMinLength) {
                                return 'Password must be at least ${AppConstants.passwordMinLength} characters';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: AppConstants.spacingLarge),
                          LoadingButton(
                            label: 'Sign In',
                            onPressed: _loginWithEmail,
                            isLoading: _isLoading,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: AppConstants.spacingLarge),

                    // Register link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                        TextButton(
                          onPressed: _navigateToRegister,
                          child: const Text(
                            'Register',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          LoadingOverlay(isLoading: _isLoading),
        ],
      ),
    );
  }
}