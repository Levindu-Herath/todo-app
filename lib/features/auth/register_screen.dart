import 'package:flutter/material.dart';

import '../../di/service_locator.dart';
import '../../utils/constants/app_strings.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final viewModel = ServiceLocator.instance.authViewModel;

    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.registerTitle)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 420),
            child: AnimatedBuilder(
              animation: viewModel,
              builder: (context, _) {
                return SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: viewModel.isLoading
                        ? null
                        : () async {
                            await viewModel.register(
                              email: 'demo@magadige.app',
                              password: 'password',
                            );
                            if (context.mounted) {
                              Navigator.of(context).pop();
                            }
                          },
                    child: viewModel.isLoading
                        ? const CircularProgressIndicator()
                        : const Text(AppStrings.registerAction),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
