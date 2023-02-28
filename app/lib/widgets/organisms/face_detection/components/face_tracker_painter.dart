// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:google_ml_kit/google_ml_kit.dart';

// Project imports:
import 'package:app/main.dart';
import 'package:app/widgets/organisms/face_detection/vms/id_view_model.dart';
import '../../../../helpers/image_helpers.dart';
import '../../../../providers/system/system_controller.dart';

class FaceTrackerPainter extends CustomPainter {
  FaceTrackerPainter({
    required this.faces,
    required this.cameraResolution,
    required this.scale,
    required this.rotationAngle,
    required this.faceFound,
  });
  final List<Face> faces;
  final Size cameraResolution;
  final double scale;
  final InputImageRotation rotationAngle;
  final bool faceFound;
  IDViewModelState? currentState;

  @override
  void paint(Canvas canvas, Size size) {
    final Paint outlinePaint = Paint()
      ..color = (faceFound) ? Colors.green : Colors.red
      ..strokeWidth = 11
      ..style = PaintingStyle.stroke;
    final Paint fillPaint = Paint()
      ..color = Colors.black.withOpacity(0.8)
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

      final Paint tempPaint = Paint()
        ..color = Colors.yellowAccent
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTRB(faceOuterBoundsLeft, faceOuterBoundsTop, faceOuterBoundsRight, faceOuterBoundsBottom), tempPaint);

      final Paint tempPaint2 = Paint()
        ..color = Colors.orangeAccent
        ..strokeWidth = 1
        ..style = PaintingStyle.stroke;

      canvas.drawRect(Rect.fromLTRB(faceInnerBoundsLeft, faceInnerBoundsTop, faceInnerBoundsRight, faceInnerBoundsBottom), tempPaint2);
    }

    // canvas.drawRect(Rect.fromLTWH(edgeInsetStartX, edgeInsetStarty, widthOval, heightOval), outlinePaint);
    //* -=-=-=-=-=- Tick Widget -=-=-=-=-=-
    //* -=-=-=-=-=- Face Centered Correctly Widget -=-=-=-=-=-
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    final IDViewModelState newState = providerContainer.read(iDViewModelProvider);
    if (currentState != newState) {
      currentState = newState;
      return true;
    }
    return false;
  }
}
