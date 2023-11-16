// Flutter imports:
import 'package:flutter/material.dart';

// Returns me a widget with a size callback that returns the size of the widget
class PositiveMeasureBehaviour extends StatelessWidget {
  const PositiveMeasureBehaviour({
    required this.child,
    required this.onMeasure,
    Key? key,
  }) : super(key: key);

  final Widget child;
  final Function(Size) onMeasure;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (constraints.maxHeight > 0 && constraints.maxWidth > 0) {
            onMeasure(constraints.biggest);
          }
        });
        return child;
      },
    );
  }
}
