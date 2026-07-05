import 'package:flutter/foundation.dart';

import '../../models/task.dart';
import '../../services/task/task_repository.dart';

class TaskListViewModel extends ChangeNotifier {
  TaskListViewModel(this._taskRepository);

  final TaskRepository _taskRepository;

  bool _isLoading = false;
  List<Task> _tasks = <Task>[];

  bool get isLoading => _isLoading;
  List<Task> get tasks => List<Task>.unmodifiable(_tasks);

  Future<void> loadTasks() async {
    _isLoading = true;
    notifyListeners();

    _tasks = await _taskRepository.getTasks();

    _isLoading = false;
    notifyListeners();
  }

  Future<void> toggleTask(Task task) async {
    final Task updated = task.copyWith(isCompleted: !task.isCompleted);
    await _taskRepository.upsertTask(updated);
    await loadTasks();
  }

  Future<void> removeTask(String taskId) async {
    await _taskRepository.deleteTask(taskId);
    await loadTasks();
  }
}
