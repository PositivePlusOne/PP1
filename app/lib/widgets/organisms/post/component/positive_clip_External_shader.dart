import 'package:app/constants/design_constants.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';

class PositiveClipExternalShader extends StatefulWidget {
  const PositiveClipExternalShader({
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingTop,
    required this.paddingBottom,
    required this.colour,
    required this.radius,
    super.key,
  });

  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  final Color colour;
  final double radius;

  @override
  State<PositiveClipExternalShader> createState() => _PositiveClipExternalShaderState();
}

class _PositiveClipExternalShaderState extends State<PositiveClipExternalShader> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation topPaddingAnimation;

  late Tween<double> topPaddingTween;
  late Tween<double> bottomPaddingTween;
  late Tween<double> leftPaddingTween;
  late Tween<double> rightPaddingTween;

  late ColorTween colourTween;
  late Tween<double> radiusTween;

  @override
  void didUpdateWidget(covariant PositiveClipExternalShader oldWidget) {
    if (widget != oldWidget) {
      bool needsRebuild = false;

      if (widget.paddingTop != oldWidget.paddingTop) {
        //? Top Padding Change
        topPaddingTween.begin = oldWidget.paddingTop;
        topPaddingTween.end = widget.paddingTop;
        needsRebuild = true;
      }

      if (widget.paddingBottom != oldWidget.paddingBottom) {
        //? Bottom Padding Change
        bottomPaddingTween.begin = oldWidget.paddingBottom;
        bottomPaddingTween.end = widget.paddingBottom;
        needsRebuild = true;
      }

      if (widget.paddingRight != oldWidget.paddingRight) {
        //? Right Padding Change
        rightPaddingTween.begin = oldWidget.paddingRight;
        rightPaddingTween.end = widget.paddingRight;
        needsRebuild = true;
      }

      if (widget.paddingLeft != oldWidget.paddingLeft) {
        //? Left Padding Change
        leftPaddingTween.begin = oldWidget.paddingLeft;
        leftPaddingTween.end = widget.paddingLeft;
        needsRebuild = true;
      }

      if (widget.colour != oldWidget.colour) {
        //? Colour Change
        colourTween.begin = oldWidget.colour;
        colourTween.end = widget.colour;
        needsRebuild = true;
      }

      if (widget.radius != oldWidget.radius) {
        //? Border Radius Change
        radiusTween.begin = oldWidget.radius;
        radiusTween.end = widget.radius;
        needsRebuild = true;
      }

      if (needsRebuild) {
        animationController.reset();
        animationController.forward();
      }
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    ///TODO add curves to this part
    topPaddingTween = Tween(begin: widget.paddingTop, end: widget.paddingTop);
    bottomPaddingTween = Tween(begin: widget.paddingBottom, end: widget.paddingBottom);
    leftPaddingTween = Tween(begin: widget.paddingLeft, end: widget.paddingLeft);
    rightPaddingTween = Tween(begin: widget.paddingRight, end: widget.paddingRight);
    colourTween = ColorTween(begin: widget.colour, end: widget.colour);
    radiusTween = Tween(begin: widget.radius, end: widget.radius);

    animationController = AnimationController(
      vsync: this,
      duration: kAnimationDurationRegular,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: animationController,
      builder: (_, __) => IgnorePointer(
        child: CustomPaint(
          painter: PositiveClipExternalShaderPainter(
            paddingLeft: leftPaddingTween.lerp(animationController.value),
            paddingRight: rightPaddingTween.lerp(animationController.value),
            paddingTop: topPaddingTween.lerp(animationController.value),
            paddingBottom: bottomPaddingTween.lerp(animationController.value),
            colour: colourTween.lerp(animationController.value) ?? Colors.transparent,
            radius: radiusTween.lerp(animationController.value),
          ),
        ),
      ),
    );
  }
}

class PositiveClipExternalShaderPainter extends CustomPainter {
  const PositiveClipExternalShaderPainter({
    required this.paddingLeft,
    required this.paddingRight,
    required this.paddingTop,
    required this.paddingBottom,
    required this.colour,
    required this.radius,
  });

  final double paddingLeft;
  final double paddingRight;
  final double paddingTop;
  final double paddingBottom;

  final Color colour;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final Path path = Path.combine(
      PathOperation.difference,
      Path()
        ..addRect(
          Rect.largest,
        ),
      Path()
        ..addRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(
              paddingLeft,
              paddingTop,
              size.width - paddingRight - paddingLeft,
              size.height - paddingBottom - paddingTop,
            ),
            Radius.circular(radius),
          ),
        ),
    );

    canvas.drawPath(
      path,
      Paint()..color = colour,
    );
  }

  @override
  bool shouldRepaint(PositiveClipExternalShaderPainter oldDelegate) {
    return paddingTop != oldDelegate.paddingTop;
  }
}
