import 'package:flutter/material.dart';
import 'package:flutter/gestures.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/widgets/google_sign_button.dart';
import '../../utils/theme/app_colors.dart';
import 'auth_viewmodel.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp(AuthViewModel viewModel) async {
    viewModel.onPasswordChanged(_passwordController.text);
    if (!viewModel.isPasswordValid) return;
    await viewModel.signUp(_emailController.text, _passwordController.text);
    // On success, auth-state listener wrapping the app navigates to task list.
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewModel = context.watch<AuthViewModel>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 40),
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: AppColors.accent600,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Icon(
                  Icons.check_box_outlined,
                  color: Colors.white,
                  size: 24,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Create account',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: isDark
                      ? AppColors.darkTextPrimary
                      : AppColors.lightTextPrimary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Get started for free',
                style: TextStyle(
                  fontSize: 12,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.lightTextSecondary,
                ),
              ),
              const SizedBox(height: 24),
              _RegField(
                controller: _nameController,
                hint: 'Full name',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _RegField(
                controller: _emailController,
                hint: 'Email address',
                isDark: isDark,
              ),
              const SizedBox(height: 12),
              _RegField(
                controller: _passwordController,
                hint: 'Password',
                isDark: isDark,
                obscureText: _obscurePassword,
                onChanged: viewModel.onPasswordChanged,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_off_outlined
                        : Icons.visibility_outlined,
                    size: 18,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),
              if (viewModel.passwordRequirements.isNotEmpty) ...[
                const SizedBox(height: 6),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (final requirement in viewModel.passwordRequirements)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 2),
                        child: Text(
                          requirement,
                          style: TextStyle(
                            fontSize: 10,
                            color: isDark
                                ? AppColors.darkTextMuted
                                : AppColors.lightTextMuted,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
              if (viewModel.status == AuthStatus.error) ...[
                const SizedBox(height: 8),
                Text(
                  viewModel.errorMessage ?? '',
                  style: const TextStyle(fontSize: 11, color: AppColors.error),
                ),
              ],
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.accent600,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: viewModel.status == AuthStatus.loading
                      ? null
                      : () => _handleSignUp(viewModel),
                  child: viewModel.status == AuthStatus.loading
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                      : const Text(
                          'Create account',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      'or',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextMuted
                            : AppColors.lightTextMuted,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: isDark
                          ? AppColors.darkBorder
                          : AppColors.lightBorder,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                height: 48,
                child: GoogleSignButton(
                  isLoading: viewModel.status == AuthStatus.loading,
                  onPressed: () => viewModel.signInWithGoogle(),
                  label:
                      'Sign up with Google', 
                ),
              ),
              const SizedBox(height: 24),
              Center(
                child: RichText(
                  text: TextSpan(
                    style: TextStyle(
                      fontSize: 12,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    children: [
                      const TextSpan(text: 'Already have an account? '),
                      TextSpan(
                        text: 'Sign in',
                        style: const TextStyle(
                          color: AppColors.accent600,
                          fontWeight: FontWeight.w600,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () => Navigator.of(context).pop(),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RegField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool isDark;
  final bool obscureText;
  final Widget? suffixIcon;
  final ValueChanged<String>? onChanged;

  const _RegField({
    required this.controller,
    required this.hint,
    required this.isDark,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      cursorColor: AppColors.oceanAccent600,
      style: TextStyle(
        fontSize: 13,
        color: isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary,
      ),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: isDark ? AppColors.darkTextMuted : AppColors.lightTextMuted,
        ),
        filled: true,
        fillColor: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? AppColors.darkBorder : AppColors.lightBorder,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(
            color: AppColors.oceanAccent600,
            width: 1.5,
          ),
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}
