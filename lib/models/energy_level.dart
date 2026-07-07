import 'package:hive/hive.dart';

part 'energy_level.g.dart';

@HiveType(typeId: 1)
enum EnergyLevel {
  @HiveField(0)
  quickWin,

  @HiveField(1)
  deepFocus,

  @HiveField(2)
  lowEffort,
}

extension EnergyLevelLabel on EnergyLevel {
  String get label {
    switch (this) {
      case EnergyLevel.quickWin:
        return 'Quick win';
      case EnergyLevel.deepFocus:
        return 'Deep focus';
      case EnergyLevel.lowEffort:
        return 'Low effort';
    }
  }
}