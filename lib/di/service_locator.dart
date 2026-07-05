import 'package:get_it/get_it.dart';
import 'package:todo_app/features/settings/settings_viewmodel.dart';
import 'package:todo_app/features/task_list/task_list_viewmodel.dart';
import 'package:todo_app/features/theme/theme_viewmodel.dart';
import 'package:todo_app/services/preferences/preferences_service.dart';
import '../services/auth/auth_repository.dart';
import '../services/auth/firebase_auth_repository.dart';
import '../features/auth/auth_viewmodel.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AuthRepository>(() => FirebaseAuthRepository());

  getIt.registerFactory<AuthViewModel>(
    () => AuthViewModel(getIt<AuthRepository>()),
  );

  getIt.registerFactory<TaskListViewModel>(() => TaskListViewModel());

  getIt.registerLazySingleton<PreferencesService>(() => PreferencesService());

  getIt.registerFactory<ThemeViewModel>(
    () => ThemeViewModel(getIt<PreferencesService>()),
  );
  getIt.registerFactory<SettingsViewModel>(
    () =>
        SettingsViewModel(getIt<PreferencesService>(), getIt<AuthRepository>()),
  );
}
