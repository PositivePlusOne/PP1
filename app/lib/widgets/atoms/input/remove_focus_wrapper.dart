import 'package:flutter/material.dart';

/// This is a widget to wrap forms with, it allows the user to dismiss
/// the keyboard when they tap anywhere in the form
class RemoveFocusWrapper extends StatelessWidget {
  final Widget? child;

  const RemoveFocusWrapper({Key? key, this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => _handleTap(context),
      behavior: HitTestBehavior.translucent,
      child: child,
    );
  }

  void _handleTap(BuildContext context) {
    final currentFocus = FocusScope.of(context);
    if (!currentFocus.hasPrimaryFocus && currentFocus.focusedChild != null) {
      currentFocus.focusedChild!.unfocus();
    }
  }
}
