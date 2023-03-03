// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:

// Project imports:
import 'package:app/main.dart';
import 'package:app/widgets/organisms/face_detection/vms/profile_image_page_view_model.dart';

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
    return GestureDetector(
      onTap: active ? onTap : () {},
      child: CustomPaint(
        painter: FaceTrackerButtonPainter(active: active),
      ),
    );
  }
}

class FaceTrackerButtonPainter extends CustomPainter {
  FaceTrackerButtonPainter({
    required this.active,
  });
  final bool active;
  ProfileImagePageViewModelState? currentState;

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
    final ProfileImagePageViewModelState newState = providerContainer.read(profileImagePageViewModelProvider);
    if (currentState != newState) {
      currentState = newState;
      return true;
    }
    return false;
  }
}
