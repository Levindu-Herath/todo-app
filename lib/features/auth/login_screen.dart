import 'package:flutter/material.dart';

import '../../di/service_locator.dart';
import '../../features/task_list/task_list_screen.dart';
import '../../utils/constants/app_strings.dart';
import 'auth_viewmodel.dart';
import 'register_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthViewModel viewModel = ServiceLocator.instance.authViewModel;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.loginTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AnimatedBuilder(
              animation: viewModel,
              builder: (context, _) {
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: viewModel.isLoading
                            ? null
                            : () async {
                                final bool success = await viewModel.login(
                                  email: 'demo@magadige.app',
                                  password: 'password',
                                );
                                if (!context.mounted || !success) {
                                  return;
                                }
                                Navigator.of(context).pushReplacement(
                                  MaterialPageRoute<void>(
                                    builder: (_) => const TaskListScreen(),
                                  ),
                                );
                              },
                        child: viewModel.isLoading
                            ? const CircularProgressIndicator()
                            : const Text(AppStrings.loginAction),
                      ),
                    ),
                    const SizedBox(height: 12),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute<void>(
                            builder: (_) => const RegisterScreen(),
                          ),
                        );
                      },
                      child: const Text(AppStrings.createAccount),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
