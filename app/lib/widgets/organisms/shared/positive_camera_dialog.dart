// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/organisms/shared/positive_camera.dart';

class PositiveCameraDialog extends ConsumerWidget {
  const PositiveCameraDialog({
    super.key,
    this.requireFaceDetection = false,
  });

  final bool requireFaceDetection;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: PositiveCamera(
        requireFaceDetection: requireFaceDetection,
        onCameraImageTaken: (path) => Navigator.pop(context, path),
      ),
    );
  }
}
