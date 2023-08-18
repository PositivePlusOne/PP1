// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/ml/face_detector_model.dart';
import 'package:app/widgets/atoms/camera/camera_floating_button.dart';
import 'package:app/widgets/organisms/shared/positive_camera.dart';

class PositiveCameraDialog extends ConsumerWidget {
  const PositiveCameraDialog({
    this.useFaceDetection = false,
    this.onFaceDetected,
    this.takePictureCaption,
    this.displayCameraShade = true,
    super.key,
  });

  final bool useFaceDetection;
  final Function(FaceDetectionModel?)? onFaceDetected;
  final String? takePictureCaption;
  final bool displayCameraShade;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: PositiveCamera(
        useFaceDetection: useFaceDetection,
        onFaceDetected: onFaceDetected,
        takePictureCaption: takePictureCaption,
        displayCameraShade: displayCameraShade,
        onCameraImageTaken: (path) async => Navigator.pop(context, path),
        topChildren: <Widget>[
          CameraFloatingButton.close(active: true, onTap: () => Navigator.pop(context, null)),
        ],
      ),
    );
  }
}
