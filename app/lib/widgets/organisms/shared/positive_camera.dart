// Dart imports:

// Flutter imports:
import 'dart:io';

import 'package:app/constants/design_constants.dart';
import 'package:app/widgets/atoms/camera/camera_floating_button.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:path_provider/path_provider.dart';

// Project imports:

import '../../../hooks/lifecycle_hook.dart';
import '../../atoms/camera/camera_button_painter.dart';
import 'components/positive_post_navigation_bar.dart';

@RoutePage()
class PositiveCamera extends StatefulHookConsumerWidget {
  const PositiveCamera({
    this.requestPreview = false,
    this.onCameraImageTaken,
    this.leftActionCallback,
    this.cancelButton,
    this.cameraNavigation,
    required this.fileName,
    super.key,
  });

  final Function(String)? onCameraImageTaken;
  final bool requestPreview;
  final VoidCallback? leftActionCallback;
  final VoidCallback? cancelButton;
  final Widget? cameraNavigation;
  final String fileName;

  @override
  ConsumerState<PositiveCamera> createState() => _PositiveCameraState();
}

class _PositiveCameraState extends ConsumerState<PositiveCamera> {
  @override
  Widget build(BuildContext context) {
    final double safeAreaBottom = MediaQuery.of(context).padding.bottom;

    return Container(
      color: Colors.white,
      child: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photo(
          pathBuilder: () async {
            final Directory dir = await getTemporaryDirectory();
            return "${dir.path}/${widget.fileName}";
          },
        ),
        enablePhysicalButton: true,
        middleContentBuilder: (state) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    CameraFloatingButton.close(active: true, onTap: widget.cancelButton ?? () {}),
                    CameraFloatingButton.addImage(active: true, onTap: () {}),
                  ],
                ),
              ),
              const Expanded(
                child: SizedBox(),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  if (widget.leftActionCallback != null)
                    CameraFloatingButton.removeImage(
                      active: true,
                      onTap: () {
                        widget.leftActionCallback;
                      },
                    ),
                  if (widget.leftActionCallback == null)
                    const SizedBox(
                      width: kIconLarge,
                    ),
                  const SizedBox(width: kPaddingSmall),
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
                  CameraFloatingButton.changeCamera(
                    active: true,
                    onTap: () {
                      state.switchCameraSensor(aspectRatio: CameraAspectRatios.ratio_16_9);
                    },
                  ),
                ],
              ),
              const SizedBox(height: kPaddingExtraLarge),
              if (widget.cameraNavigation != null) widget.cameraNavigation!,
              const SizedBox(height: kPaddingExtraLarge),
              PositivePostNavigationBar(
                onTapPost: () {},
                onTapClip: () {},
                onTapEvent: () {},
                onTapFlex: () {},
                activeButton: ActiveButton.event,
                flexCaption: "Next",
              ),
              SizedBox(height: safeAreaBottom + kPaddingSmall),
            ],
          );
        },
        topActionsBuilder: (state) {
          return Container(
            color: Colors.red,
          );
        },
        // previewDecoratorBuilder: (state, previewSize, previewRect) {
        //   return Container(
        //     color: Colors.red,
        //   );
        // },
        bottomActionsBuilder: (state) {
          return Container(
            color: Colors.transparent,
          );
        },
        filter: AwesomeFilter.None,
        flashMode: FlashMode.auto,
        aspectRatio: CameraAspectRatios.ratio_16_9,

        previewFit: CameraPreviewFit.fitHeight,
        sensor: Sensors.front,

        onMediaTap: (mediaCapture) {
          // viewModel.onTakeSelfie(mediaCapture);
          // OpenFile.open(mediaCapture.filePath);
        },
      ),
    );
  }
}
