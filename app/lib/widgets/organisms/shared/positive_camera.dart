// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/atoms/camera/camera_floating_button.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/camera/camera_button_painter.dart';

// Project imports:

@RoutePage()
class PositiveCamera extends StatefulHookConsumerWidget {
  const PositiveCamera({
    required this.fileName,
    this.requestPreview = false,
    this.onCameraImageTaken,
    this.leftActionCallback,
    this.cancelButton,
    this.cameraNavigation,
    this.topChildren = const [],
    super.key,
  });

  final Function(String)? onCameraImageTaken;
  final bool requestPreview;
  final VoidCallback? leftActionCallback;
  final VoidCallback? cancelButton;
  final Widget Function(CameraState)? cameraNavigation;
  final String fileName;
  final List<Widget> topChildren;

  @override
  ConsumerState<PositiveCamera> createState() => _PositiveCameraState();
}

class _PositiveCameraState extends ConsumerState<PositiveCamera> {
  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    return Container(
      color: colors.white,
      child: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photo(
          pathBuilder: () async {
            final Directory dir = await getTemporaryDirectory();
            return "${dir.path}/${widget.fileName}.jpg";
          },
        ),
        mirrorFrontCamera: true,
        enablePhysicalButton: true,
        topActionsBuilder: (state) => topOverlay(state),
        middleContentBuilder: (state) => cameraOverlay(state),
        bottomActionsBuilder: (state) => widget.cameraNavigation?.call(state) ?? const SizedBox.shrink(),
        filter: AwesomeFilter.None,
        flashMode: FlashMode.auto,
        aspectRatio: CameraAspectRatios.ratio_16_9,
        previewFit: CameraPreviewFit.cover,
        sensor: Sensors.front,
        onMediaTap: (mediaCapture) {},
        theme: AwesomeTheme(bottomActionsBackgroundColor: colors.transparent),
      ),
    );
  }

  Widget topOverlay(CameraState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.topChildren,
      ),
    );
  }

  Widget cameraOverlay(CameraState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
            //* -=-=-=-=-=-        Create Post without Image Attached        -=-=-=-=-=- *\\
            //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
            if (widget.leftActionCallback != null)
              CameraFloatingButton.postWithoutImage(
                active: true,
                onTap: () {
                  widget.leftActionCallback;
                },
              )
            else
              const SizedBox(
                width: kIconLarge,
              ),

            const SizedBox(width: kPaddingSmall),
            //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
            //* -=-=-=-=-=-                    Take Photo                    -=-=-=-=-=- *\\
            //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
            CameraButton(
              active: true,
              onTap: () {
                state.when(
                  onPhotoMode: (photoState) async {
                    if (widget.onCameraImageTaken != null) {
                      widget.onCameraImageTaken!(await photoState.takePhoto());
                    }
                  },
                  onVideoMode: (videoState) => videoState.startRecording(),
                  onVideoRecordingMode: (videoState) => videoState.stopRecording(),
                );
              },
            ),

            const SizedBox(width: kPaddingSmall),
            //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
            //* -=-=-=-=-=-            Change Camera Orientation             -=-=-=-=-=- *\\
            //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
            CameraFloatingButton.changeCamera(
              active: true,
              onTap: () {
                state.switchCameraSensor(aspectRatio: CameraAspectRatios.ratio_16_9);
              },
            ),
          ],
        ),
        //* Space between navigation and camera cations
        const SizedBox(height: kPaddingExtraLarge),
      ],
    );
  }
}
