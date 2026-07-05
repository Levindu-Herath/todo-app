import '../features/auth/auth_viewmodel.dart';
import '../features/settings/settings_viewmodel.dart';
import '../features/task_form/task_form_viewmodel.dart';
import '../features/task_list/task_list_viewmodel.dart';
import '../features/theme/theme_viewmodel.dart';
import '../services/auth/auth_repository.dart';
import '../services/auth/firebase_auth_repository.dart';
import '../services/biometric/biometric_service.dart';
import '../services/preferences/preferences_service.dart';
import '../services/task/hive_task_repository.dart';
import '../services/task/task_repository.dart';

class ServiceLocator {
  ServiceLocator._();

  static final ServiceLocator instance = ServiceLocator._();

  bool _initialized = false;

  late final AuthRepository authRepository;
  late final TaskRepository taskRepository;
  late final PreferencesService preferencesService;
  late final BiometricService biometricService;

  late final AuthViewModel authViewModel;
  late final TaskListViewModel taskListViewModel;
  late final TaskFormViewModel taskFormViewModel;
  late final SettingsViewModel settingsViewModel;
  late final ThemeViewModel themeViewModel;

  void initialize() {
    if (_initialized) {
      return;
    }

    authRepository = FirebaseAuthRepository();
    taskRepository = HiveTaskRepository();
    preferencesService = PreferencesService();
    biometricService = BiometricService();

    authViewModel = AuthViewModel(authRepository);
    taskListViewModel = TaskListViewModel(taskRepository);
    taskFormViewModel = TaskFormViewModel(taskRepository);
    settingsViewModel = SettingsViewModel(preferencesService);
    themeViewModel = ThemeViewModel(preferencesService);

    _initialized = true;
  }
}
