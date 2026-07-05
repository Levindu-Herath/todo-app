import '../../models/task.dart';

abstract class TaskRepository {
  Future<List<Task>> getTasks();

  Future<void> upsertTask(Task task);

  Future<void> deleteTask(String taskId);
}
