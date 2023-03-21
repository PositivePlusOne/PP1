// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/main.dart';
import '../../../../helpers/image_helpers.dart';
import '../../../../providers/system/design_controller.dart';
import '../../../../providers/system/system_controller.dart';
import '../vms/profile_image_view_model.dart';

class FaceTrackerPainter extends CustomPainter {
  FaceTrackerPainter({
    required this.faces,
    required this.cameraResolution,
    required this.scale,
    required this.rotationAngle,
    required this.faceFound,
    required this.ref,
  });

  final List<Face> faces;
  final Size cameraResolution;
  final double scale;
  final InputImageRotation rotationAngle;
  final bool faceFound;
  final WidgetRef ref;
  ProfileImageViewModelState? currentState;

  @override
  void paint(Canvas canvas, Size size) {
    final DesignColorsModel designColours = ref.read(designControllerProvider.select((value) => value.colors));
    final Paint outlinePaint = Paint()
      ..color = (faceFound) ? designColours.green : designColours.transparent
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke;
    final Paint fillPaint = Paint()
      ..color = designColours.black.withOpacity(0.8)
      ..style = PaintingStyle.fill;

    //* -=-=-=-=-=- Transparent Shading Widget -=-=-=-=-=-
    final double edgeInsetStartX = size.width * 0.06;
    final double edgeInsetStarty = size.height * 0.15;

    final double widthOval = size.width - (2 * edgeInsetStartX);
    final double heightOval = widthOval * 1.28;

    final Path ovalPath = Path()..addOval(Rect.fromLTWH(edgeInsetStartX, edgeInsetStarty, widthOval, heightOval));
    final Path cameraPreviewPath = Path()..addRect(Rect.fromLTWH(0.0, 0.0, size.width, size.height));
    final Path shaderPath = Path.combine(PathOperation.difference, cameraPreviewPath, ovalPath);

    canvas.drawPath(shaderPath, fillPaint);
    canvas.drawPath(ovalPath, outlinePaint);

    //* -=-=-=-=-=- Tick Widget -=-=-=-=-=-
    outlinePaint.style = PaintingStyle.fill;
    const double rotation = -0.25;
    final double tickX = ((widthOval / 2) * cos(rotation * pi)) + edgeInsetStartX + widthOval / 2;
    final double tickY = ((heightOval / 2) * sin(rotation * pi)) + edgeInsetStarty + heightOval / 2;
    canvas.drawCircle(Offset(tickX, tickY), iconHuge / 2, outlinePaint);

    final Paint tickPaint = Paint()
      ..color = Colors.black
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    if (faceFound) {
      const double tickWidth = 14;
      const double tickHeight = 10;

      Path tPath = tickPath(tickWidth, tickHeight);

      canvas.drawPath(tPath.shift(Offset(tickX - tickWidth / 2, tickY - tickHeight / 2)), tickPaint);
    }

    //? Debug code section
    final SystemEnvironment environment = providerContainer.read(systemControllerProvider.select((value) => value.environment));
    if (environment == SystemEnvironment.develop && faces.isNotEmpty) {
      final Paint outlinePaint = Paint()
        ..color = Colors.blue
        ..strokeWidth = 4
        ..style = PaintingStyle.stroke;
      for (Face face in faces) {
        //? as the image must be mirrored in the z axis to make sense to the user so must the bounding box showing the face
        //? However, the method used will also flip the left and right bounds of the box, so must be adjusted
        Rect rect = Rect.fromLTRB(
          rotateResizeImageX(face.boundingBox.left, rotationAngle, size, cameraResolution),
          rotateResizeImageY(face.boundingBox.top, rotationAngle, size, cameraResolution),
          rotateResizeImageX(face.boundingBox.right, rotationAngle, size, cameraResolution),
          rotateResizeImageY(face.boundingBox.bottom, rotationAngle, size, cameraResolution),
        );

        canvas.drawRect(rect, outlinePaint);
      }

      //? Calculate the outer bounds of the target face position
      final double faceOuterBoundsLeft = size.width * 0.04;
      final double faceOuterBoundsRight = size.width - faceOuterBoundsLeft;
      final double faceOuterBoundsTop = size.height * 0.13;
      final double faceOuterBoundsBottom = size.height * 0.7;

      //? Calculate the inner bounds of the target face position
      final double faceInnerBoundsLeft = size.width * 0.40;
      final double faceInnerBoundsRight = size.width - faceInnerBoundsLeft;
      final double faceInnerBoundsTop = size.height * 0.40;
      final double faceInnerBoundsBottom = size.height * 0.5;

      final Paint outerBoundingBoxPaint = Paint()
        ..color = Colors.yellowAccent
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTRB(faceOuterBoundsLeft, faceOuterBoundsTop, faceOuterBoundsRight, faceOuterBoundsBottom), outerBoundingBoxPaint);

      final Paint innerBoundingBoxPaint = Paint()
        ..color = Colors.orangeAccent
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTRB(faceInnerBoundsLeft, faceInnerBoundsTop, faceInnerBoundsRight, faceInnerBoundsBottom), innerBoundingBoxPaint);
    }
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

Path tickPath(double tickWidth, double tickHeight) {
  Path path = Path()
    ..moveTo(0.0, tickHeight / 2)
    ..lineTo(tickWidth * 0.3, tickHeight)
    ..lineTo(tickWidth, 0.0);
  return path;
}
