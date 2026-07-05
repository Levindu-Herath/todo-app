import 'package:flutter/foundation.dart';

import '../../models/energy_level.dart';
import '../../models/task.dart';
import '../../services/task/task_repository.dart';

class TaskFormViewModel extends ChangeNotifier {
  TaskFormViewModel(this._taskRepository);

  final TaskRepository _taskRepository;

  EnergyLevel _energy = EnergyLevel.medium;
  EnergyLevel get energy => _energy;

  void setEnergy(EnergyLevel value) {
    _energy = value;
    notifyListeners();
  }

  Future<void> createTask({required String title, String? description}) async {
    final now = DateTime.now().millisecondsSinceEpoch;
    final task = Task(
      id: now.toString(),
      title: title,
      description: description,
      energyLevel: _energy,
      createdAt: DateTime.now(),
    );
    await _taskRepository.upsertTask(task);
  }
}
