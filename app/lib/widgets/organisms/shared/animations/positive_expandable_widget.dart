// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:expandable/expandable.dart';
import 'package:universal_io/io.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';

class PositiveExpandableWidget extends StatefulWidget {
  const PositiveExpandableWidget({
    required this.collapsedChild,
    required this.expandedChild,
    required this.isExpanded,
    this.backgroundColor = Colors.transparent,
    this.animationDuration = kAnimationDurationRegular,
    this.fadeCurve = kAnimationCurveDefault,
    this.sizeCurve = kAnimationCurveDefault,
    super.key,
  });

  final Widget collapsedChild;
  final Widget expandedChild;
  final bool isExpanded;
  final Color backgroundColor;

  final Duration animationDuration;
  final Curve fadeCurve;
  final Curve sizeCurve;

  @override
  PositiveExpandableWidgetState createState() => PositiveExpandableWidgetState();
}

class PositiveExpandableWidgetState extends State<PositiveExpandableWidget> {
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
  void didUpdateWidget(covariant PositiveExpandableWidget oldWidget) {
    checkExpansionChange();
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    //* Prevent animation timer in test context
    if (Platform.environment.containsKey('FLUTTER_TEST')) {
      return widget.isExpanded ? widget.expandedChild : widget.collapsedChild;
    }

    return Material(
      color: widget.backgroundColor,
      child: Expandable(
        controller: expansionController,
        collapsed: widget.collapsedChild,
        expanded: widget.expandedChild,
        theme: ExpandableThemeData(
          animationDuration: widget.animationDuration,
          fadeCurve: widget.fadeCurve,
          sizeCurve: widget.sizeCurve,
        ),
      ),
    );
  }
}
