import 'package:flutter/material.dart';

import '../../di/service_locator.dart';
import '../../utils/constants/app_strings.dart';
import '../../utils/theme/app_spacing.dart';
import '../../widgets/energy_chip_selector.dart';

class TaskFormScreen extends StatefulWidget {
  const TaskFormScreen({super.key});

  @override
  State<TaskFormScreen> createState() => _TaskFormScreenState();
}

class _TaskFormScreenState extends State<TaskFormScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  late final viewModel = ServiceLocator.instance.taskFormViewModel;

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.m,
        AppSpacing.m,
        AppSpacing.m,
        AppSpacing.m + bottomInset,
      ),
      child: AnimatedBuilder(
        animation: viewModel,
        builder: (context, _) {
          return Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: AppStrings.taskTitle),
              ),
              const SizedBox(height: AppSpacing.s),
              TextField(
                controller: _descriptionController,
                minLines: 2,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: AppStrings.taskDescription,
                ),
              ),
              const SizedBox(height: AppSpacing.m),
              EnergyChipSelector(
                selected: viewModel.energy,
                onSelected: viewModel.setEnergy,
              ),
              const SizedBox(height: AppSpacing.m),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    if (_titleController.text.trim().isEmpty) {
                      return;
                    }

                    await viewModel.createTask(
                      title: _titleController.text.trim(),
                      description: _descriptionController.text.trim(),
                    );

                    if (context.mounted) {
                      Navigator.of(context).pop();
                    }
                  },
                  child: const Text(AppStrings.saveTask),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
