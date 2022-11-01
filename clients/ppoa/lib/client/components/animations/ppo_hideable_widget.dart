// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:expandable/expandable.dart';

class PPOHideableWidget extends StatefulWidget {
  const PPOHideableWidget({
    required this.child,
    this.isHidden = false,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final bool isHidden;

  @override
  State<StatefulWidget> createState() => _PPOHideableWidgetState();
}

class _PPOHideableWidgetState extends State<PPOHideableWidget> {
  late ExpandableController expansionController;

  @override
  void initState() {
    expansionController = ExpandableController(initialExpanded: !widget.isHidden);
    super.initState();
  }

  void checkExpansionChange() {
    if (!mounted) {
      return;
    }

    final bool requiresExpansion = !widget.isHidden && !expansionController.expanded;
    final bool requiresCollapse = widget.isHidden && expansionController.expanded;

    if (requiresExpansion || requiresCollapse) {
      expansionController.toggle();
    }
  }

  @override
  void didUpdateWidget(covariant PPOHideableWidget oldWidget) {
    checkExpansionChange();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Expandable(
      controller: expansionController,
      collapsed: Container(),
      expanded: widget.child,
    );
  }
}
