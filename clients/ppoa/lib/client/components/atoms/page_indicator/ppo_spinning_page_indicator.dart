// Flutter imports:
import 'package:flutter/material.dart';

class PPOSpinningPageIndicator extends StatefulWidget {
  const PPOSpinningPageIndicator({
    required this.circleActiveColour,
    required this.circleActiveColourHighlight,
    required this.circleActiveColourShadow,
    required this.circleInactiveColour,
    required this.circleInactiveColourHighlight,
    required this.circleInactiveColourShadow,
    this.size = 50.0,
    super.key,
  });

  final Color circleActiveColour;
  final Color circleActiveColourHighlight;
  final Color circleActiveColourShadow;

  final Color circleInactiveColour;
  final Color circleInactiveColourHighlight;
  final Color circleInactiveColourShadow;

  final double size;

  @override
  State<PPOSpinningPageIndicator> createState() => _StampState();
}

class _StampState extends State<PPOSpinningPageIndicator> with SingleTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> animation;

  @override
  void initState() {
    //TODO: standarise duration
    animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 400));
    animation = Tween<double>(begin: -1.0, end: 1.0).animate(animationController);
    animationController.addListener(() {
      if (animationController.isCompleted) {
        animationController.repeat();
      }
      if (!mounted) {
        return;
      }
      setState(() {});
    });
    animationController.forward();
    super.initState();
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: SizedBox(
        width: widget.size,
        height: widget.size,
        child: CustomPaint(
          size: Size(widget.size, widget.size),
          painter: _CirclePainter(
            circleActiveColour: widget.circleActiveColour,
            circleActiveColourHighlight: widget.circleActiveColourHighlight,
            circleActiveColourShadow: widget.circleActiveColourShadow,
            circleInactiveColour: widget.circleInactiveColour,
            circleInactiveColourHighlight: widget.circleInactiveColourHighlight,
            circleInactiveColourShadow: widget.circleInactiveColourShadow,
            value: animation.value,
          ),
        ),
      ),
    );
  }
}

class _CirclePainter extends CustomPainter {
  final Paint circlePaint;

  final Color circleActiveColour;
  final Color circleActiveColourHighlight;
  final Color circleActiveColourShadow;

  final Color circleInactiveColour;
  final Color circleInactiveColourHighlight;
  final Color circleInactiveColourShadow;

  final double value;

  _CirclePainter({
    required this.circleActiveColour,
    required this.circleActiveColourHighlight,
    required this.circleActiveColourShadow,
    required this.circleInactiveColour,
    required this.circleInactiveColourHighlight,
    required this.circleInactiveColourShadow,
    required this.value,
  }) : circlePaint = Paint();

  @override
  void paint(Canvas canvas, Size size) {
    double ovalWidth = value.abs() * size.width;

    circlePaint
      ..style = PaintingStyle.fill
      ..shader = LinearGradient(
        colors: (value <= 0)
            ? [
                Color.lerp(circleInactiveColour, circleInactiveColourShadow, value + 1.0)!,
                Color.lerp(circleInactiveColour, circleInactiveColourHighlight, value + 1.0)!,
                Color.lerp(circleInactiveColour, circleInactiveColourHighlight, value + 1.0)!,
              ]
            : [
                Color.lerp(circleActiveColourHighlight, circleActiveColour, value)!,
                Color.lerp(circleActiveColourShadow, circleActiveColour, value)!,
                Color.lerp(circleActiveColourShadow, circleActiveColour, value)!,
              ],
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        stops: (value <= 0) ? [0.5 + value / 2, 0.6 - value / 2, 1.0] : [0.0, 0.5 + value / 2, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
      ..strokeWidth = 1.0;

    canvas.drawOval(
      Rect.fromLTWH(
        (size.width - ovalWidth) / 2,
        0.0,
        ovalWidth,
        size.height,
      ),
      circlePaint,
    );
  }

  @override
  bool shouldRepaint(covariant _CirclePainter oldDelegate) {
    return true;
  }
}
