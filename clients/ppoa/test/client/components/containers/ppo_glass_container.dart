import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';

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
