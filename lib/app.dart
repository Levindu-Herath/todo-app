import 'package:flutter/material.dart';

import 'di/service_locator.dart';
import 'features/auth/login_screen.dart';
import 'utils/theme/app_theme.dart';

class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {
    ServiceLocator.instance.initialize();

    return MaterialApp(
      title: 'Todo',
      theme: AppTheme.lightTheme,
      home: const LoginScreen(),
    );
  }
}
