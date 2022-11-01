// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:expandable/expandable.dart';

class ExpandableWidget extends StatelessWidget {
  const ExpandableWidget({
    required this.headerChild,
    required this.collapsedChild,
    required this.expandedChild,
    this.isExpanded = false,
    Key? key,
  }) : super(key: key);

  final Widget headerChild;
  final Widget collapsedChild;
  final Widget expandedChild;
  final bool isExpanded;

  @override
  Widget build(BuildContext context) {
    final ExpandableController expansionController = ExpandableController(initialExpanded: isExpanded);
    return ExpandablePanel(
      header: headerChild,
      controller: expansionController,
      collapsed: collapsedChild,
      expanded: expandedChild,
    );
  }
}
