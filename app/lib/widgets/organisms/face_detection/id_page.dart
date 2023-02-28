// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:camera/camera.dart';

// Project imports:
import 'package:app/widgets/organisms/face_detection/vms/id_view_model.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import 'components/face_tracker_painter.dart';

class IDPage extends ConsumerWidget {
  const IDPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final IDViewModel viewModel = ref.read(iDViewModelProvider.notifier);
    final IDViewModelState viewModelState = ref.watch(iDViewModelProvider);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    double scale = 1.0;
    if (viewModelState.cameraControllerInitialised) {
      if (mediaQuery.orientation == Orientation.portrait) {
        scale = mediaQuery.size.aspectRatio * viewModel.cameraController!.value.aspectRatio;
      } else {
        scale = 1 / mediaQuery.size.aspectRatio * viewModel.cameraController!.value.aspectRatio;
      }
    }
    if (scale < 1) scale = 1 / scale;

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
