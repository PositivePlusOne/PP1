// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class PositiveTapBehaviour extends StatefulWidget {
  const PositiveTapBehaviour({
    required this.child,
    required this.onTap,
    this.animationDuration = const Duration(milliseconds: 200),
    this.isEnabled = true,
    this.isOpaque = true,
    super.key,
  });

  final Widget child;
  final VoidCallback onTap;
  final Duration animationDuration;

  final bool isEnabled;
  final bool isOpaque;

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
    return IgnorePointer(
      ignoring: !widget.isEnabled,
      child: GestureDetector(
        onTapDown: _onTapDown,
        onTapUp: _onTapUp,
        onTapCancel: _onTapCancel,
        onTap: widget.onTap,
        child: AnimatedOpacity(
          opacity: _isTapped ? 0.5 : 1.0,
          duration: widget.animationDuration,
          child: widget.child,
        ),
      ),
    );
  }
}
