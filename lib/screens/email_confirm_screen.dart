import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/auth/data/datasources/auth_remote_datasource.dart';
import '../features/auth/data/repositories/auth_repository_impl.dart';
import '../features/auth/domain/repositories/auth_repository.dart';
import '../core/utils/navigation_utils.dart';
import '../widgets/app_logo.dart';
import '../widgets/loading_button.dart';
import '../constants/app_constants.dart';

class EmailConfirmScreen extends StatefulWidget {
  final String email;
  final String password;

  const EmailConfirmScreen({
    super.key,
    required this.email,
    required this.password,
  });

  @override
  State<EmailConfirmScreen> createState() => _EmailConfirmScreenState();
}

class _EmailConfirmScreenState extends State<EmailConfirmScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  late final AuthRepository _authRepository;
  bool _isLoading = false;
  bool _isResending = false;

  @override
  void initState() {
    super.initState();
    _authRepository = AuthRepositoryImpl(AuthRemoteDataSourceImpl());
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  Future<void> _confirmCode() async {
    if (_formKey.currentState!.validate()) {
      setState(() => _isLoading = true);

      try {
        final result = await _authRepository.confirmRegistration(
          email: widget.email,
          confirmationCode: _codeController.text.trim(),
        );

        if (!mounted) return;

        result.fold(
          (failure) {
            setState(() => _isLoading = false);
            _showError(failure.message);
          },
          (message) async {
            // Email confirmed, now auto-login
            await _autoLogin();
          },
        );
      } finally {
        if (mounted) setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _autoLogin() async {
    final loginResult = await _authRepository.login(
      email: widget.email,
      password: widget.password,
    );

    if (!mounted) return;

    loginResult.fold(
      (failure) {
        _showWarning('Email confirmed! Please log in. ${failure.message}');
        context.go('/login');
      },
      (tokens) async {
        // Check profile and navigate appropriately
        await NavigationUtils.navigateAfterLogin(context);
      },
    );
  }

  Future<void> _resendCode() async {
    setState(() => _isResending = true);

    try {
      final result = await _authRepository.resendConfirmationCode(widget.email);

      if (!mounted) return;

      result.fold(
        (failure) {
          _showError(failure.message);
        },
        (message) {
          _showSuccess(message);
        },
      );
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.red),
    );
  }

  void _showWarning(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.orange),
    );
  }

  void _showSuccess(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message), backgroundColor: Colors.green),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppLogo(),
                const SizedBox(height: AppConstants.spacingXLarge),
                Text(
                  'Confirm Your Email',
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingSmall),
                Text(
                  'We sent a confirmation code to\n${widget.email}',
                  style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                        color: Colors.grey[600],
                      ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: AppConstants.spacingXLarge),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      TextFormField(
                        controller: _codeController,
                        keyboardType: TextInputType.number,
                        maxLength: AppConstants.confirmationCodeLength,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 8,
                        ),
                        decoration: InputDecoration(
                          labelText: 'Confirmation Code',
                          hintText: '000000',
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(
                              AppConstants.borderRadiusMedium,
                            ),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter the confirmation code';
                          }
                          if (value.length != AppConstants.confirmationCodeLength) {
                            return 'Code must be ${AppConstants.confirmationCodeLength} digits';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: AppConstants.spacingLarge),
                      LoadingButton(
                        label: 'Confirm',
                        onPressed: _confirmCode,
                        isLoading: _isLoading,
                      ),
                      const SizedBox(height: AppConstants.spacingMedium),
                      TextButton(
                        onPressed: _isResending ? null : _resendCode,
                        child: _isResending
                            ? const SizedBox(
                                width: 16,
                                height: 16,
                                child: CircularProgressIndicator(strokeWidth: 2),
                              )
                            : const Text('Resend Code'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}