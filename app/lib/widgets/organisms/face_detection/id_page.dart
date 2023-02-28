// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'package:app/widgets/organisms/face_detection/vms/id_view_model.dart';
import 'components/face_tracker_painter.dart';

class IDPage extends HookConsumerWidget {
  const IDPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final IDViewModel viewModel = ref.read(iDViewModelProvider.notifier);
    final IDViewModelState viewModelState = ref.watch(iDViewModelProvider);
    useLifecycleHook(viewModel);
    final double scale = viewModel.scale;

    return PositiveScaffold(
      onWillPopScope: () async => false,
      children: <Widget>[
        SliverFillRemaining(
          child: Stack(
            children: [
              //* -=-=-=-=-=- Camera Widget -=-=-=-=-=-
              if (viewModelState.cameraControllerInitialised)
                Positioned.fill(
                  child: Transform.scale(
                    scale: scale,
                    child: Center(
                      child: CameraPreview(
                        viewModel.cameraController!,
                      ),
                    ),
                  ),
                ),
              //* -=-=-=-=-=- Face Tracker Custom Painter Widget -=-=-=-=-=-
              if (viewModelState.cameraControllerInitialised)
                Positioned.fill(
                  child: CustomPaint(
                    painter: FaceTrackerPainter(
                      faces: viewModel.faces,
                      cameraResolution: Size(
                        viewModel.cameraController!.value.previewSize!.width,
                        viewModel.cameraController!.value.previewSize!.height,
                      ),
                      scale: scale,
                      rotationAngle: viewModel.cameraRotation,
                      faceFound: viewModelState.faceFound,
                    ),
                  ),
                ),
              //* -=-=-=-=-=- Cancel Button Widget -=-=-=-=-=-
              //* -=-=-=-=-=- Information Text Widget -=-=-=-=-=-
              //* -=-=-=-=-=- Take Picture Widget -=-=-=-=-=-
            ],
          ),
        ),
      ],
    );
  }
}
