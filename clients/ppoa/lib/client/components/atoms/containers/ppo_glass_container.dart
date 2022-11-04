// Flutter imports:
import 'package:flutter/material.dart';

class PPOGlassContainer extends StatelessWidget {
  const PPOGlassContainer({
    required this.children,
    this.canDismiss = false,
    this.onDismissRequested,
    super.key,
  });

  final bool canDismiss;
  final Future<void> Function()? onDismissRequested;

  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
