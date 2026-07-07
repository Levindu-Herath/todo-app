import 'package:flutter/material.dart';
import '../../models/task.dart';
import '../../models/energy_level.dart';
import '../../services/task/task_repository.dart';

enum EnergyFilter { all, quickWin, deepFocus, lowEffort }

class TaskListViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;

  TaskListViewModel(this._taskRepository) {
    _loadTasks();
  }

  EnergyFilter _filter = EnergyFilter.all;
  EnergyFilter get filter => _filter;

  List<Task> _tasks = [];

  List<Task> get visibleTasks {
    switch (_filter) {
      case EnergyFilter.all:
        return _tasks;
      case EnergyFilter.quickWin:
        return _tasks.where((t) => t.energyLevel == EnergyLevel.quickWin).toList();
      case EnergyFilter.deepFocus:
        return _tasks.where((t) => t.energyLevel == EnergyLevel.deepFocus).toList();
      case EnergyFilter.lowEffort:
        return _tasks.where((t) => t.energyLevel == EnergyLevel.lowEffort).toList();
    }
  }

  // --- Focus mode ---
  bool _isFocusMode = false;
  bool get isFocusMode => _isFocusMode;

  int _focusIndex = 0;

  List<Task> get focusQueue => visibleTasks.where((t) => !t.isCompleted).toList();

  Task? get currentFocusTask {
    final queue = focusQueue;
    if (queue.isEmpty) return null;
    if (_focusIndex >= queue.length) _focusIndex = 0;
    return queue[_focusIndex];
  }

  int get focusRemainingCount => focusQueue.length;
  int get focusPosition => focusQueue.isEmpty ? 0 : _focusIndex + 1;

  void toggleFocusMode() {
    _isFocusMode = !_isFocusMode;
    _focusIndex = 0;
    notifyListeners();
  }

  void exitFocusMode() {
    _isFocusMode = false;
    notifyListeners();
  }

  void skipFocusTask() {
    final queue = focusQueue;
    if (queue.isEmpty) return;
    _focusIndex = (_focusIndex + 1) % queue.length;
    notifyListeners();
  }

  Future<void> completeFocusTask(Task task) async {
    await toggleComplete(task);
    final queue = focusQueue;
    if (_focusIndex >= queue.length) _focusIndex = 0;
  }
  // --- End focus mode ---

  void _loadTasks() {
    _tasks = _taskRepository.getActiveTasks();
    notifyListeners();
  }

  void setFilter(EnergyFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  Future<void> refresh() async {
    _loadTasks();
  }

  Future<void> toggleComplete(Task task) async {
    await _taskRepository.updateTask(
      task.copyWith(
        isCompleted: !task.isCompleted,
        completedAt: !task.isCompleted ? DateTime.now() : null,
      ),
    );
    _loadTasks();
  }

  Future<String> deleteTaskWithUndo(Task task) async {
    await _taskRepository.softDeleteTask(task.id);
    _loadTasks();
    return task.id;
  }

  void undoDelete(String taskId) {
    _taskRepository.restoreTask(taskId).then((_) => _loadTasks());
  }

  Future<void> snoozeTask(Task task) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    await _taskRepository.updateTask(
      task.copyWith(dueDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day)),
    );
    _loadTasks();
  }
}