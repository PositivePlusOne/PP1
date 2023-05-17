// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:rxdart/rxdart.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/ml/face_detector_model.dart';
import 'package:app/extensions/mlkit_extensions.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/camera/camera_floating_button.dart';
import 'package:app/widgets/organisms/shared/painters/positive_camera_multi_face_painter.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/camera/camera_button_painter.dart';

class PositiveCamera extends StatefulHookConsumerWidget {
  const PositiveCamera({
    this.onCameraImageTaken,
    this.leftActionCallback,
    this.cancelButton,
    this.cameraNavigation,
    this.requireFaceDetection = false,
    this.topChildren = const [],
    super.key,
  });

  final void Function(String imagePath)? onCameraImageTaken;

  final VoidCallback? leftActionCallback;
  final VoidCallback? cancelButton;
  final Widget Function(CameraState)? cameraNavigation;

  final List<Widget> topChildren;
  final bool requireFaceDetection;

  @override
  ConsumerState<PositiveCamera> createState() => _PositiveCameraState();
}

class _PositiveCameraState extends ConsumerState<PositiveCamera> {
  final BehaviorSubject<FaceDetectionModel> faceDetectionController = BehaviorSubject<FaceDetectionModel>();
  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(enableContours: true, enableLandmarks: true),
  );

  final AnalysisConfig faceAnalysisConfig = AnalysisConfig(
    androidOptions: const AndroidAnalysisOptions.nv21(width: 250),
    maxFramesPerSecond: 30.0,
  );

  @override
  void deactivate() {
    faceDetector.close();
    super.deactivate();
  }

  @override
  void dispose() {
    faceDetectionController.close();
    super.dispose();
  }

  Future<void> onAnalyzeImage(AnalysisImage image) async {
    if (!mounted || !widget.requireFaceDetection) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    final InputImage inputImage = image.toInputImage();

    try {
      final List<Face> faces = await faceDetector.processImage(inputImage);
      final FaceDetectionModel faceDetectionModel = FaceDetectionModel(
        faces: faces,
        absoluteImageSize: inputImage.inputImageData!.size,
        rotation: 0,
        imageRotation: image.inputImageRotation,
        croppedSize: image.croppedSize,
      );

      faceDetectionController.add(faceDetectionModel);
    } catch (e) {
      logger.e("Error while processing image: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colors = ref.watch(designControllerProvider.select((value) => value.colors));
    return Stack(
      children: <Widget>[
        Positioned.fill(
          child: CameraAwesomeBuilder.awesome(
            imageAnalysisConfig: faceAnalysisConfig,
            onImageForAnalysis: onAnalyzeImage,
            saveConfig: SaveConfig.photo(
              pathBuilder: () async {
                final Directory dir = await getTemporaryDirectory();
                final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
                final String filePath = "${dir.path}/$currentTime.jpg";
                return filePath;
              },
            ),
            mirrorFrontCamera: false,
            enablePhysicalButton: true,
            previewDecoratorBuilder: buildDecorations,
            topActionsBuilder: (state) => topOverlay(state),
            middleContentBuilder: (state) => cameraOverlay(state),
            bottomActionsBuilder: (state) => widget.cameraNavigation?.call(state) ?? const SizedBox.shrink(),
            filter: AwesomeFilter.None,
            flashMode: FlashMode.auto,
            aspectRatio: CameraAspectRatios.ratio_16_9,
            previewFit: CameraPreviewFit.cover,
            sensor: Sensors.front,
            onMediaTap: (mediaCapture) {},
            theme: AwesomeTheme(
              bottomActionsBackgroundColor: colors.transparent,
            ),
          ),
        ),
      ],
    );
  }

  Widget buildDecorations(CameraState state, PreviewSize previewSize, Rect previewRect) {
    final List<Widget> children = <Widget>[];

    if (widget.requireFaceDetection) {
      children.add(buildFaceDetectionOverlay(state, previewSize, previewRect));
    }

    return Stack(children: children);
  }

  Widget buildFaceDetectionOverlay(CameraState state, PreviewSize previewSize, Rect previewRect) {
    return Positioned.fill(
      child: IgnorePointer(
        child: StreamBuilder(
          stream: state.sensorConfig$,
          builder: (_, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            } else {
              return StreamBuilder<FaceDetectionModel>(
                stream: faceDetectionController.stream,
                builder: (_, faceModelSnapshot) {
                  if (!faceModelSnapshot.hasData) return const SizedBox();
                  return CustomPaint(
                    painter: PositiveCameraMultiFacePainter(
                      model: faceModelSnapshot.requireData,
                      previewSize: previewSize,
                      previewRect: previewRect,
                      isBackCamera: snapshot.requireData.sensor == Sensors.back,
                    ),
                  );
                },
              );
            }
          },
        ),
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
                    final photo = await photoState.takePhoto();
                    widget.onCameraImageTaken?.call(photo);
                  },
                  onVideoMode: (videoState) {},
                  onVideoRecordingMode: (videoState) {},
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
