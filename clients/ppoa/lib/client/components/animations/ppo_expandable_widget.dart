// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:expandable/expandable.dart';

class PPOExpandableWidget extends StatefulWidget {
  const PPOExpandableWidget({
    required this.collapsedChild,
    required this.expandedChild,
    required this.isExpanded,
    this.backgroundColor = Colors.transparent,
    Key? key,
  }) : super(key: key);

  final Widget collapsedChild;
  final Widget expandedChild;
  final bool isExpanded;
  final Color backgroundColor;

  @override
  State createState() => _PPOExpandableWidgetState();
}

class _PPOExpandableWidgetState extends State<PPOExpandableWidget> {
  late ExpandableController expansionController;

  @override
  void initState() {
    expansionController = ExpandableController(initialExpanded: widget.isExpanded);
    super.initState();
  }

  void checkExpansionChange() {
    if (!mounted) {
      return;
    }

    final bool requiresExpansion = widget.isExpanded && !expansionController.expanded;
    final bool requiresCollapse = !widget.isExpanded && expansionController.expanded;

    if (requiresExpansion || requiresCollapse) {
      expansionController.toggle();
    }
  }

  @override
  void didUpdateWidget(covariant PPOExpandableWidget oldWidget) {
    checkExpansionChange();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.backgroundColor,
      type: MaterialType.transparency,
      child: Expandable(
        controller: expansionController,
        collapsed: widget.collapsedChild,
        expanded: widget.expandedChild,
      ),
    );
  }
}
