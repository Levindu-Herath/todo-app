import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/service_locator.dart';
import 'features/auth/auth_viewmodel.dart';
import 'features/auth/login_screen.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<AuthViewModel>(
      create: (_) => getIt<AuthViewModel>(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Todo',
        home: const LoginScreen(),
      ),
    );
  }
}