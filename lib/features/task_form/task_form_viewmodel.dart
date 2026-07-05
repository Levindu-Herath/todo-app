import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../models/task.dart';
import '../../models/energy_level.dart';
import '../../services/task/task_repository.dart';

class TaskFormViewModel extends ChangeNotifier {
  final TaskRepository _taskRepository;
  final Task? _editingTask;

  TaskFormViewModel(this._taskRepository, {Task? editingTask})
      : _editingTask = editingTask {
    if (_editingTask != null) {
      _energyLevel = _editingTask.energyLevel;
      _dueDate = _editingTask.dueDate;
    }
  }

  bool get isEditing => _editingTask != null;
  String get initialTitle => _editingTask?.title ?? '';
  String get initialDescription => _editingTask?.description ?? '';

  EnergyLevel _energyLevel = EnergyLevel.lowEffort;
  EnergyLevel get energyLevel => _energyLevel;

  DateTime? _dueDate;
  DateTime? get dueDate => _dueDate;

  bool _isSaving = false;
  bool get isSaving => _isSaving;

  String? _titleError;
  String? get titleError => _titleError;

  void setEnergyLevel(EnergyLevel level) {
    _energyLevel = level;
    notifyListeners();
  }

  void setDueDate(DateTime? date) {
    _dueDate = date;
    notifyListeners();
  }

  void validateTitleOnBlur(String value) {
    _titleError = value.trim().isEmpty ? 'Give this task a title' : null;
    notifyListeners();
  }

  Future<bool> save(String title, String description) async {
    final trimmedTitle = title.trim();
    if (trimmedTitle.isEmpty) {
      _titleError = 'Give this task a title';
      notifyListeners();
      return false;
    }

    _isSaving = true;
    notifyListeners();

    try {
      if (_editingTask != null) {
        await _taskRepository.updateTask(
          _editingTask.copyWith(
            title: trimmedTitle,
            description: description.trim().isEmpty ? null : description.trim(),
            energyLevel: _energyLevel,
            dueDate: _dueDate,
          ),
        );
      } else {
        await _taskRepository.addTask(
          Task(
            id: const Uuid().v4(),
            title: trimmedTitle,
            description: description.trim().isEmpty ? null : description.trim(),
            energyLevel: _energyLevel,
            createdAt: DateTime.now(),
            dueDate: _dueDate,
          ),
        );
      }
      return true;
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }
}