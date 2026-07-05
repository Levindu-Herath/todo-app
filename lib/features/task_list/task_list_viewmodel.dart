import 'package:flutter/material.dart';

enum EnergyFilter { all, quickWin, deepFocus, lowEffort }

class MockTask {
  final String title;
  final String? energyLabel;
  final String? dueLabel;
  final bool isCompleted;

  MockTask({
    required this.title,
    this.energyLabel,
    this.dueLabel,
    this.isCompleted = false,
  });
}

class TaskListViewModel extends ChangeNotifier {
  EnergyFilter _filter = EnergyFilter.all;
  EnergyFilter get filter => _filter;

  final List<MockTask> _tasks = [
    MockTask(title: 'Review pull request for auth module', energyLabel: 'Deep focus', dueLabel: 'Due 2:00 PM'),
    MockTask(title: 'Reply to team standup thread', energyLabel: 'Quick win', dueLabel: 'Due 10:00 AM'),
    MockTask(title: 'Buy groceries for the week', energyLabel: 'Low effort', isCompleted: true),
    MockTask(title: 'Water the plants', energyLabel: 'Low effort'),
  ];

  List<MockTask> get visibleTasks => _tasks;

  void setFilter(EnergyFilter filter) {
    _filter = filter;
    notifyListeners();
  }

  void toggleComplete(int index) {
    notifyListeners();
  }
}