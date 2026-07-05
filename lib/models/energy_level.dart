enum EnergyLevel {
  low,
  medium,
  high,
}

extension EnergyLevelX on EnergyLevel {
  String get label {
    switch (this) {
      case EnergyLevel.low:
        return 'Low';
      case EnergyLevel.medium:
        return 'Medium';
      case EnergyLevel.high:
        return 'High';
    }
  }
}
