import '../../models/task.dart';
import 'task_repository.dart';

class HiveTaskRepository implements TaskRepository {
  final Map<String, Task> _storage = <String, Task>{};

  @override
  Future<List<Task>> getTasks() async {
    final tasks = _storage.values.toList();
    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return tasks;
  }

  @override
  Future<void> upsertTask(Task task) async {
    _storage[task.id] = task;
  }

  @override
  Future<void> deleteTask(String taskId) async {
    _storage.remove(taskId);
  }
}
