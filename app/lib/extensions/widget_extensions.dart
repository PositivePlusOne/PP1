// Flutter imports:
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';

extension StateExtensions on State {
  void setStateIfMounted({
    VoidCallback? callback,
  }) {
    if (mounted) {
      setState(callback ?? () {});
    }
  }
}

extension WidgetListExtensions on List<Widget> {
  Widget padded(EdgeInsetsGeometry padding) {
    return Padding(
      padding: padding,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: this,
      ),
    );
  }

  List<Widget> spaceWithVertical(double space) {
    final List<Widget> result = <Widget>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(SizedBox(height: space));
      }
    }

    return result;
  }

  List<Widget> spaceWithHorizontal(double space) {
    final List<Widget> result = <Widget>[];
    for (int i = 0; i < length; i++) {
      result.add(this[i]);
      if (i < length - 1) {
        result.add(SizedBox(width: space));
      }
    }

    return result;
  }

  List<Widget> addSeparatorsToWidgetList({
    required Widget separator,
    bool ignoreLast = false,
    bool assumeSeparators = true,
  }) {
    final List<Widget> result = <Widget>[];
    final int totalLength = length;
    for (int i = 0; i < totalLength; i++) {
      if (i >= length) {
        break;
      }

      final Widget widget = this[i];

      // Assume that if the widget is a SizedBox, then it's a separator.
      if (assumeSeparators && widget is SizedBox) {
        result.add(widget);
        continue;
      }

      result.add(this[i]);
      if (i < length - 1) {
        if (ignoreLast && i == length - 2) {
          continue;
        }

        result.add(separator);
      }
    }

    return result;
  }
}

extension WidgetsBindingExt on WidgetsBinding {
  void addPostFrameCallbackWithAnimationDelay({
    required VoidCallback callback,
    Duration delay = kAnimationDurationEntry,
  }) =>
      addPostFrameCallback((_) async {
        await Future<void>.delayed(delay);
        callback();
      });
}
