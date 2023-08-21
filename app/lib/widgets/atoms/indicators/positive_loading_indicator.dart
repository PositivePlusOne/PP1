// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../main.dart';
import '../../../providers/system/design_controller.dart';

class PositiveLoadingIndicator extends ConsumerStatefulWidget {
  const PositiveLoadingIndicator({
    this.width = kIconMedium,
    this.height = kIconMedium,
    this.color = Colors.black,
    this.circleRadius = 2.0,
    super.key,
  });

  final double width;
  final double height;
  final Color color;
  final double circleRadius;

  @override
  PositiveLoadingIndicatorState createState() => PositiveLoadingIndicatorState();
}

class PositiveLoadingIndicatorState extends ConsumerState<PositiveLoadingIndicator> with SingleTickerProviderStateMixin {
  late DesignTypographyModel typography;
  late DesignColorsModel colors;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    typography = providerContainer.read(designControllerProvider.select((value) => value.typography));
    colors = providerContainer.read(designControllerProvider.select((value) => value.colors));

    _controller = AnimationController(
      vsync: this,
      duration: kAnimationDurationSlow,
    );
    _controller.addListener(onControllerTick);
    _controller.forward();
  }

  void onControllerTick() {
    if (!mounted) return;
    if (_controller.isCompleted) {
      _controller.forward(from: 0.0);
    }
    setState(() {});
  }

  @override
  void dispose() {
    _controller.removeListener(onControllerTick);
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: Size(widget.width, widget.height),
      painter: _PositiveLoadingIndicatorPaintainer(
        animation: _controller.value,
        color: widget.color,
        circleRadius: widget.circleRadius,
      ),
    );
  }
}

class _PositiveLoadingIndicatorPaintainer extends CustomPainter {
  _PositiveLoadingIndicatorPaintainer({
    required this.animation,
    required this.color,
    required this.circleRadius,
  });

  double animation;
  final Color color;
  final double circleRadius;

  @override
  void paint(Canvas canvas, Size size) {
    double animationLooped;

    if (animation <= 0.5) {
      animationLooped = animation * 2;
    } else {
      animationLooped = (1.0 - animation) * 2;
    }

    Paint paint3 = Paint()
      ..color = color.withOpacity(animationLooped)
      ..style = PaintingStyle.fill;

    animation += 0.333;
    if (animation > 1.0) animation = animation - 1;
    if (animation <= 0.5) {
      animationLooped = animation * 2;
    } else {
      animationLooped = (1.0 - animation) * 2;
    }

    Paint paint2 = Paint()
      ..color = color.withOpacity(animationLooped)
      ..style = PaintingStyle.fill;

    animation += 0.333;
    if (animation > 1.0) animation -= 1;

    if (animation <= 0.5) {
      animationLooped = animation * 2;
    } else {
      animationLooped = (1.0 - animation) * 2;
    }

    Paint paint1 = Paint()
      ..color = color.withOpacity(animationLooped)
      ..style = PaintingStyle.fill;

    double yPos = (size.height / 2);

    canvas.drawCircle(Offset(circleRadius, yPos), circleRadius, paint1);
    canvas.drawCircle(Offset((size.width / 2), yPos), circleRadius, paint2);
    canvas.drawCircle(Offset(size.width - circleRadius, yPos), circleRadius, paint3);
  }

  @override
  bool shouldRepaint(_PositiveLoadingIndicatorPaintainer oldDelegate) {
    if (animation != oldDelegate.animation) {
      return true;
    }

    return false;
  }
}
