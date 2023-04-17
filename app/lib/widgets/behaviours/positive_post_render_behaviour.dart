// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

class PositivePostRenderBehaviour extends ConsumerStatefulWidget {
  const PositivePostRenderBehaviour({
    required this.child,
    required this.onPostRender,
    super.key,
  });

  final Widget child;
  final Future<void> Function() onPostRender;

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _PositivePostRenderBehaviourState();
}

class _PositivePostRenderBehaviourState extends ConsumerState<PositivePostRenderBehaviour> {
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((_) => widget.onPostRender());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
