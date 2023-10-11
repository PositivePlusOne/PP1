// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:app/widgets/molecules/navigation/positive_slim_tab_bar.dart';
import 'package:app/widgets/organisms/post/component/positive_clip_External_shader.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:unicons/unicons.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/ml/face_detector_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
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
    required this.onDelayTimerChanged,
    this.topChildren,
    this.topAdditionalActions,
    this.onCameraImageTaken,
    this.onCameraVideoTaken,
    this.onFaceDetected,
    this.previewFile,
    this.cameraNavigation,
    this.overlayWidgets = const [],
    this.takePictureCaption,
    this.useFaceDetection = false,
    this.isBusy = false,
    this.leftActionWidget,
    this.onTapClose,
    this.onTapAddImage,
    this.enableFlashControls = true,
    this.displayCameraShade = true,
    this.isVideoMode = false,
    this.maxDelay = 0,
    this.maxRecordingLength,
    this.topNavigationSize = kPaddingNone,
    this.bottomNavigationSize = kPaddingNone,
    this.delayTimerOptions = const [],
    this.isDelayTimerEnabled = false,
    this.delayTimerSelection = -1,
    super.key,
  });

  final Future<void> Function(XFile imagePath)? onCameraImageTaken;
  final Future<void> Function(XFile videoPath)? onCameraVideoTaken;
  final void Function(FaceDetectionModel? model)? onFaceDetected;

  // This is useful for when you want to "pause" the camera and show a preview of the image
  final XFile? previewFile;

  final bool useFaceDetection;

  final Widget Function(CameraState)? cameraNavigation;
  final List<Widget>? topChildren;
  final List<Widget>? topAdditionalActions;
  final List<Widget> overlayWidgets;
  final Widget? leftActionWidget;
  final String? takePictureCaption;

  final void Function(BuildContext context)? onTapClose;
  final void Function(BuildContext context)? onTapAddImage;
  final bool enableFlashControls;

  final bool isBusy;
  final bool displayCameraShade;
  final bool isVideoMode;
  final bool isDelayTimerEnabled;

  final double topNavigationSize;
  final double bottomNavigationSize;

  /// delay before recording a clip in milliseconds
  final int maxDelay;

  /// Strings for delay times offered
  final List<String> delayTimerOptions;

  /// callback function when different delay is selected
  final Function(int) onDelayTimerChanged;

  /// current delay timer selection for widget
  final int delayTimerSelection;

  /// maximum recording length of the clip in milliseconds
  final int? maxRecordingLength;

  @override
  ConsumerState<PositiveCamera> createState() => _PositiveCameraState();
}

class _PositiveCameraState extends ConsumerState<PositiveCamera> with LifecycleMixin {
  FaceDetectionModel? faceDetectionModel;
  FlashMode flashMode = FlashMode.auto;

  final SensorConfig config = SensorConfig.single(
    flashMode: FlashMode.auto,
    sensor: Sensor.position(SensorPosition.front),
  );

  PositiveCameraViewMode viewMode = PositiveCameraViewMode.none;

  PermissionStatus? cameraPermissionStatus;
  PermissionStatus? microphonePermissionStatus;
  PermissionStatus? libraryPermissionStatus;

  bool isPhysicalDevice = true;
  bool isCameraButtonCountingDown = false;
  bool isRecording = false;
  bool isCameraButtonSmall = false;
  bool isClipActive = false;

  ///? Current Delay before begining the clip or picture
  int currentDelay = -1;
  Timer? delayTimer;

  bool get hasCameraPermission => (cameraPermissionStatus == PermissionStatus.granted || cameraPermissionStatus == PermissionStatus.limited) && microphonePermissionStatus == PermissionStatus.granted || microphonePermissionStatus == PermissionStatus.limited;
  bool get hasLibraryPermission => libraryPermissionStatus == PermissionStatus.granted || libraryPermissionStatus == PermissionStatus.limited;

  bool get hasDetectedFace => faceDetectionModel != null && faceDetectionModel!.faces.isNotEmpty && faceDetectionModel!.isFacingCamera && faceDetectionModel!.isInsideBoundingBox;

  bool get canTakePictureOrVideo {
    if (widget.isBusy) {
      return false;
    }

    if (widget.useFaceDetection && isPhysicalDevice) {
      return hasDetectedFace;
    }

    return true;
  }

  ///? Shader parameters
  ///

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
      if (mounted) {
        await checkCameraPermission(request: true);
      }

      if (mounted) {
        await checkLibraryPermission(request: true);
      }

      final BaseDeviceInfo deviceInfo = await ref.read(deviceInfoProvider.future);
      if (deviceInfo is AndroidDeviceInfo) {
        isPhysicalDevice = deviceInfo.isPhysicalDevice;
      } else if (deviceInfo is IosDeviceInfo) {
        isPhysicalDevice = deviceInfo.isPhysicalDevice;
      }

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
    isRecording = false;
    isCameraButtonSmall = false;
    isClipActive = false;
    currentDelay = 0;

    if (delayTimer != null) {
      delayTimer!.cancel();
      delayTimer = null;
    }

    faceDetector.close();
    super.deactivate();
  }

  Future<void> checkCameraPermission({bool request = false}) async {
    try {
      if (request) {
        cameraPermissionStatus = await Permission.camera.request();
        microphonePermissionStatus = await Permission.microphone.request();
      } else {
        cameraPermissionStatus = await Permission.camera.status;
        microphonePermissionStatus = await Permission.microphone.status;
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

  void onInternalAddImageTap(BuildContext context) {
    if (!hasLibraryPermission) {
      viewMode = PositiveCameraViewMode.libraryPermissionOverlay;
      setStateIfMounted();
      return;
    }

    widget.onTapAddImage?.call(context);
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
      setStateIfMounted(callback: () {});
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

  Future<void> onVideoRecordingRequestStart(CameraState cameraState) async {
    late VideoCameraState videoState;
    cameraState.when(
      onVideoMode: (p0) {
        videoState = p0;
      },
    );

    if (isClipActive) {
      return;
    }

    //? clear old timer if duplicated
    if (delayTimer != null) {
      delayTimer!.cancel();
    }

    //? Request the smaller camera button center
    setStateIfMounted(callback: () {
      isCameraButtonSmall = true;
      isClipActive = true;
    });

    //? If a maximum delay has been set then begin the delay timer
    if (widget.maxDelay > 0) {
      setStateIfMounted(
        callback: () {
          currentDelay = widget.maxDelay;
        },
      );

      delayTimer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) {
          if (currentDelay <= 0) {
            timer.cancel();
            onVideoRecordingStart(cameraState);
          } else {
            setStateIfMounted(
              callback: () {
                currentDelay = currentDelay - 1;
              },
            );
          }
        },
      );
      return;
    }
    //? If no delay has been set then begin recording the clip
    onVideoRecordingStart(cameraState);
  }

  Future<void> onVideoRecordingStart(CameraState cameraState) async {
    late VideoCameraState videoState;
    cameraState.when(
      onVideoMode: (p0) {
        videoState = p0;
      },
    );

    //? Begin clip recording
    await videoState.startRecording();
    setStateIfMounted(callback: () {
      isRecording = true;
    });

    await Future.delayed(
      Duration(milliseconds: widget.maxRecordingLength ?? 1),
    );

    setStateIfMounted(callback: () {
      isRecording = false;
      isClipActive = true;
      isCameraButtonSmall = false;
    });

    await onVideoRecordingEnd(cameraState);
  }

  Future<void> onVideoRecordingEnd(CameraState cameraState) async {
    VideoRecordingCameraState videoRecordingCameraState = VideoRecordingCameraState.from(cameraState.cameraContext);
    await videoRecordingCameraState.stopRecording();

    MediaCapture? currentCapture = videoRecordingCameraState.cameraContext.mediaCaptureController.value;

    if (currentCapture != null) {
      final XFile? file = await currentCapture.captureRequest.when(
        single: (single) => single.file,
      );

      if (file == null) {
        return;
      }

      await widget.onCameraVideoTaken?.call(file);
    }
  }

  Future<void> onImageTaken(PhotoCameraState cameraState) async {
    final CaptureRequest captureRequest = await cameraState.takePhoto();
    final XFile? file = captureRequest.when(
      single: (p0) => p0.file,
    );

    if (file == null) {
      return;
    }

    await widget.onCameraImageTaken?.call(file);
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppRouter appRouter = ref.watch(appRouterProvider);

    useLifecycleHook(this);

    final Widget camera = CameraAwesomeBuilder.awesome(
      saveConfig: SaveConfig.photoAndVideo(
        mirrorFrontCamera: true,
        photoPathBuilder: (sens) => buildCaptureRequest(sens, false),
        videoOptions: VideoOptions(enableAudio: true),
        videoPathBuilder: (sens) => buildCaptureRequest(sens, true),
      ),
      sensorConfig: config,
      enablePhysicalButton: true,
      topActionsBuilder: (state) => topOverlay(state),
      middleContentBuilder: (state) => cameraOverlay(state),
      bottomActionsBuilder: (state) => widget.cameraNavigation?.call(state) ?? const SizedBox.shrink(),
      previewDecoratorBuilder: buildPreviewDecoratorWidgets,
      filter: AwesomeFilter.None,
      previewFit: CameraPreviewFit.cover,
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
        elevation: viewMode != PositiveCameraViewMode.none ? 1.0 : 0.0, // Add a white line to the top of the app bar
        shadowColor: colours.white,
        leadingWidth: kPaddingAppBarBreak,
        leading: viewMode != PositiveCameraViewMode.none
            ? Container(
                padding: const EdgeInsets.only(left: kPaddingMedium),
                alignment: Alignment.centerLeft,
                child: CameraFloatingButton.close(
                  active: true,
                  onTap: widget.onTapClose ?? (context) => appRouter.removeLast(),
                ),
              )
            : const SizedBox.shrink(),
        actions: <Widget>[
          if (viewMode != PositiveCameraViewMode.camera && widget.leftActionWidget != null) ...<Widget>[
            Container(
              padding: const EdgeInsets.only(right: kPaddingMedium),
              alignment: Alignment.centerRight,
              child: widget.leftActionWidget!,
            ),
          ],
          if (viewMode == PositiveCameraViewMode.libraryPermissionOverlay) ...<Widget>[
            Container(
              padding: const EdgeInsets.only(right: kPaddingMedium),
              alignment: Alignment.centerRight,
              child: CameraFloatingButton.showCamera(
                active: true,
                onTap: (context) => setStateIfMounted(callback: () {
                  viewMode = hasCameraPermission ? PositiveCameraViewMode.camera : PositiveCameraViewMode.cameraPermissionOverlay;
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
              cameraPermissionStatus = await Permission.camera.status;
              microphonePermissionStatus = await Permission.microphone.status;
              if (!hasCameraPermission) {
                final SystemController systemController = ref.read(systemControllerProvider.notifier);
                await systemController.openPermissionSettings();
                cameraPermissionStatus == await Permission.camera.status;
                microphonePermissionStatus = await Permission.microphone.status;
              }

              viewMode = hasCameraPermission ? PositiveCameraViewMode.camera : PositiveCameraViewMode.cameraPermissionOverlay;
              setStateIfMounted();
            }));
        break;
      case PositiveCameraViewMode.libraryPermissionOverlay:
        children.add(LibraryPermissionDialog(
          colours: colours,
          typography: typography,
          ref: ref,
          onTapClose: () async {
            final BaseDeviceInfo deviceInfoPlugin = await ref.read(deviceInfoProvider.future);
            Permission basePermission = Permission.photos;
            if (deviceInfoPlugin is AndroidDeviceInfo) {
              final int sdkInt = deviceInfoPlugin.version.sdkInt;
              if (sdkInt < 30) {
                basePermission = Permission.storage;
              }
            }

            libraryPermissionStatus = await basePermission.status;
            final bool isGranted = libraryPermissionStatus == PermissionStatus.granted || libraryPermissionStatus == PermissionStatus.limited;
            if (!isGranted) {
              final SystemController systemController = ref.read(systemControllerProvider.notifier);
              await systemController.openPermissionSettings();
              libraryPermissionStatus == await basePermission.status;
            }

            viewMode = libraryPermissionStatus == PermissionStatus.granted || cameraPermissionStatus == PermissionStatus.limited ? PositiveCameraViewMode.camera : PositiveCameraViewMode.cameraPermissionOverlay;
            if (libraryPermissionStatus == PermissionStatus.granted || cameraPermissionStatus == PermissionStatus.limited) {
              onInternalAddImageTap(context);
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
    //TODO move this to a less awkward area? if possible
    if (widget.isVideoMode) {
      if (state.captureMode != CaptureMode.video) {
        state.setState(CaptureMode.video);
      }
    } else {
      if (state.captureMode != CaptureMode.photo) {
        state.setState(CaptureMode.photo);
      }
    }
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: kPaddingMedium,
        vertical: kPaddingSmall,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: (widget.topChildren != null) ? widget.topChildren! : getPositiveCameraGenericTopChildren,
          ),
          const SizedBox(height: kPaddingLarge),
          if (isRecording)
            Container(
              width: kPaddingMedium,
              height: kPaddingMedium,
              decoration: BoxDecoration(
                color: colours.red,
                borderRadius: BorderRadius.circular(kBorderRadiusInfinite),
              ),
            ),
          if (widget.topAdditionalActions != null && widget.isVideoMode && !isRecording) ...widget.topAdditionalActions!,
        ],
      ),
    );
  }

  List<Widget> get getPositiveCameraGenericTopChildren {
    return [
      if (widget.onTapClose != null) CameraFloatingButton.close(active: true, onTap: widget.onTapClose!),
      const Spacer(),
      if (widget.enableFlashControls && hasCameraPermission)
        CameraFloatingButton.flash(
          active: true,
          flashMode: flashMode,
          onTap: onFlashToggleRequest,
        ),
      const SizedBox(width: kPaddingSmall),
      if (widget.onTapAddImage != null) CameraFloatingButton.addImage(active: true, onTap: onInternalAddImageTap),
    ];
  }

  Widget buildPreviewDecoratorWidgets(CameraState state, PreviewSize previewSize, Rect previewRect) {
    final List<Widget> children = <Widget>[];
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    // Add a shade to the top and bottom of the screen, leaving a square in the middle
    final Size screenSize = MediaQuery.of(context).size;
    final double smallestSide = screenSize.width < screenSize.height ? screenSize.width : screenSize.height;

    if (widget.previewFile != null) {
      children.add(Positioned.fill(child: Image.file(File(widget.previewFile!.path), fit: BoxFit.cover)));
    }

    if (widget.displayCameraShade) {
      ///? precalculating here, this could move
      final double paddingLeft = (currentDelay > 0) ? screenSize.width / 2 : kPaddingNone;
      final double paddingRight = (currentDelay > 0) ? screenSize.width / 2 : kPaddingNone;

      final double paddingTop = widget.isVideoMode
          ? (currentDelay > 0)
              ? screenSize.height / 2
              : widget.topNavigationSize
          : previewSize.height * 0.22;

      final double paddingBottom = widget.isVideoMode
          ? (currentDelay > 0)
              ? screenSize.height / 2
              : widget.bottomNavigationSize
          : previewSize.height * 0.3;

      final double radius = widget.isVideoMode
          ? (currentDelay > 0)
              ? kBorderRadiusInfinite
              : kBorderRadiusLarge
          : kBorderRadiusNone;

      children.add(
        Positioned.fill(
          child: PositiveClipExternalShader(
            paddingLeft: paddingLeft,
            paddingRight: paddingRight,
            paddingTop: paddingTop,
            paddingBottom: paddingBottom,
            colour: colours.black.withOpacity(kOpacityVignette),
            radius: radius,
          ),
        ),
      );
    }
    if (currentDelay >= 0) {
      children.add(
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: Text(
              currentDelay.toString(),
              style: typography.styleHero.copyWith(color: Colors.white),
            ),
          ),
        ),
      );
    }

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
    final MediaQueryData mediaQuery = MediaQuery.of(context);

    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
      child: Column(
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
          if (widget.delayTimerSelection >= 0 && widget.isVideoMode && widget.isDelayTimerEnabled)
            SizedBox(
              width: 155,
              child: PositiveSlimTabBar(
                tabs: widget.delayTimerOptions,
                onTapped: (index) => widget.onDelayTimerChanged(index),
                tabColours: [colours.black, colours.black],
                unselectedColour: colours.white,
                index: widget.delayTimerSelection,
              ),
            ),
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
                loadingColour: colours.yellow,
                // loadingProgress: recordingCompletion,
                isLoading: isRecording,
                maxCLipDuration: widget.maxRecordingLength,
                isSmallButton: isRecording,
                onTap: (_) {
                  state.when(
                    onPhotoMode: onImageTaken,
                    onVideoMode: (_) => onVideoRecordingRequestStart(state),
                    // onVideoRecordingMode: () => onVideoRecordingEnd(VideoRecordingCameraState.from(orchestrator)),
                  );
                },
              ),

              const SizedBox(width: kPaddingSmall),
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-            Change Camera Orientation             -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              CameraFloatingButton.changeCamera(
                active: canTakePictureOrVideo,
                onTap: (context) => onChangeCameraRequest(context, state),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // double? get getProgressClipLength {
  //   if (recordingLengthTimer == null || widget.maxRecordingLength == null) {
  //     return null;
  //   }

  //   return recordingLengthTimer!.elapsed.inMilliseconds / widget.maxRecordingLength!;
  // }

  // double? get getProgressDelay {
  //   if (delayTimer == null || widget.maxDelay == null) {
  //     return null;
  //   }

  //   return delayTimer!.elapsed.inMilliseconds / widget.maxDelay!;
  // }

  Future<void> onFlashToggleRequest(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);

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

    logger.i("Flash mode: $flashMode");
    await config.setFlashMode(flashMode);

    setStateIfMounted();
  }

  Future<CaptureRequest> buildCaptureRequest(List<Sensor> sensors, bool isVideo) async {
    final Directory dir = await getTemporaryDirectory();
    final String currentTime = DateTime.now().millisecondsSinceEpoch.toString();
    final String filePath = '${dir.path}/$currentTime.${isVideo ? 'mp4' : 'jpg'}';

    return SingleCaptureRequest(filePath, sensors.first);
  }

  Future<void> onChangeCameraRequest(BuildContext context, CameraState state) async {
    if (!mounted) {
      return;
    }

    await state.switchCameraSensor();
    await state.sensorConfig.setFlashMode(flashMode);
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
