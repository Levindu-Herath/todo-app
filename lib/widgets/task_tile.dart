import 'package:flutter/material.dart';

import '../models/task.dart';
import '../utils/date_utils.dart';
import 'animated_checkbox.dart';

class TaskTile extends StatelessWidget {
  const TaskTile({
    required this.task,
    required this.onToggle,
    required this.onDelete,
    super.key,
  });

  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: AnimatedCheckbox(value: task.isCompleted, onChanged: (_) => onToggle()),
      title: Text(task.title),
      subtitle: Text(AppDateUtils.shortDate(task.createdAt)),
      trailing: IconButton(onPressed: onDelete, icon: const Icon(Icons.delete_outline)),
    );
  }
}
