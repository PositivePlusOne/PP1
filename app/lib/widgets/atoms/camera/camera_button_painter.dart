// Flutter imports:
import 'dart:math';

import 'package:app/extensions/widget_extensions.dart';
import 'package:flutter/material.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/main.dart';
import 'package:app/widgets/behaviours/positive_tap_behaviour.dart';
import '../../organisms/profile/vms/profile_reference_image_view_model.dart';

// Package imports:

class CameraButton extends StatefulWidget {
  const CameraButton({
    required this.active,
    required this.onTap,
    this.width = kCameraButtonSize,
    this.height = kCameraButtonSize,
    this.buttonColour = Colors.white,
    this.loadingColour,
    this.isLoading = false,
    this.isSmallButton = false,
    this.maxCLipDuration,
    this.isPaused = false,
    super.key,
  });

  final bool active;
  final void Function(BuildContext context) onTap;
  final double width;
  final double height;
  final Color buttonColour;
  final Color? loadingColour;
  final bool isLoading;
  final bool isSmallButton;
  final int? maxCLipDuration;
  final bool isPaused;

  @override
  State<CameraButton> createState() => _CameraButtonState();
}

class _CameraButtonState extends State<CameraButton> with TickerProviderStateMixin {
  late AnimationController animationController;
  late AnimationController animationControllerCenter;

  @override
  void didUpdateWidget(covariant CameraButton oldWidget) {
    //? On animation duration change
    if (widget.maxCLipDuration != oldWidget.maxCLipDuration) {
      animationController.duration = Duration(milliseconds: widget.maxCLipDuration ?? 0);
    }

    //? progress indicator laoding state
    if (widget.isLoading && !oldWidget.isLoading) {
      animationController.forward();
    }
    if (!widget.isLoading && oldWidget.isLoading) {
      animationController.reset();
    }

    //? pause progress indicator state
    if (widget.isPaused != oldWidget.isPaused) {
      if (widget.isPaused) {
        animationController.stop();
      } else {
        animationController.forward();
      }
    }

    //? Increase reduce the current size of the central circle
    if (widget.isSmallButton && !oldWidget.isSmallButton) {
      animationControllerCenter.forward();
    }
    if (!widget.isSmallButton && oldWidget.isSmallButton) {
      animationControllerCenter.reverse();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  void initState() {
    super.initState();

    animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: widget.maxCLipDuration ?? 0),
    );

    animationController.addListener(() => setStateIfMounted());

    if (widget.isLoading) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          animationController.forward();
        },
      );
    }

    animationControllerCenter = AnimationController(
      vsync: this,
      duration: kAnimationDurationFast,
    );

    animationControllerCenter.addListener(() => setStateIfMounted());

    if (widget.isSmallButton) {
      WidgetsBinding.instance.addPostFrameCallback(
        (timeStamp) {
          animationControllerCenter.forward();
        },
      );
    }
  }

  @override
  void dispose() {
    animationController.dispose();
    animationControllerCenter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PositiveTapBehaviour(
      onTap: widget.onTap,
      isEnabled: widget.active,
      child: SizedBox(
        height: widget.height,
        width: widget.width,
        child: CustomPaint(
          painter: CameraButtonPainter(
            active: widget.active,
            loadingColour: widget.loadingColour,
            loadingProgress: animationController.value,
            buttonColour: widget.buttonColour,
            isSmallButton: widget.isSmallButton,
            centerButtonSize: animationControllerCenter.value,
          ),
        ),
      ),
    );
  }
}

class CameraButtonPainter extends CustomPainter {
  CameraButtonPainter({
    required this.active,
    required this.buttonColour,
    required this.loadingProgress,
    required this.isSmallButton,
    this.centerButtonSize = 1.0,
    this.currentState,
    this.loadingColour,
  });

  final bool active;
  final Color? loadingColour;
  final Color buttonColour;
  final double loadingProgress;

  ///? multiplier for button size 0.0 -> 1.0
  final double centerButtonSize;
  final bool isSmallButton;

  ProfileReferenceImageViewModelState? currentState;

  @override
  void paint(Canvas canvas, Size size) {
    //* -=-=-=-=-=- Setup Positional Values -=-=-=-=-=-
    final double halfWidth = size.width / 2;
    final double halfHeight = size.height / 2;

    final double thicknessCircleRadius = halfWidth / 10;
    final double outerCircleRadius = halfWidth - thicknessCircleRadius / 2;
    final double innerCircleRadius = (1 - centerButtonSize * 0.35) * 0.87 * halfWidth;
    final Color centralButtonColour = (isSmallButton && loadingColour != null) ? loadingColour! : buttonColour;

    final Offset offset = Offset.zero.translate(halfWidth, halfHeight);

    //* -=-=-=-=-=- Paints for Circles -=-=-=-=-=-
    final Paint outlinePaint = Paint()
      ..color = (active) ? buttonColour : buttonColour.withOpacity(0.75)
      ..strokeWidth = thicknessCircleRadius
      ..style = PaintingStyle.stroke;

    final Paint fillPaint = Paint()
      ..color = (active) ? centralButtonColour : centralButtonColour.withOpacity(0.75)
      ..style = PaintingStyle.fill;

    //* -=-=-=-=-=- Calculate Progress Indicator / Outer Perimeter Section  -=-=-=-=-=-
    if (loadingColour != null) {
      outlinePaint.shader = SweepGradient(
        colors: [
          loadingColour!,
          loadingColour!,
          buttonColour,
          buttonColour,
        ],
        stops: [
          0,
          loadingProgress,
          loadingProgress,
          1.0,
        ],
        transform: const GradientRotation(-0.5 * pi),
      ).createShader(
        Rect.fromCenter(
          center: offset,
          width: outerCircleRadius * 2,
          height: outerCircleRadius * 2,
        ),
      );
    }

    //* -=-=-=-=-=- Paint Progress Indicator / Outer Perimeter Section  -=-=-=-=-=-
    canvas.drawCircle(offset, outerCircleRadius, outlinePaint);

    //* -=-=-=-=-=- Paint Inner Button -=-=-=-=-=-
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
