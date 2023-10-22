// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';

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
    this.onCameraImageTaken,
    this.previewFile,
    this.isBusy = false,
    super.key,
  });

  final bool useFaceDetection;
  final Function(FaceDetectionModel?)? onFaceDetected;
  final String? takePictureCaption;
  final bool displayCameraShade;
  final XFile? previewFile;

  final bool isBusy;

  final Future<void> Function(XFile)? onCameraImageTaken;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: PositiveCamera(
        previewFile: previewFile,
        useFaceDetection: useFaceDetection,
        onFaceDetected: onFaceDetected,
        takePictureCaption: takePictureCaption,
        displayCameraShade: displayCameraShade,
        onCameraImageTaken: onCameraImageTaken ?? (path) async => Navigator.pop(context, path),
        isBusy: isBusy,
        onDelayTimerChanged: (_) {},
        onRecordingLengthChanged: (_) {},
        topChildren: <Widget>[
          CameraFloatingButton.close(active: !isBusy, onTap: (context) => Navigator.pop(context, null)),
        ],
      ),
    );
  }
}
