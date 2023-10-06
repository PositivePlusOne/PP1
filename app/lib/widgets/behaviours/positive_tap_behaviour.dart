// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class PositiveTapBehaviour extends StatefulWidget {
  const PositiveTapBehaviour({
    required this.child,
    this.onTap,
    this.animationDuration = const Duration(milliseconds: 200),
    this.isEnabled = true,
    this.showDisabledState = false,
    super.key,
  });

  final Widget child;
  final FutureOr<void> Function(BuildContext context)? onTap;
  final Duration animationDuration;

  final bool isEnabled;
  final bool showDisabledState;

  @override
  PositiveTapBehaviourState createState() => PositiveTapBehaviourState();
}

class PositiveTapBehaviourState extends State<PositiveTapBehaviour> {
  bool _isTapped = false;

  void _onTapDown(TapDownDetails details) {
    setState(() {
      _isTapped = true;
    });
  }

  void _onTapUp(TapUpDetails details) {
    HapticFeedback.lightImpact();
    setState(() {
      _isTapped = false;
    });
  }

  void _onTapCancel() {
    setState(() {
      _isTapped = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    double opacity = _isTapped ? 0.5 : 1.0;
    if (widget.showDisabledState) {
      opacity = 0.5;
    }

    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: () => widget.onTap?.call(context),
        child: AnimatedOpacity(
          opacity: opacity,
          duration: widget.animationDuration,
          child: widget.child,
        ),
      ),
    );
  }
}
