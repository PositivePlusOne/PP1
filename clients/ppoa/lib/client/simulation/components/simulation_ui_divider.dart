// Flutter imports:
import 'package:flutter/material.dart';

class SimulationUIDivider extends StatelessWidget {
  const SimulationUIDivider({
    required this.isActive,
    this.colour = Colors.amber,
    super.key,
  });

  final bool isActive;
  final Color colour;

  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 2.0,
      color: colour,
      thickness: isActive ? 10.0 : 1.0,
    );
  }
}
