// import 'package:flutter/material.dart';

// import '../models/energy_level.dart';
// import '../utils/theme/energy_colors.dart';

// class EnergyChipSelector extends StatelessWidget {
//   const EnergyChipSelector({
//     required this.selected,
//     required this.onSelected,
//     super.key,
//   });

//   final EnergyLevel selected;
//   final ValueChanged<EnergyLevel> onSelected;

//   @override
//   Widget build(BuildContext context) {
//     return Wrap(
//       spacing: 8,
//       children: EnergyLevel.values
//           .map(
//             (level) => ChoiceChip(
//               label: Text(level.label),
//               selectedColor: EnergyColors.fromLevel(level).withValues(alpha: 0.25),
//               selected: selected == level,
//               onSelected: (_) => onSelected(level),
//             ),
//           )
//           .toList(),
//     );
//   }
// }
