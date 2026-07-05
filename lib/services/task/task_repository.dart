import '../../models/task.dart';
import '../../models/energy_level.dart';

abstract class TaskRepository {
  Future<void> addTask(Task task);

  Future<void> updateTask(Task task);

  Future<void> softDeleteTask(String id);

  Future<void> restoreTask(String id);

  Future<void> permanentlyDeleteTask(String id);

  List<Task> getActiveTasks();

  List<Task> getTasksByEnergy(EnergyLevel level);
  
  Task? getTopTask();
}