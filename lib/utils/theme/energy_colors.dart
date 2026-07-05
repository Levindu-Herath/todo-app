import 'package:flutter/material.dart';

import '../../models/energy_level.dart';

class EnergyColors {
  static Color fromLevel(EnergyLevel level) {
    switch (level) {
      case EnergyLevel.low:
        return const Color(0xFF90A4AE);
      case EnergyLevel.medium:
        return const Color(0xFFF9A825);
      case EnergyLevel.high:
        return const Color(0xFF2E7D32);
    }
  }
}
