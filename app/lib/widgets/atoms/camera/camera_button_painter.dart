// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/main.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../../../dtos/system/design_colors_model.dart';
import '../../../../dtos/system/design_typography_model.dart';
import '../../../../providers/system/design_controller.dart';
import '../../organisms/profile/vms/profile_reference_image_view_model.dart';

// Package imports:

class CameraButton extends StatelessWidget {
  const CameraButton({
    required this.active,
    required this.onTap,
    this.width = kCameraButtonSize,
    this.height = kCameraButtonSize,
    super.key,
  });

  final bool active;
  final VoidCallback onTap;
  final double width;
  final double height;

  @override
  Widget build(BuildContext context) {
    return PositiveTapBehaviour(
      onTap: onTap,
      isEnabled: active,
      showDisabledState: true,
      child: SizedBox(
        height: height,
        width: width,
        child: CustomPaint(
          painter: CameraButtonPainter(active: active),
        ),
      ),
    );
  }
}

class CameraButtonPainter extends CustomPainter {
  CameraButtonPainter({
    required this.active,
    this.currentState,
  });

  final bool active;

  ProfileReferenceImageViewModelState? currentState;

  @override
  void paint(Canvas canvas, Size size) {
    //* -=-=-=-=-=- Setup Positional Values -=-=-=-=-=-
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;

    final double thicknessCircleRadius = halfWidth / 10;
    final double outerCircleRadius = halfWidth - thicknessCircleRadius / 2;
    final double innerCircleRadius = 0.87 * halfWidth;

    final Offset offset = Offset.zero.translate(halfWidth, halfHeight);

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
    final ProfileReferenceImageViewModelState newState = providerContainer.read(profileReferenceImageViewModelProvider);
    if (currentState != newState) {
      currentState = newState;
      return true;
    }

    return false;
  }
}

class CameraButtonPosition extends ConsumerWidget {
  const CameraButtonPosition({
    super.key,
    required this.mediaQuery,
    required this.caption,
    required this.displayHintText,
    required this.active,
    required this.onTap,
  });

  final MediaQueryData mediaQuery;
  final String caption;
  final bool displayHintText;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final double buttonPositionY = (mediaQuery.size.height * 0.15) - kCameraButtonSize;
    final double textPositionY = (mediaQuery.size.height * 0.85) - 55.0;

    final DesignTypographyModel designTypography = ref.read(designControllerProvider.select((value) => value.typography));
    final DesignColorsModel designColours = ref.read(designControllerProvider.select((value) => value.colors));

    return Positioned(
      left: 0.0,
      top: textPositionY,
      bottom: buttonPositionY,
      right: 0.0,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          //* -=-=-=-=-=- Information Text Widget -=-=-=-=-=-
          if (displayHintText)
            Text(
              caption,
              textAlign: TextAlign.center,
              style: designTypography.styleTitle.copyWith(color: designColours.white),
              overflow: TextOverflow.clip,
            ),
          if (!displayHintText) const SizedBox(),
          //* -=-=-=-=-=- Take Picture Widget -=-=-=-=-=-
          CameraButton(
            width: kCameraButtonSize,
            height: kCameraButtonSize,
            active: active,
            onTap: onTap,
          ),
        ],
      ),
    );
  }
}
