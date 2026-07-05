import 'package:go_router/go_router.dart';
import '../../di/service_locator.dart';
import '../../services/auth/auth_repository.dart';
import '../../features/auth/login_screen.dart';
import '../../features/auth/register_screen.dart';
import '../../features/task_list/task_list_screen.dart';
import 'app_routes.dart';
import 'go_router_refresh_stream.dart';

class AppRouter {
  AppRouter._();

  static final GoRouter router = GoRouter(
    initialLocation: AppRoutes.taskList,
    refreshListenable: GoRouterRefreshStream(
      getIt<AuthRepository>().authStateChanges,
    ),
    redirect: (context, state) {
      final isLoggedIn = getIt<AuthRepository>().currentUser != null;
      final isAuthRoute = state.matchedLocation == AppRoutes.login ||
          state.matchedLocation == AppRoutes.register;

      if (!isLoggedIn && !isAuthRoute) return AppRoutes.login;
      if (isLoggedIn && isAuthRoute) return AppRoutes.taskList;
      return null; // no redirect needed
    },
    routes: [
      GoRoute(
        path: AppRoutes.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.taskList,
        builder: (context, state) => const TaskListScreen(),
      ),
    ],
  );
}