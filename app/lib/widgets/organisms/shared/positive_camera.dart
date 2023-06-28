// Dart imports:
import 'dart:async';
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
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/ml/face_detector_model.dart';
import 'package:app/helpers/image_helpers.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/camera/camera_floating_button.dart';
import 'package:app/widgets/organisms/shared/components/mlkit_utils.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/camera/camera_button_painter.dart';
import 'painters/positive_camera_face_painter.dart';

class PositiveCamera extends StatefulHookConsumerWidget {
  const PositiveCamera({
    this.topChildren = const [],
    this.onCameraImageTaken,
    this.onFaceDetected,
    this.leftActionCallback,
    this.cameraNavigation,
    this.overlayWidgets = const [],
    this.takePictureCaption,
    this.useFaceDetection = false,
    this.isBusy = false,
    super.key,
  });

  final Future<void> Function(String imagePath)? onCameraImageTaken;
  final void Function(FaceDetectionModel? model)? onFaceDetected;

  final bool useFaceDetection;

  final VoidCallback? leftActionCallback;
  final Widget Function(CameraState)? cameraNavigation;
  final List<Widget> topChildren;
  final List<Widget> overlayWidgets;
  final String? takePictureCaption;

  final bool isBusy;

  @override
  ConsumerState<PositiveCamera> createState() => _PositiveCameraState();
}

class _PositiveCameraState extends ConsumerState<PositiveCamera> {
  FaceDetectionModel? faceDetectionModel;

  bool get hasDetectedFace => faceDetectionModel != null && faceDetectionModel!.faces.isNotEmpty && faceDetectionModel!.isFacingCamera && faceDetectionModel!.isInsideBoundingBox;
  bool get canTakePictureOrVideo => !widget.isBusy && (!widget.useFaceDetection || hasDetectedFace);

  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(enableContours: true, enableLandmarks: true),
  );

  late final StreamSubscription faceDetectionSubscription;
  late final AnalysisConfig faceAnalysisConfig;

  @override
  void initState() {
    super.initState();
    faceAnalysisConfig = AnalysisConfig(
      androidOptions: const AndroidAnalysisOptions.nv21(width: 500),
      maxFramesPerSecond: 5.0,
      autoStart: widget.useFaceDetection,
    );
  }

  @override
  void deactivate() {
    faceDetector.close();
    super.deactivate();
  }

  Future<void> onAnalyzeImage(AnalysisImage image) async {
    if (!mounted) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    try {
      final InputImage inputImage = image.toInputImage();
      final List<Face> faces = await faceDetector.processImage(inputImage);
      final InputImageRotation rotation = inputImage.metadata?.rotation ?? InputImageRotation.rotation0deg;

      faceDetectionModel = verifyFacePosition(
        mediaQuery,
        FaceDetectionModel(
          faces: faces,
          absoluteImageSize: inputImage.metadata!.size,
          imageRotation: image.inputImageRotation,
          croppedSize: image.croppedSize,
        ),
        rotation,
      );

      widget.onFaceDetected?.call(faceDetectionModel);
      setState(() {});
    } catch (e) {
      logger.e("Error while processing image: $e");
    }
  }

  FaceDetectionModel verifyFacePosition(MediaQueryData mediaQuery, FaceDetectionModel currentModel, InputImageRotation rotation) {
    //? Calculate the outer bounds of the target face position
    final double faceOuterBoundsLeft = mediaQuery.size.width * 0.04;
    final double faceOuterBoundsRight = mediaQuery.size.width - faceOuterBoundsLeft;
    final double faceOuterBoundsTop = mediaQuery.size.height * 0.13;
    final double faceOuterBoundsBottom = mediaQuery.size.height * 0.7;

    //? Calculate the inner bounds of the target face position
    final double faceInnerBoundsLeft = mediaQuery.size.width * 0.40;
    final double faceInnerBoundsRight = mediaQuery.size.width - faceInnerBoundsLeft;
    final double faceInnerBoundsTop = mediaQuery.size.height * 0.40;
    final double faceInnerBoundsBottom = mediaQuery.size.height * 0.5;

    //? Rule: only one face per photo
    if (currentModel.faces.length != 1) {
      return currentModel;
    }

    //? Get the box containing the face
    final Face face = currentModel.faces.first;
    final Rect faceBoundingBox = face.boundingBox;

    //? Check angle of the face, faces should be forward facing
    final bool headEulerXFailed = face.headEulerAngleX == null || face.headEulerAngleX! <= -10 || face.headEulerAngleX! >= 10;
    final bool headEulerYFailed = face.headEulerAngleY == null || face.headEulerAngleY! <= -10 || face.headEulerAngleY! >= 10;
    final bool headEulerZFailed = face.headEulerAngleZ == null || face.headEulerAngleZ! <= -20 || face.headEulerAngleZ! >= 20;
    currentModel = currentModel.copyWith(isFacingCamera: !(headEulerXFailed || headEulerYFailed || headEulerZFailed));

    //? calculate the rotated components of the face bounding box
    late final Offset faceTopLeft;
    late final Offset faceBottomRight;

    if (UniversalPlatform.isIOS) {
      faceTopLeft = rotateResizeImage(Offset(faceBoundingBox.left, faceBoundingBox.top), rotation, mediaQuery.size, currentModel.absoluteImageSize, currentModel.croppedSize);
      faceBottomRight = rotateResizeImage(Offset(faceBoundingBox.right, faceBoundingBox.bottom), rotation, mediaQuery.size, currentModel.absoluteImageSize, currentModel.croppedSize);
    } else {
      faceTopLeft = rotateResizeImage(Offset(faceBoundingBox.right, faceBoundingBox.top), rotation, mediaQuery.size, currentModel.absoluteImageSize, currentModel.croppedSize);
      faceBottomRight = rotateResizeImage(Offset(faceBoundingBox.left, faceBoundingBox.bottom), rotation, mediaQuery.size, currentModel.absoluteImageSize, currentModel.croppedSize);
    }

    //? Check if the bounds of the face are within the upper and Inner bounds
    //? All checks here are for the negative outcome/proving the face is NOT within the bounds
    final bool btl1 = faceTopLeft.dx <= faceOuterBoundsLeft || faceTopLeft.dx >= faceInnerBoundsLeft;
    final bool btl2 = faceTopLeft.dy <= faceOuterBoundsTop || faceTopLeft.dy >= faceInnerBoundsTop;
    final bool bbr1 = faceBottomRight.dx >= faceOuterBoundsRight || faceBottomRight.dx <= faceInnerBoundsRight;
    final bool bbr2 = faceBottomRight.dy >= faceOuterBoundsBottom || faceBottomRight.dy <= faceInnerBoundsBottom;
    currentModel = currentModel.copyWith(isInsideBoundingBox: !(btl1 || btl2 || bbr1 || bbr2));

    return currentModel;
  }

  Future<void> onImageTaken(PhotoCameraState cameraState) async {
    // TODO(ryan): Pause the camera preview while we process the image
    final photo = await cameraState.takePhoto();
    await widget.onCameraImageTaken?.call(photo);
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));

    return Container(
      color: colours.white,
      child: CameraAwesomeBuilder.awesome(
        saveConfig: SaveConfig.photo(
          pathBuilder: () async {
            final Directory dir = await getTemporaryDirectory();
            final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
            return "${dir.path}/$currentTime.jpg";
          },
        ),
        mirrorFrontCamera: true,
        enablePhysicalButton: true,
        topActionsBuilder: (state) => topOverlay(state),
        middleContentBuilder: (state) => cameraOverlay(state),
        bottomActionsBuilder: (state) => widget.cameraNavigation?.call(state) ?? const SizedBox.shrink(),
        previewDecoratorBuilder: buildPreviewDecoratorWidgets,
        filter: AwesomeFilter.None,
        flashMode: FlashMode.auto,
        aspectRatio: CameraAspectRatios.ratio_16_9,
        previewFit: CameraPreviewFit.cover,
        sensor: Sensors.front,
        theme: AwesomeTheme(bottomActionsBackgroundColor: colours.transparent),
        onImageForAnalysis: onAnalyzeImage,
        imageAnalysisConfig: faceAnalysisConfig,
      ),
    );
  }

  Widget topOverlay(CameraState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: widget.topChildren,
      ),
    );
  }

  Widget buildPreviewDecoratorWidgets(CameraState state, PreviewSize previewSize, Rect previewRect) {
    final List<Widget> children = <Widget>[];
    for (final Widget widget in widget.overlayWidgets) {
      children.add(Positioned.fill(child: widget));
    }

    final InputImageRotation inputRotation = faceDetectionModel?.imageRotation ?? InputImageRotation.rotation0deg;
    final Size absoluteImageSize = faceDetectionModel?.absoluteImageSize ?? Size.zero;
    final Size croppedSize = faceDetectionModel?.croppedSize ?? Size.zero;

    if (widget.useFaceDetection) {
      final Widget widget = IgnorePointer(
        child: CustomPaint(
          painter: PositiveCameraFacePainter(
            colors: ref.read(designControllerProvider.select((value) => value.colors)),
            rotationAngle: inputRotation,
            cameraResolution: absoluteImageSize,
            croppedImageSize: croppedSize,
            faces: faceDetectionModel?.faces ?? <Face>[],
            faceFound: hasDetectedFace,
          ),
        ),
      );

      children.add(Positioned.fill(child: widget));
    }

    return Stack(children: children);
  }

  Widget cameraOverlay(CameraState state) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (widget.takePictureCaption != null)
          Text(
            widget.takePictureCaption!,
            textAlign: TextAlign.center,
            style: typography.styleTitle.copyWith(color: colours.white),
            overflow: TextOverflow.clip,
          ),
        const SizedBox(height: kPaddingMedium),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
            //* -=-=-=-=-=-        Create Post without Image Attached        -=-=-=-=-=- *\\
            //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
            if (widget.leftActionCallback != null)
              CameraFloatingButton.postWithoutImage(
                active: canTakePictureOrVideo,
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
              active: canTakePictureOrVideo,
              onTap: () => state.when(
                onPhotoMode: onImageTaken,
                onVideoMode: (videoState) {},
                onVideoRecordingMode: (videoState) {},
              ),
            ),

            const SizedBox(width: kPaddingSmall),
            //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
            //* -=-=-=-=-=-            Change Camera Orientation             -=-=-=-=-=- *\\
            //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
            CameraFloatingButton.changeCamera(
              active: canTakePictureOrVideo,
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
