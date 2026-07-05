import 'package:flutter/material.dart';

class EnergyColorSet {
  final Color bg;
  final Color text;
  final Color border;
  const EnergyColorSet({required this.bg, required this.text, required this.border});
}

class EnergyColors {
  EnergyColors._();

  static const quickWinLight = EnergyColorSet(
    bg: Color(0xFFFFF3E0), text: Color(0xFFB86E00), border: Color(0xFFFFD180),
  );
  static const quickWinDark = EnergyColorSet(
    bg: Color(0xFF3A2E1A), text: Color(0xFFFFB74D), border: Color(0xFF5C4520),
  );

  static const deepFocusLight = EnergyColorSet(
    bg: Color(0xFFE8EAF6), text: Color(0xFF3949AB), border: Color(0xFF9FA8DA),
  );
  static const deepFocusDark = EnergyColorSet(
    bg: Color(0xFF1A1F3A), text: Color(0xFF7986CB), border: Color(0xFF2A3060),
  );

  static const lowEffortLight = EnergyColorSet(
    bg: Color(0xFFE8F5E9), text: Color(0xFF2E7D32), border: Color(0xFFA5D6A7),
  );
  static const lowEffortDark = EnergyColorSet(
    bg: Color(0xFF1A2E1F), text: Color(0xFF66BB6A), border: Color(0xFF2A4A30),
  );
}