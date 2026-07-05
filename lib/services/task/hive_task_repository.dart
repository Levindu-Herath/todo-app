import 'package:hive/hive.dart';
import '../../models/task.dart';
import '../../models/energy_level.dart';
import '../../utils/constants/storage_keys.dart';
import 'task_repository.dart';

class HiveTaskRepository implements TaskRepository {
  Box<Task> get _box => Hive.box<Task>(StorageKeys.taskBoxName);

  @override
  Future<void> addTask(Task task) async {
    await _box.put(task.id, task);
  }

  @override
  Future<void> updateTask(Task task) async {
    await _box.put(task.id, task);
  }

  @override
  Future<void> softDeleteTask(String id) async {
    final task = _box.get(id);
    if (task == null) return;
    await _box.put(id, task.copyWith(isDeleted: true, deletedAt: DateTime.now()));
  }

  @override
  Future<void> restoreTask(String id) async {
    final task = _box.get(id);
    if (task == null) return;
    await _box.put(id, task.copyWith(isDeleted: false));
  }

  @override
  Future<void> permanentlyDeleteTask(String id) async {
    await _box.delete(id);
  }

  @override
  List<Task> getActiveTasks() {
    return _box.values.where((t) => !t.isDeleted).toList()
      ..sort((a, b) => a.createdAt.compareTo(b.createdAt));
  }

  @override
  List<Task> getTasksByEnergy(EnergyLevel level) {
    return getActiveTasks().where((t) => t.energyLevel == level).toList();
  }

  @override
  Task? getTopTask() {
    final active = getActiveTasks().where((t) => !t.isCompleted).toList();
    return active.isNotEmpty ? active.first : null;
  }
}