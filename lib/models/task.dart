import 'package:hive/hive.dart';
import 'energy_level.dart';

part 'task.g.dart';

@HiveType(typeId: 0)
class Task extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String title;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final EnergyLevel energyLevel;

  @HiveField(4)
  final bool isCompleted;

  @HiveField(5)
  final bool isDeleted;

  @HiveField(6)
  final DateTime createdAt;

  @HiveField(7)
  final DateTime? completedAt;

  @HiveField(8)
  final DateTime? deletedAt;

  @HiveField(9)
  final DateTime? dueDate;

  Task({
    required this.id,
    required this.title,
    this.description,
    this.energyLevel = EnergyLevel.lowEffort,
    this.isCompleted = false,
    this.isDeleted = false,
    required this.createdAt,
    this.completedAt,
    this.deletedAt,
    this.dueDate,
  });

  Task copyWith({
    String? title,
    String? description,
    EnergyLevel? energyLevel,
    bool? isCompleted,
    bool? isDeleted,
    DateTime? completedAt,
    DateTime? deletedAt,
    DateTime? dueDate,
  }) {
    return Task(
      id: id,
      title: title ?? this.title,
      description: description ?? this.description,
      energyLevel: energyLevel ?? this.energyLevel,
      isCompleted: isCompleted ?? this.isCompleted,
      isDeleted: isDeleted ?? this.isDeleted,
      createdAt: createdAt,
      completedAt: completedAt ?? this.completedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      dueDate: dueDate ?? this.dueDate,
    );
  }
}