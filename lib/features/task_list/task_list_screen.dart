import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/features/task_form/task_form_screen.dart';
import 'package:todo_app/models/energy_level.dart';
import 'package:todo_app/utils/routes/app_routes.dart';
import 'package:todo_app/utils/theme/energy_colors.dart';
import '../../di/service_locator.dart';
import '../../utils/theme/app_colors.dart';
import 'task_list_viewmodel.dart';

class TaskListScreen extends StatelessWidget {
  const TaskListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<TaskListViewModel>(
      create: (_) => getIt<TaskListViewModel>(),
      child: const _TaskListView(),
    );
  }
}

class _TaskListView extends StatelessWidget {
  const _TaskListView();

  void _showUndoSnackbar(
    BuildContext context,
    TaskListViewModel viewModel,
    String taskId,
  ) {
    final messenger = ScaffoldMessenger.of(context);
    messenger.hideCurrentSnackBar();
    final controller = messenger.showSnackBar(
      SnackBar(
        content: const Text('Task deleted'),
        duration: const Duration(seconds: 5),
        action: SnackBarAction(
          label: 'Undo',
          onPressed: () => viewModel.undoDelete(taskId),
        ),
      ),
    );
    // Safety net: force-close this specific snackbar after 5s in case
    // the built-in duration-based auto-dismiss doesn't fire.
    Future.delayed(const Duration(seconds: 5), () {
      controller.close();
    });
  }

  String? _formatDueDate(DateTime? date) {
    if (date == null) return null;
    final hour = date.hour == 0
        ? 12
        : (date.hour > 12 ? date.hour - 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return 'Due $hour:$minute $period';
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final viewModel = context.watch<TaskListViewModel>();

    return Scaffold(
      backgroundColor: isDark ? AppColors.darkBg : AppColors.lightBg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'My tasks',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w500,
                      color: isDark
                          ? AppColors.darkTextPrimary
                          : AppColors.lightTextPrimary,
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.settings_outlined,
                      color: isDark
                          ? AppColors.darkTextSecondary
                          : AppColors.lightTextSecondary,
                    ),
                    onPressed: () {
                      context.push(AppRoutes.settings);
                    },
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 44,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: [
                  _FilterChip(
                    label: 'All',
                    selected: viewModel.filter == EnergyFilter.all,
                    onTap: () => viewModel.setFilter(EnergyFilter.all),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Quick win',
                    selected: viewModel.filter == EnergyFilter.quickWin,
                    onTap: () => viewModel.setFilter(EnergyFilter.quickWin),
                    energyColors: isDark
                        ? EnergyColors.quickWinDark
                        : EnergyColors.quickWinLight,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Deep focus',
                    selected: viewModel.filter == EnergyFilter.deepFocus,
                    onTap: () => viewModel.setFilter(EnergyFilter.deepFocus),
                    energyColors: isDark
                        ? EnergyColors.deepFocusDark
                        : EnergyColors.deepFocusLight,
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Low effort',
                    selected: viewModel.filter == EnergyFilter.lowEffort,
                    onTap: () => viewModel.setFilter(EnergyFilter.lowEffort),
                    energyColors: isDark
                        ? EnergyColors.lowEffortDark
                        : EnergyColors.lowEffortLight,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'TODAY · ${viewModel.visibleTasks.length} TASKS',
                style: TextStyle(
                  fontSize: 11,
                  letterSpacing: 0.5,
                  color: isDark
                      ? AppColors.darkTextMuted
                      : AppColors.lightTextMuted,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: viewModel.visibleTasks.length,
                separatorBuilder: (_, __) => const SizedBox(height: 8),
                itemBuilder: (itemContext, index) {
                  final task = viewModel.visibleTasks[index];
                  return Slidable(
                    key: ValueKey(task.id),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.25,
                      children: [
                        SlidableAction(
                          onPressed: (_) {
                            HapticFeedback.mediumImpact();
                            viewModel.toggleComplete(task);
                          },
                          backgroundColor: const Color(0xFF2B7A4B),
                          foregroundColor: Colors.white,
                          icon: Icons.check,
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ],
                    ),
                    endActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      extentRatio: 0.5,
                      children: [
                        SlidableAction(
                          onPressed: (_) => viewModel.snoozeTask(task),
                          backgroundColor: const Color(0xFFD4880F),
                          foregroundColor: Colors.white,
                          icon: Icons.schedule,
                          borderRadius: const BorderRadius.horizontal(
                            left: Radius.circular(12),
                          ),
                        ),
                        SlidableAction(
                          onPressed: (_) async {
                            HapticFeedback.heavyImpact();
                            final taskId = await viewModel.deleteTaskWithUndo(
                              task,
                            );
                            // Use the OUTER build() context, not itemContext —
                            // itemContext belongs to this list item, which is
                            // already removed from the tree by the time this
                            // await resolves (task is soft-deleted immediately,
                            // triggering a rebuild that drops this item).
                            if (context.mounted) {
                              _showUndoSnackbar(context, viewModel, taskId);
                            }
                          },
                          backgroundColor: const Color(0xFFE24B4A),
                          foregroundColor: Colors.white,
                          icon: Icons.delete_outline,
                          borderRadius: const BorderRadius.horizontal(
                            right: Radius.circular(12),
                          ),
                        ),
                      ],
                    ),
                    child: _TaskTile(
                      title: task.title,
                      energyLabel: task.energyLevel.label,
                      dueLabel: _formatDueDate(task.dueDate),
                      isCompleted: task.isCompleted,
                      isDark: isDark,
                      onCheck: () => viewModel.toggleComplete(task),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Center(
                child: Text(
                  '↔ Swipe right to complete · left to delete',
                  style: TextStyle(
                    fontSize: 11,
                    color: isDark
                        ? AppColors.darkTextMuted
                        : AppColors.lightTextMuted,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await showTaskFormSheet(context);
          if (context.mounted) {
            context.read<TaskListViewModel>().refresh();
          }
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;
  final EnergyColorSet? energyColors; // null = use accent (for "All")

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.energyColors,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final accentColor = theme.colorScheme.primary;

    final selectedBg = energyColors?.bg ?? accentColor;
    final selectedBorder = energyColors?.border ?? accentColor;
    final selectedText = energyColors != null
        ? energyColors!.text
        : Colors.white;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? selectedBg
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? selectedBorder
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: selected
                  ? selectedText
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.lightTextSecondary),
            ),
          ),
        ),
      ),
    );
  }
}

class _TaskTile extends StatelessWidget {
  final String title;
  final String? energyLabel;
  final String? dueLabel;
  final bool isCompleted;
  final bool isDark;
  final VoidCallback onCheck;

  const _TaskTile({
    required this.title,
    required this.isCompleted,
    required this.isDark,
    required this.onCheck,
    this.energyLabel,
    this.dueLabel,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurface : AppColors.lightSurface,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: onCheck,
            child: Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isCompleted
                    ? const Color(0xFF2B7A4B)
                    : Colors.transparent,
                border: Border.all(
                  color: isCompleted
                      ? const Color(0xFF2B7A4B)
                      : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
                  width: 1.5,
                ),
              ),
              child: isCompleted
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    decoration: isCompleted ? TextDecoration.lineThrough : null,
                    color: isCompleted
                        ? (isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted)
                        : (isDark
                              ? AppColors.darkTextPrimary
                              : AppColors.lightTextPrimary),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    if (energyLabel != null)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F5E9),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          energyLabel!,
                          style: const TextStyle(
                            fontSize: 11,
                            color: Color(0xFF2E7D32),
                          ),
                        ),
                      ),
                    if (dueLabel != null) ...[
                      const SizedBox(width: 8),
                      Text(
                        dueLabel!,
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                    if (isCompleted) ...[
                      const SizedBox(width: 8),
                      Text(
                        'Completed',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark
                              ? AppColors.darkTextMuted
                              : AppColors.lightTextMuted,
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}