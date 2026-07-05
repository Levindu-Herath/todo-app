import 'energy_level.dart';

class Task {
  const Task({
    required this.id,
    required this.title,
    this.description,
    required this.energyLevel,
    required this.createdAt,
    this.dueDate,
    this.isCompleted = false,
  });

  final String id;
  final String title;
  final String? description;
  final EnergyLevel energyLevel;
  final DateTime createdAt;
  final DateTime? dueDate;
  final bool isCompleted;

  Task copyWith({
    String? id,
    String? title,
    String? description,
    EnergyLevel? energyLevel,
    DateTime? createdAt,
    DateTime? dueDate,
    bool? isCompleted,
  }) {
    return Task(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      energyLevel: energyLevel ?? this.energyLevel,
      createdAt: createdAt ?? this.createdAt,
      dueDate: dueDate ?? this.dueDate,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }
}
