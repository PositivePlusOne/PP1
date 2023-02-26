// Flutter imports:
import 'package:flutter/material.dart';

class PositiveScrollBehaviour extends ScrollBehavior {
  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return StretchingOverscrollIndicator(
      axisDirection: details.direction,
      clipBehavior: details.clipBehavior ?? Clip.hardEdge,
      child: child,
    );
  }
}
