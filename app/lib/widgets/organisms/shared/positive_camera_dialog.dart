// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/organisms/shared/positive_camera.dart';
import '../../atoms/camera/camera_floating_button.dart';

class PositiveCameraDialog extends ConsumerWidget {
  const PositiveCameraDialog({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      child: PositiveCamera(
        onCameraImageTaken: (path) async => Navigator.pop(context, path),
        topChildren: <Widget>[
          CameraFloatingButton.close(
            active: true,
            onTap: () => Navigator.pop(context),
          ),
        ],
      ),
    );
  }
}
