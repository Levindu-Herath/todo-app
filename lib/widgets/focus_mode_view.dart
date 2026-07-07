import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../features/task_list/task_list_viewmodel.dart';
import '../models/task.dart';
import '../models/energy_level.dart';
import '../utils/theme/energy_colors.dart';

class FocusModeView extends StatelessWidget {
  final TaskListViewModel viewModel;
  final bool isDark;

  const FocusModeView({super.key, required this.viewModel, required this.isDark});

  EnergyColorSet _colorsFor(EnergyLevel level, bool isDark) {
    switch (level) {
      case EnergyLevel.quickWin:
        return isDark ? EnergyColors.quickWinDark : EnergyColors.quickWinLight;
      case EnergyLevel.deepFocus:
        return isDark ? EnergyColors.deepFocusDark : EnergyColors.deepFocusLight;
      case EnergyLevel.lowEffort:
        return isDark ? EnergyColors.lowEffortDark : EnergyColors.lowEffortLight;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final accentColor = theme.colorScheme.primary;
    final task = viewModel.currentFocusTask;

    if (task == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.celebration_outlined, size: 48, color: accentColor),
              const SizedBox(height: 16),
              Text(
                'All caught up.',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 20),
              TextButton(
                onPressed: viewModel.exitFocusMode,
                child: const Text('← Exit focus mode'),
              ),
            ],
          ),
        ),
      );
    }

    final colors = _colorsFor(task.energyLevel, isDark);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.center_focus_strong, size: 16, color: accentColor),
              const SizedBox(width: 6),
              Text(
                'Focus mode',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: accentColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            '${viewModel.focusPosition} of ${viewModel.focusRemainingCount} remaining',
            style: theme.textTheme.labelSmall,
          ),
          const SizedBox(height: 40),
          GestureDetector(
            onTap: () {
              HapticFeedback.mediumImpact();
              viewModel.completeFocusTask(task);
            },
            child: Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: accentColor, width: 2.5),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Tap the circle to complete',
            style: theme.textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          Text(
            task.title,
            textAlign: TextAlign.center,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: colors.bg,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Text(
              task.energyLevel.label,
              style: TextStyle(fontSize: 11, color: colors.text),
            ),
          ),
          const SizedBox(height: 40),
          OutlinedButton(
            onPressed: viewModel.skipFocusTask,
            style: OutlinedButton.styleFrom(
              foregroundColor: accentColor,
              side: BorderSide(color: accentColor),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            child: const Text('Skip to next'),
          ),
          const SizedBox(height: 16),
          TextButton(
            onPressed: viewModel.exitFocusMode,
            child: Text(
              '← Exit focus mode',
              style: theme.textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }
}