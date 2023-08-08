// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicons/unicons.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/ml/face_detector_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/helpers/image_helpers.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/camera/camera_floating_button.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/organisms/shared/components/mlkit_utils.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../dtos/system/design_typography_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../../providers/system/system_controller.dart';
import '../../atoms/camera/camera_button_painter.dart';
import 'painters/positive_camera_face_painter.dart';

enum PositiveCameraViewMode {
  none,
  camera,
  cameraPermissionOverlay,
  libraryPermissionOverlay,
}

class PositiveCamera extends StatefulHookConsumerWidget {
  const PositiveCamera({
    this.topChildren,
    this.onCameraImageTaken,
    this.onFaceDetected,
    this.cameraNavigation,
    this.overlayWidgets = const [],
    this.takePictureCaption,
    this.useFaceDetection = false,
    this.isBusy = false,
    this.leftActionWidget,
    this.onTapClose,
    this.onTapAddImage,
    this.enableFlashControlls = false,
    super.key,
  });

  final Future<void> Function(String imagePath)? onCameraImageTaken;
  final void Function(FaceDetectionModel? model)? onFaceDetected;

  final bool useFaceDetection;

  final Widget Function(CameraState)? cameraNavigation;
  final List<Widget>? topChildren;
  final List<Widget> overlayWidgets;
  final Widget? leftActionWidget;
  final String? takePictureCaption;

  final VoidCallback? onTapClose;
  final VoidCallback? onTapAddImage;
  final bool enableFlashControlls;

  final bool isBusy;

  @override
  ConsumerState<PositiveCamera> createState() => _PositiveCameraState();
}

class _PositiveCameraState extends ConsumerState<PositiveCamera> with LifecycleMixin {
  FaceDetectionModel? faceDetectionModel;
  FlashMode flashMode = FlashMode.auto;

  PositiveCameraViewMode viewMode = PositiveCameraViewMode.none;

  PermissionStatus? cameraPermissionStatus;
  PermissionStatus? libraryPermissionStatus;

  bool get hasCameraPermission => cameraPermissionStatus == PermissionStatus.granted || cameraPermissionStatus == PermissionStatus.limited;
  bool get hasLibraryPermission => libraryPermissionStatus == PermissionStatus.granted || libraryPermissionStatus == PermissionStatus.limited;

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

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      await checkCameraPermission(request: true);
      await checkLibraryPermission(request: true);

      if (hasCameraPermission) {
        viewMode = PositiveCameraViewMode.camera;
      } else {
        viewMode = PositiveCameraViewMode.cameraPermissionOverlay;
      }

      setStateIfMounted();
    });
  }

  @override
  void deactivate() {
    faceDetector.close();
    super.deactivate();
  }

  Future<void> checkCameraPermission({bool request = false}) async {
    try {
      if (request) {
        cameraPermissionStatus = await Permission.camera.request();
      } else {
        cameraPermissionStatus = await Permission.camera.status;
      }
    } catch (e) {
      cameraPermissionStatus = PermissionStatus.denied;
    }
  }

  Future<void> checkLibraryPermission({bool request = false}) async {
    final BaseDeviceInfo deviceInfo = await ref.read(deviceInfoProvider.future);
    Permission baseLibraryPermission = Permission.photos;

    // Check if Android and past Tiramisu version
    if (deviceInfo is AndroidDeviceInfo) {
      final int sdkInt = deviceInfo.version.sdkInt;
      if (sdkInt < 30) {
        baseLibraryPermission = Permission.storage;
      }
    }

    try {
      libraryPermissionStatus = await baseLibraryPermission.request();
    } catch (e) {
      libraryPermissionStatus = PermissionStatus.denied;
    }
  }

  void onInternalAddImageTap() {
    if (!hasLibraryPermission) {
      viewMode = PositiveCameraViewMode.libraryPermissionOverlay;
      setStateIfMounted();
      return;
    }

    widget.onTapAddImage!();
    setStateIfMounted();
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
      final InputImageRotation rotation = inputImage.inputImageData?.imageRotation ?? InputImageRotation.rotation0deg;

      faceDetectionModel = verifyFacePosition(
        mediaQuery,
        FaceDetectionModel(
          faces: faces,
          absoluteImageSize: inputImage.inputImageData!.size,
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
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    useLifecycleHook(this);

    final Widget camera = CameraAwesomeBuilder.awesome(
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
      flashMode: flashMode,
      aspectRatio: CameraAspectRatios.ratio_16_9,
      previewFit: CameraPreviewFit.cover,
      sensor: Sensors.front,
      theme: AwesomeTheme(bottomActionsBackgroundColor: colours.transparent),
      onImageForAnalysis: onAnalyzeImage,
      imageAnalysisConfig: faceAnalysisConfig,
    );

    final Widget tempAppBar = Positioned(
      top: kPaddingNone,
      left: kPaddingNone,
      right: kPaddingNone,
      child: AppBar(
        backgroundColor: colours.black,
        elevation: 1.0, // Add a white line to the top of the app bar
        shadowColor: colours.white,
        leadingWidth: kPaddingAppBarBreak,
        leading: Container(
          padding: const EdgeInsets.only(left: kPaddingMedium),
          alignment: Alignment.centerLeft,
          child: CameraFloatingButton.close(active: true, onTap: widget.onTapClose!),
        ),
        actions: <Widget>[
          if (viewMode == PositiveCameraViewMode.libraryPermissionOverlay) ...<Widget>[
            Container(
              padding: const EdgeInsets.only(right: kPaddingMedium),
              alignment: Alignment.centerRight,
              child: CameraFloatingButton.showCamera(
                active: true,
                onTap: () => setState(() {
                  viewMode = cameraPermissionStatus == PermissionStatus.granted ? PositiveCameraViewMode.camera : PositiveCameraViewMode.cameraPermissionOverlay;
                }),
              ),
            ),
          ],
          if (viewMode == PositiveCameraViewMode.cameraPermissionOverlay) ...<Widget>[
            Container(
              padding: const EdgeInsets.only(right: kPaddingMedium),
              alignment: Alignment.centerRight,
              child: CameraFloatingButton.addImage(
                active: true,
                onTap: onInternalAddImageTap,
              ),
            ),
          ],
        ],
      ),
    );

    final List<Widget> children = <Widget>[];
    switch (viewMode) {
      case PositiveCameraViewMode.none:
        children.add(Align(alignment: Alignment.center, child: PositiveLoadingIndicator(color: colours.white)));
        break;
      case PositiveCameraViewMode.camera:
        children.add(camera);
        break;
      case PositiveCameraViewMode.cameraPermissionOverlay:
        children.add(CameraPermissionDialog(
            colours: colours,
            typography: typography,
            ref: ref,
            onTapClose: () async {
              await checkCameraPermission();
              if (!hasCameraPermission) {
                final SystemController systemController = ref.read(systemControllerProvider.notifier);
                await systemController.openPermissionSettings();
              } else {
                viewMode = PositiveCameraViewMode.camera;
                setStateIfMounted();
              }
            }));
        break;
      case PositiveCameraViewMode.libraryPermissionOverlay:
        children.add(LibraryPermissionDialog(
          colours: colours,
          typography: typography,
          ref: ref,
          onTapClose: () async {
            await checkLibraryPermission();
            if (!hasLibraryPermission) {
              final SystemController systemController = ref.read(systemControllerProvider.notifier);
              await systemController.openPermissionSettings();
            } else {
              viewMode = hasCameraPermission ? PositiveCameraViewMode.camera : PositiveCameraViewMode.cameraPermissionOverlay;
              onInternalAddImageTap();
            }
          },
        ));
        break;
      default:
        children.add(const SizedBox.shrink());
    }

    if (viewMode != PositiveCameraViewMode.camera) {
      children.add(tempAppBar);
    }

    return Container(
      color: colours.black,
      child: Stack(children: children),
    );
  }

  Widget topOverlay(CameraState state) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingSmall),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: (widget.topChildren != null) ? widget.topChildren! : getPositiveCameraGenericTopChildren,
      ),
    );
  }

  List<Widget> get getPositiveCameraGenericTopChildren {
    return [
      if (widget.onTapClose != null) CameraFloatingButton.close(active: true, onTap: widget.onTapClose!),
      const Spacer(),
      if (widget.enableFlashControlls && hasCameraPermission)
        CameraFloatingButton.flash(
          active: true,
          flashMode: flashMode,
          onTap: () {
            setState(
              () {
                switch (flashMode) {
                  case FlashMode.none:
                    flashMode = FlashMode.auto;
                    break;
                  case FlashMode.auto:
                    flashMode = FlashMode.always;
                    break;
                  default:
                    flashMode = FlashMode.none;
                }
              },
            );
          },
        ),
      const SizedBox(width: kPaddingExtraSmall),
      if (widget.onTapAddImage != null) CameraFloatingButton.addImage(active: true, onTap: onInternalAddImageTap),
    ];
  }

  Widget buildPreviewDecoratorWidgets(CameraState state, PreviewSize previewSize, Rect previewRect) {
    final List<Widget> children = <Widget>[];
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    // Add a shade to the top and bottom of the screen, leaving a square in the middle
    final Size screenSize = MediaQuery.of(context).size;
    final double smallestSide = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;

    children.add(Column(
      children: <Widget>[
        Expanded(
          flex: 4,
          child: Container(color: colours.black.withOpacity(0.75)),
        ),
        SizedBox(
          height: smallestSide,
          width: smallestSide,
        ),
        Expanded(
          flex: 6,
          child: Container(color: colours.black.withOpacity(0.75)),
        ),
      ],
    ));

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
            widget.leftActionWidget ?? const SizedBox(width: kIconLarge),

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
      ],
    );
  }
}

class LibraryPermissionDialog extends StatelessWidget {
  const LibraryPermissionDialog({
    super.key,
    required this.colours,
    required this.typography,
    required this.ref,
    required this.onTapClose,
  });

  final DesignColorsModel colours;
  final DesignTypographyModel typography;
  final WidgetRef ref;

  final FutureOr<void> Function()? onTapClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colours.black,
      alignment: Alignment.center,
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingLarge),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(UniconsLine.image_plus, size: kIconMedium, color: colours.white),
          const SizedBox(height: kPaddingSmall),
          Text(
            "Enable access to your photo library",
            style: typography.styleButtonBold.copyWith(color: colours.white),
          ),
          const SizedBox(height: kPaddingSmall),
          SizedBox(
            child: Align(
              child: Row(
                children: [
                  const Spacer(),
                  PositiveButton(
                    label: "Enable Library Access",
                    colors: colours,
                    style: PositiveButtonStyle.primary,
                    primaryColor: colours.teal,
                    padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingVerySmall),
                    onTapped: () => onTapClose?.call(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class CameraPermissionDialog extends StatelessWidget {
  const CameraPermissionDialog({
    super.key,
    required this.colours,
    required this.typography,
    required this.ref,
    required this.onTapClose,
  });

  final DesignColorsModel colours;
  final DesignTypographyModel typography;
  final WidgetRef ref;
  final FutureOr<void> Function()? onTapClose;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: colours.black,
      padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingLarge),
      alignment: Alignment.center,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(UniconsLine.image_plus, size: kIconMedium, color: colours.white),
          const SizedBox(height: kPaddingSmall),
          Text(
            "Enable access to your camera",
            textAlign: TextAlign.center,
            style: typography.styleButtonBold.copyWith(color: colours.white),
          ),
          const SizedBox(height: kPaddingSmall),
          Text(
            "To create content, allow access to your camera & microphone",
            textAlign: TextAlign.center,
            style: typography.styleBody.copyWith(color: colours.white),
          ),
          const SizedBox(height: kPaddingSmall),
          SizedBox(
            child: Align(
              child: Row(
                children: [
                  const Spacer(),
                  PositiveButton(
                    label: "Open Settings",
                    colors: colours,
                    style: PositiveButtonStyle.primary,
                    primaryColor: colours.teal,
                    padding: const EdgeInsets.symmetric(horizontal: kPaddingMedium, vertical: kPaddingVerySmall),
                    onTapped: () => onTapClose?.call(),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
