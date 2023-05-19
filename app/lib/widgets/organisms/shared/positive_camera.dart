// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:camerawesome/pigeon.dart';
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
import 'package:app/helpers/enhanced_behaviour_subject.dart';
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
    this.cancelButton,
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
  final VoidCallback? cancelButton;
  final Widget Function(CameraState)? cameraNavigation;
  final List<Widget> topChildren;
  final List<Widget> overlayWidgets;
  final String? takePictureCaption;
  final bool faceTrackerActive;

  final bool isBusy;

  @override
  ConsumerState<PositiveCamera> createState() => _PositiveCameraState();
}

class _PositiveCameraState extends ConsumerState<PositiveCamera> {
  StreamSubscription? faceDetectionSubscription;
  FaceDetectionModel? faceDetectionModel;

  bool get hasDetectedFace => faceDetectionModel != null;
  bool get canTakePictureOrVideo => !widget.isBusy && (!widget.useFaceDetection || (faceDetectionModel?.faces.isNotEmpty ?? false));

  final EnhancedBehaviorSubject<FaceDetectionModel?> faceDetectionController = EnhancedBehaviorSubject<FaceDetectionModel?>(
    subject: BehaviorSubject<FaceDetectionModel?>(),
  );

  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(enableContours: true, enableLandmarks: true),
  );

  final AnalysisConfig faceAnalysisConfig = AnalysisConfig(
    androidOptions: const AndroidAnalysisOptions.nv21(width: 250),
    maxFramesPerSecond: 30.0,
  );

  @override
  void initState() {
    super.initState();
    faceDetectionSubscription = faceDetectionController.subject.stream.listen(onFacesDetected);
  }

  @override
  void deactivate() {
    faceDetector.close();
    super.deactivate();
  }

  @override
  void dispose() {
    faceDetectionSubscription?.cancel();
    faceDetectionController.close();
    super.dispose();
  }

  void onFacesDetected(FaceDetectionModel? event) {
    if (!mounted) {
      return;
    }

    faceDetectionModel = event;
    widget.onFaceDetected?.call(event);
    setState(() {});
  }

  Future<void> onAnalyzeImage(AnalysisImage image) async {
    if (!mounted) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);

    try {
      final InputImage inputImage = image.toInputImage();
      final List<Face> faces = await faceDetector.processImage(inputImage);
      final FaceDetectionModel faceDetectionModel = FaceDetectionModel(
        faces: faces,
        absoluteImageSize: inputImage.inputImageData!.size,
        rotation: 0,
        imageRotation: image.inputImageRotation,
        croppedSize: image.croppedSize,
      );

      final InputImageRotation rotation = inputImage.inputImageData?.imageRotation ?? InputImageRotation.rotation0deg;
      final bool verifyFace = verifyFacePosition(image.croppedSize, rotation, faces);
      if (verifyFace) {
        return;
      }

      faceDetectionController.add(faceDetectionModel);
    } catch (e) {
      logger.e("Error while processing image: $e");
    }
  }

  bool verifyFacePosition(Size size, InputImageRotation rotation, List<Face> facesToCheck) {
    //? Calculate the outer bounds of the target face position
    final double faceOuterBoundsLeft = size.width * 0.04;
    final double faceOuterBoundsRight = size.width - faceOuterBoundsLeft;
    final double faceOuterBoundsTop = size.height * 0.13;
    final double faceOuterBoundsBottom = size.height * 0.7;

    //? Calculate the inner bounds of the target face position
    final double faceInnerBoundsLeft = size.width * 0.40;
    final double faceInnerBoundsRight = size.width - faceInnerBoundsLeft;
    final double faceInnerBoundsTop = size.height * 0.40;
    final double faceInnerBoundsBottom = size.height * 0.5;

    //? Rule: only one face per photo
    if (facesToCheck.length == 1) {
      //? Get the box containing the face
      final Face face = facesToCheck.first;
      final Rect faceBoundingBox = face.boundingBox;

      //? Check angle of the face, faces should be forward facing
      if (face.headEulerAngleX == null || face.headEulerAngleX! <= -10 || face.headEulerAngleX! >= 10) return false;
      if (face.headEulerAngleY == null || face.headEulerAngleY! <= -10 || face.headEulerAngleY! >= 10) return false;
      if (face.headEulerAngleZ == null || face.headEulerAngleZ! <= -20 || face.headEulerAngleZ! >= 20) return false;

      //? calculate the rotated components of the face bounding box
      const Size inputImageSize = Size(100, 100); // Assuming the input image is 100x100
      final double faceLeft = rotateResizeImageX(faceBoundingBox.right, rotation, size, inputImageSize);
      final double faceRight = rotateResizeImageX(faceBoundingBox.left, rotation, size, inputImageSize);
      final double faceTop = rotateResizeImageY(faceBoundingBox.top, rotation, size, inputImageSize);
      final double faceBottom = rotateResizeImageY(faceBoundingBox.bottom, rotation, size, inputImageSize);

      //? Check if the bounds of the face are within the upper and Inner bounds
      //? All checks here are for the negative outcome/proving the face is NOT within the bounds
      if (faceLeft <= faceOuterBoundsLeft || faceLeft >= faceInnerBoundsLeft) return false;
      if (faceRight >= faceOuterBoundsRight || faceRight <= faceInnerBoundsRight) return false;
      if (faceTop <= faceOuterBoundsTop || faceTop >= faceInnerBoundsTop) return false;
      if (faceBottom >= faceOuterBoundsBottom || faceBottom <= faceInnerBoundsBottom) return false;
    } else {
      return false;
    }

    return true;
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
        imageAnalysisConfig: AnalysisConfig(
          androidOptions: AndroidAnalysisOptions.nv21(width: 500),
          autoStart: widget.faceTrackerActive,
          maxFramesPerSecond: 5,
        ),
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
    final Size imageSize = Size(previewSize.width, previewSize.height);

    if (widget.useFaceDetection) {
      final Widget widget = IgnorePointer(
        child: CustomPaint(
          painter: PositiveCameraFacePainter(
            colors: ref.read(designControllerProvider.select((value) => value.colors)),
            rotationAngle: inputRotation,
            cameraResolution: imageSize,
            faces: faceDetectionModel?.faces ?? <Face>[],
            faceFound: faceDetectionModel?.faces.isNotEmpty ?? false,
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

  Future _analyzeImage(AnalysisImage image) async {
    if (widget.onImageSentForAnalysis == null) {
      return;
    }
    widget.onImageSentForAnalysis!(image);
  }
}
