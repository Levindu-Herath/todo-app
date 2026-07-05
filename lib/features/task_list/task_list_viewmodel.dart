import 'dart:async';
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

  final Map<String, Timer> _pendingDeleteTimers = {};

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

  /// Soft-deletes immediately, refreshes the visible list, and starts an
  /// independent 5-second timer for permanent deletion. Returns the task id
  /// so the screen can show an undo snackbar tied to the same id.
  Future<String> deleteTaskWithUndo(Task task) async {
    await _taskRepository.softDeleteTask(task.id);
    _loadTasks();

    _pendingDeleteTimers[task.id]?.cancel();
    _pendingDeleteTimers[task.id] = Timer(const Duration(seconds: 5), () {
      _taskRepository.permanentlyDeleteTask(task.id);
      _pendingDeleteTimers.remove(task.id);
    });

    return task.id;
  }

  void undoDelete(String taskId) {
    _pendingDeleteTimers[taskId]?.cancel();
    _pendingDeleteTimers.remove(taskId);
    _taskRepository.restoreTask(taskId).then((_) => _loadTasks());
  }

  Future<void> snoozeTask(Task task) async {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    await _taskRepository.updateTask(
      task.copyWith(dueDate: DateTime(tomorrow.year, tomorrow.month, tomorrow.day)),
    );
    _loadTasks();
  }

  @override
  void dispose() {
    for (final timer in _pendingDeleteTimers.values) {
      timer.cancel();
    }
    super.dispose();
  }
}