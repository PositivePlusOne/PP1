// Flutter imports:
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/main.dart';
import '../vms/profile_image_view_model.dart';

// Package imports:

class FaceTrackerButton extends StatelessWidget {
  const FaceTrackerButton({
    required this.active,
    required this.onTap,
    super.key,
  });
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return PositiveTapBehaviour(
      onTap: onTap,
      isEnabled: active,
      child: CustomPaint(
        painter: FaceTrackerButtonPainter(active: active),
      ),
    );
  }
}

class FaceTrackerButtonPainter extends CustomPainter {
  FaceTrackerButtonPainter({
    required this.active,
    this.currentState,
  });

  final bool active;

  ProfileImageViewModelState? currentState;

  @override
  void paint(Canvas canvas, Size size) {
    //* -=-=-=-=-=- Setup Positional Values -=-=-=-=-=-
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;

    final double thicknessCircleRadius = halfWidth / 10;
    final double outerCircleRadius = halfWidth - thicknessCircleRadius / 2;
    final double innerCircleRadius = 0.87 * halfWidth;

    final Offset offset = Offset.zero.translate(halfWidth, halfHeight);
    // final double inset = outerCircleRadius - innerCircleRadius;

    //* -=-=-=-=-=- Paints for Circles -=-=-=-=-=-
    final Paint outlinePaint = Paint()
      ..color = (active) ? Colors.white : Colors.white.withOpacity(0.75)
      ..strokeWidth = thicknessCircleRadius
      ..style = PaintingStyle.stroke;

    final Paint fillPaint = Paint()
      ..color = (active) ? Colors.white : Colors.white.withOpacity(0.75)
      ..style = PaintingStyle.fill;

    //* -=-=-=-=-=- Paint Button -=-=-=-=-=-
    canvas.drawCircle(offset, outerCircleRadius, outlinePaint);
    canvas.drawCircle(offset, innerCircleRadius, fillPaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final ProfileImageViewModelState newState = providerContainer.read(profileImageViewModelProvider);
    if (currentState != newState) {
      currentState = newState;
      return true;
    }

    return false;
  }
}
