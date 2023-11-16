// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class CustomColorSelectionHandle extends TextSelectionControls {
  CustomColorSelectionHandle(this.handleColor) : _controls = Platform.isIOS ? cupertinoTextSelectionControls : materialTextSelectionControls;

  final Color handleColor;
  final TextSelectionControls _controls;

  Widget _wrapWithThemeData(Widget Function(BuildContext) builder) => Platform.isIOS ? CupertinoTheme(data: CupertinoThemeData(primaryColor: handleColor), child: Builder(builder: builder)) : TextSelectionTheme(data: TextSelectionThemeData(selectionHandleColor: handleColor), child: Builder(builder: builder));

  @override
  Widget buildHandle(BuildContext context, TextSelectionHandleType type, double textLineHeight, [VoidCallback? onTap]) => _wrapWithThemeData((BuildContext context) => _controls.buildHandle(context, type, textLineHeight, onTap));

  @override
  Offset getHandleAnchor(TextSelectionHandleType type, double textLineHeight) {
    return _controls.getHandleAnchor(type, textLineHeight);
  }

  @override
  Size getHandleSize(double textLineHeight) {
    return _controls.getHandleSize(textLineHeight);
  }

  @override
  Widget buildToolbar(BuildContext context, Rect globalEditableRegion, double textLineHeight, Offset selectionMidpoint, List<TextSelectionPoint> endpoints, TextSelectionDelegate delegate, ValueListenable<ClipboardStatus>? clipboardStatus, Offset? lastSecondaryTapDownPosition) {
    return _wrapWithThemeData((BuildContext context) => _controls.buildToolbar(context, globalEditableRegion, textLineHeight, selectionMidpoint, endpoints, delegate, null, lastSecondaryTapDownPosition));
  }
}
