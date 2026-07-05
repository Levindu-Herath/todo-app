import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/utils/routes/app_routes.dart';
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
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Deep focus',
                    selected: viewModel.filter == EnergyFilter.deepFocus,
                    onTap: () => viewModel.setFilter(EnergyFilter.deepFocus),
                  ),
                  const SizedBox(width: 8),
                  _FilterChip(
                    label: 'Low effort',
                    selected: viewModel.filter == EnergyFilter.lowEffort,
                    onTap: () => viewModel.setFilter(EnergyFilter.lowEffort),
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
                itemBuilder: (context, index) {
                  final task = viewModel.visibleTasks[index];
                  return _TaskTile(
                    title: task.title,
                    energyLabel: task.energyLabel,
                    dueLabel: task.dueLabel,
                    isCompleted: task.isCompleted,
                    isDark: isDark,
                    onCheck: () => viewModel.toggleComplete(index),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.accent600,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        onPressed: () {
          // Open task form bottom sheet — next feature
        },
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent600
              : (isDark ? AppColors.darkCard : AppColors.lightCard),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: selected
                ? AppColors.accent600
                : (isDark ? AppColors.darkBorder : AppColors.lightBorder),
          ),
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: selected
                  ? Colors.white
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
