import 'package:flutter/material.dart';

class AnimatedCheckbox extends StatelessWidget {
  const AnimatedCheckbox({
    required this.value,
    required this.onChanged,
    super.key,
  });

  final bool value;
  final ValueChanged<bool?> onChanged;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 180),
      child: Checkbox(
        key: ValueKey<bool>(value),
        value: value,
        onChanged: onChanged,
      ),
    );
  }
}
