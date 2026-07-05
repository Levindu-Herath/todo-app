import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'di/service_locator.dart';
import 'features/auth/auth_viewmodel.dart';
import 'features/theme/theme_viewmodel.dart';
import 'utils/routes/app_router.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthViewModel>(create: (_) => getIt<AuthViewModel>()),
        ChangeNotifierProvider<ThemeViewModel>(create: (_) => getIt<ThemeViewModel>()),
      ],
      child: Consumer<ThemeViewModel>(
        builder: (context, themeViewModel, _) {
          return MaterialApp.router(
            debugShowCheckedModeBanner: false,
            title: 'Todo',
            themeMode: themeViewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            theme: ThemeData(brightness: Brightness.light, useMaterial3: true),
            darkTheme: ThemeData(brightness: Brightness.dark, useMaterial3: true),
            routerConfig: AppRouter.router,
          );
        },
      ),
    );
  }
}