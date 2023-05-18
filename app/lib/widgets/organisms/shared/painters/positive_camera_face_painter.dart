// Dart imports:
import 'dart:math';

// Flutter imports:
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_ml_kit/google_ml_kit.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/main.dart';
import '../../../../helpers/image_helpers.dart';
import '../../../../providers/system/design_controller.dart';
import '../../../../providers/system/system_controller.dart';
import '../../organisms/profile/vms/profile_reference_image_view_model.dart';

class PositiveCameraFacePainter extends CustomPainter {
  PositiveCameraFacePainter({
    required this.faces,
    required this.cameraResolution,
    required this.rotationAngle,
    required this.faceFound,
    required this.ref,
    required this.croppedSize,
  });

  final List<Face> faces;
  final Size cameraResolution;
  final InputImageRotation rotationAngle;
  final bool faceFound;
  final WidgetRef ref;
  ProfileReferenceImageViewModelState? currentState;
  final Size croppedSize;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outlinePaint = Paint()
      ..color = (faceFound) ? colors.green : colors.transparent
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke;

    final Paint fillPaint = Paint()
      ..color = colors.black.withOpacity(0.8)
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
    canvas.drawCircle(Offset(tickX, tickY), kIconLarge / 2, outlinePaint);

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
        Rect rect = Rect.fromLTRB(
          rotateResizeImageX(face.boundingBox.left, rotationAngle, size, cameraResolution, croppedSize: croppedSize),
          rotateResizeImageY(face.boundingBox.top, rotationAngle, size, cameraResolution),
          rotateResizeImageX(face.boundingBox.right, rotationAngle, size, cameraResolution, croppedSize: croppedSize),
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

//! test
    for (final Face face in faces) {
      Map<FaceContourType, Path> paths = {for (var fct in FaceContourType.values) fct: Path()};
      face.contours.forEach(
        (contourType, faceContour) {
          if (faceContour != null) {
            //&& faceContour.type == FaceContourType.rightEye
            for (var element in faceContour.points) {
              canvas.drawCircle(
                Offset(
                  rotateResizeImageX(
                    element.x.toDouble(),
                    rotationAngle,
                    size,
                    cameraResolution,
                    croppedSize: croppedSize,
                  ),
                  rotateResizeImageY(
                    element.y.toDouble(),
                    rotationAngle,
                    size,
                    cameraResolution,
                  ),
                ),
                4,
                Paint()..color = Colors.blue,
              );
            }
          }
        },
      );
      paths.removeWhere((key, value) => value.getBounds().isEmpty);
      for (var p in paths.entries) {
        canvas.drawPath(
            p.value,
            Paint()
              ..color = Colors.orange
              ..strokeWidth = 2
              ..style = PaintingStyle.stroke);
      }
    }
    //! TEST
  }

  Path tickPath(double tickWidth, double tickHeight) {
    Path path = Path()
      ..moveTo(0.0, tickHeight / 2)
      ..lineTo(tickWidth * 0.3, tickHeight)
      ..lineTo(tickWidth, 0.0);
    return path;
  }

  @override
  bool shouldRepaint(covariant PositiveCameraFacePainter oldDelegate) {
    // TODO(ryan): Use the faces themselves to perform this check
    if (oldDelegate.faces.length != faces.length) {
      return true;
    }

    return false;
  }
}
