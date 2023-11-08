// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:custom_refresh_indicator/custom_refresh_indicator.dart';
import 'package:flutter_svg/flutter_svg.dart';

// Project imports:
import 'package:app/resources/resources.dart';

class PositiveRefreshIndicator extends StatelessWidget {
  const PositiveRefreshIndicator({
    required this.controller,
    required this.child,
    required this.onRefresh,
    super.key,
  });

  final Widget child;
  final VoidCallback onRefresh;
  final IndicatorController controller;

  @override
  Widget build(BuildContext context) {
    // return CustomRefreshIndicator(
    //   onRefresh: () async => onRefresh(),
    //   controller: controller,
    //   trigger: IndicatorTrigger.trailingEdge,
    //   trailingScrollIndicatorVisible: false,
    //   leadingScrollIndicatorVisible: true,
    //   child: child,
    //   builder: (BuildContext context, Widget child, IndicatorController controller) {
    //     controller.
    //   },
    // );
    return child;
  }
}
