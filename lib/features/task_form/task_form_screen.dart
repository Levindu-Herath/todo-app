import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../di/service_locator.dart';
import '../../models/task.dart';
import '../../models/energy_level.dart';
import '../../utils/theme/energy_colors.dart';
import 'task_form_viewmodel.dart';

Future<void> showTaskFormSheet(BuildContext context, {Task? editingTask}) {
  return showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => ChangeNotifierProvider<TaskFormViewModel>(
      create: (_) => getIt<TaskFormViewModel>(param1: editingTask),
      child: TaskFormScreen(editingTask: editingTask),
    ),
  );
}

class TaskFormScreen extends StatefulWidget {
  final Task? editingTask;
  const TaskFormScreen({super.key, this.editingTask});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  late final TextEditingController _titleController;
  late final TextEditingController _noteController;
  final _titleFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final viewModel = context.read<TaskFormViewModel>();
    _titleController = TextEditingController(text: viewModel.initialTitle);
    _noteController = TextEditingController(text: viewModel.initialDescription);

    _titleFocusNode.addListener(() {
      if (!_titleFocusNode.hasFocus) {
        viewModel.validateTitleOnBlur(_titleController.text);
      }
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _noteController.dispose();
    _titleFocusNode.dispose();
    super.dispose();
  }

  Future<void> _pickDueDate(TaskFormViewModel viewModel) async {
    final current = viewModel.dueDate;
    final picked = await showDatePicker(
      context: context,
      initialDate: current ?? DateTime.now(),
      firstDate: DateTime.now().subtract(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked == null) return;
    final combined = current == null
        ? picked
        : DateTime(picked.year, picked.month, picked.day, current.hour, current.minute);
    viewModel.setDueDate(combined);
  }

  Future<void> _pickDueTime(TaskFormViewModel viewModel) async {
    final current = viewModel.dueDate ?? DateTime.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(current),
    );
    if (picked == null) return;
    final combined = DateTime(
      current.year,
      current.month,
      current.day,
      picked.hour,
      picked.minute,
    );
    viewModel.setDueDate(combined);
  }

  String _formatTime(DateTime date) {
    final hour = date.hour == 0
        ? 12
        : (date.hour > 12 ? date.hour - 12 : date.hour);
    final period = date.hour >= 12 ? 'PM' : 'AM';
    final minute = date.minute.toString().padLeft(2, '0');
    return '$hour:$minute $period';
  }

  Future<void> _handleSave(TaskFormViewModel viewModel) async {
    final success = await viewModel.save(_titleController.text, _noteController.text);
    if (success && mounted) Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final viewModel = context.watch<TaskFormViewModel>();

    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        constraints: BoxConstraints(maxHeight: MediaQuery.of(context).size.height * 0.7),
        decoration: BoxDecoration(
          color: theme.scaffoldBackgroundColor,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 32,
                  height: 4,
                  decoration: BoxDecoration(
                    color: theme.dividerColor,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Text(
                viewModel.isEditing ? 'Edit task' : 'New task',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _titleController,
                focusNode: _titleFocusNode,
                decoration: InputDecoration(
                  hintText: 'What needs to be done?',
                  errorText: viewModel.titleError,
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: _noteController,
                minLines: 1,
                maxLines: 3,
                decoration: const InputDecoration(hintText: 'Add a note (optional)'),
              ),
              const SizedBox(height: 16),
              Text('ENERGY LEVEL', style: theme.textTheme.labelSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: EnergyLevel.values.map((level) {
                  final selected = viewModel.energyLevel == level;
                  final colors = isDark
                      ? _darkColorsFor(level)
                      : _lightColorsFor(level);
                  return ChoiceChip(
                    label: Text(level.label),
                    selected: selected,
                    onSelected: (_) => viewModel.setEnergyLevel(level),
                    backgroundColor: isDark ? Theme.of(context).cardColor : Theme.of(context).cardColor,
                    selectedColor: colors.bg,
                    labelStyle: TextStyle(
                      color: selected ? colors.text : (isDark ? Colors.white70 : Colors.black87),
                      fontSize: 13,
                    ),
                    side: BorderSide(color: selected ? colors.border : theme.dividerColor),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                  );
                }).toList(),
              ),
              const SizedBox(height: 16),
              Text('SCHEDULE', style: theme.textTheme.labelSmall),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () => _pickDueDate(viewModel),
                    icon: const Icon(Icons.calendar_today_outlined, size: 16),
                    label: Text(
                      viewModel.dueDate == null
                          ? 'Set date'
                          : '${viewModel.dueDate!.month}/${viewModel.dueDate!.day}/${viewModel.dueDate!.year}',
                    ),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(140, 40)),
                  ),
                  OutlinedButton.icon(
                    onPressed: () => _pickDueTime(viewModel),
                    icon: const Icon(Icons.access_time_outlined, size: 16),
                    label: Text(
                      viewModel.dueDate == null
                          ? 'Set time'
                          : _formatTime(viewModel.dueDate!),
                    ),
                    style: OutlinedButton.styleFrom(minimumSize: const Size(140, 40)),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: viewModel.isSaving ? null : () => _handleSave(viewModel),
                  child: viewModel.isSaving
                      ? const SizedBox(
                          width: 20, height: 20,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(viewModel.isEditing ? 'Save changes' : 'Add task'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  EnergyColorSet _lightColorsFor(EnergyLevel level) {
    switch (level) {
      case EnergyLevel.quickWin: return EnergyColors.quickWinLight;
      case EnergyLevel.deepFocus: return EnergyColors.deepFocusLight;
      case EnergyLevel.lowEffort: return EnergyColors.lowEffortLight;
    }
  }

  EnergyColorSet _darkColorsFor(EnergyLevel level) {
    switch (level) {
      case EnergyLevel.quickWin: return EnergyColors.quickWinDark;
      case EnergyLevel.deepFocus: return EnergyColors.deepFocusDark;
      case EnergyLevel.lowEffort: return EnergyColors.lowEffortDark;
    }
  }
}