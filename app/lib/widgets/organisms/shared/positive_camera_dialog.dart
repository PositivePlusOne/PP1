// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/organisms/shared/positive_camera.dart';

class PositiveCameraDialog extends ConsumerWidget {
  const PositiveCameraDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // TODO(ryan): Make fullscreen on display
    return Material(
      child: PositiveCamera(
        // TODO: This should be configuration, based on the context of the dialog
        onCameraImageTaken: (path) => Navigator.pop(context, path),
      ),
    );
  }
}
