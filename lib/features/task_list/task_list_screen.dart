import 'package:flutter/material.dart';

import '../../di/service_locator.dart';
import '../../utils/constants/app_strings.dart';
import '../../widgets/empty_state.dart';
import '../../widgets/task_tile.dart';
import '../task_form/task_form_screen.dart';

class TaskListScreen extends StatefulWidget {
  const TaskListScreen({super.key});

  @override
  State<TaskListScreen> createState() => _TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen> {
  late final viewModel = ServiceLocator.instance.taskListViewModel;

  @override
  void initState() {
    super.initState();
    viewModel.loadTasks();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text(AppStrings.tasksTitle)),
      body: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          if (viewModel.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (viewModel.tasks.isEmpty) {
            return const EmptyState(
              title: AppStrings.emptyTasksTitle,
              message: AppStrings.emptyTasksMessage,
            );
          }

          return ListView.builder(
            itemCount: viewModel.tasks.length,
            itemBuilder: (context, index) {
              final task = viewModel.tasks[index];
              return TaskTile(
                task: task,
                onToggle: () => viewModel.toggleTask(task),
                onDelete: () => viewModel.removeTask(task.id),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet<void>(
            context: context,
            isScrollControlled: true,
            builder: (_) => const TaskFormScreen(),
          ).then((_) => viewModel.loadTasks());
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
