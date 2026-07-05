import 'package:get_it/get_it.dart';
import 'package:todo_app/features/settings/settings_viewmodel.dart';
import 'package:todo_app/features/task_form/task_form_viewmodel.dart';
import 'package:todo_app/features/task_list/task_list_viewmodel.dart';
import 'package:todo_app/features/theme/theme_viewmodel.dart';
import 'package:todo_app/models/task.dart';
import 'package:todo_app/services/preferences/preferences_service.dart';
import 'package:todo_app/services/task/hive_task_repository.dart';
import 'package:todo_app/services/task/task_repository.dart';
import '../services/auth/auth_repository.dart';
import '../services/auth/firebase_auth_repository.dart';
import '../features/auth/auth_viewmodel.dart';

final getIt = GetIt.instance;

void setupServiceLocator() {
  getIt.registerLazySingleton<AuthRepository>(() => FirebaseAuthRepository());

  getIt.registerFactory<AuthViewModel>(
    () => AuthViewModel(getIt<AuthRepository>()),
  );

  getIt.registerLazySingleton<TaskRepository>(() => HiveTaskRepository());

  getIt.registerFactory<TaskListViewModel>(
    () => TaskListViewModel(getIt<TaskRepository>()),
  );

  getIt.registerLazySingleton<PreferencesService>(() => PreferencesService());

  getIt.registerFactory<ThemeViewModel>(
    () => ThemeViewModel(getIt<PreferencesService>()),
  );
  getIt.registerFactory<SettingsViewModel>(
    () =>
        SettingsViewModel(getIt<PreferencesService>(), getIt<AuthRepository>()),
  );

  getIt.registerFactoryParam<TaskFormViewModel, Task?, void>(
    (editingTask, _) =>
        TaskFormViewModel(getIt<TaskRepository>(), editingTask: editingTask),
  );
}