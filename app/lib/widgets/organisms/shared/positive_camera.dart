// Dart imports:
import 'dart:async';
import 'dart:io';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
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
import 'package:wheel_chooser/wheel_chooser.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/ml/face_detector_model.dart';
import 'package:app/extensions/permission_extensions.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/helpers/image_helpers.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/buttons/enumerations/positive_button_style.dart';
import 'package:app/widgets/atoms/buttons/positive_button.dart';
import 'package:app/widgets/atoms/camera/camera_floating_button.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/molecules/navigation/positive_slim_tab_bar.dart';
import 'package:app/widgets/organisms/post/component/positive_clip_External_shader.dart';
import 'package:app/widgets/organisms/shared/components/mlkit_utils.dart';
import 'package:app/widgets/organisms/shared/components/scrolling_selector.dart';
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
}

class PositiveCamera extends StatefulHookConsumerWidget {
  const PositiveCamera({
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
    this.textPostActionWidget,
    this.onTapClose,
    this.onTapForceClose,
    this.onTapAddImage,
    this.enableFlashControls = true,
    this.displayCameraShade = true,
    this.isVideoMode = false,
    this.topNavigationSize = kPaddingNone,
    this.bottomNavigationSize = kPaddingNone,
    this.onClipStateChange,
    //* -=-=-=-=-  Delay Timer Variables -=-=-=-=- *\\
    required this.onDelayTimerChanged,
    this.isDelayTimerEnabled = false,
    this.maxDelay = 0,
    this.delayTimerSelection = -1,
    this.delayTimerOptions = const [],
    //* -=-=-=-=-  Clip Timer Variables  -=-=-=-=- *\\
    required this.onRecordingLengthChanged,
    this.isRecordingLengthEnabled = false,
    this.maxRecordingLength = 0,
    this.recordingLengthSelection = -1,
    this.recordingLengthOptions = const [],
    this.onCameraStarted,
    super.key,
  });

  final Future<void> Function(XFile imagePath)? onCameraImageTaken;
  final Future<void> Function(XFile videoPath)? onCameraVideoTaken;
  final void Function(FaceDetectionModel? model)? onFaceDetected;

  final VoidCallback? onCameraStarted;

  // This is useful for when you want to "pause" the camera and show a preview of the image
  final XFile? previewFile;

  final bool useFaceDetection;

  final Widget Function(CameraState)? cameraNavigation;
  final List<Widget>? topChildren;
  final List<Widget>? topAdditionalActions;
  final List<Widget> overlayWidgets;
  final Widget? textPostActionWidget;
  final String? takePictureCaption;

  final void Function(BuildContext context)? onTapClose;
  final void Function(BuildContext context)? onTapForceClose;
  final void Function(BuildContext context)? onTapAddImage;
  final bool enableFlashControls;

  final bool isBusy;

  final double topNavigationSize;
  final double bottomNavigationSize;

  final bool isVideoMode;
  final bool displayCameraShade;

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-  Delay Timer Variables -=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\

  /// delay before recording a clip in milliseconds
  final int maxDelay;

  /// Strings for delay times offered
  final List<String> delayTimerOptions;

  /// callback function when different delay is selected
  final Function(int) onDelayTimerChanged;

  /// current delay timer selection for widget
  final int delayTimerSelection;

  /// should display the delay timer for clips
  final bool isDelayTimerEnabled;

  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
  //* -=-=-=-=-  Clip Timer Variables  -=-=-=-=- *\\
  //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\

  /// maximum recording length of the clip in milliseconds
  final int? maxRecordingLength;

  /// Strings for clip durations offered
  final List<String> recordingLengthOptions;

  /// callback function when different clip timer is selected
  final Function(int) onRecordingLengthChanged;

  /// current clip timer selection for widget
  final int recordingLengthSelection;

  /// should display the maximum recording timer for clips
  final bool isRecordingLengthEnabled;

  /// Called whenever clip begins or ends recording, returns true when begining, returns false when ending
  final Function(ClipRecordingState clipRecordingState)? onClipStateChange;

  @override
  ConsumerState<PositiveCamera> createState() => PositiveCameraState();
}

class PositiveCameraState extends ConsumerState<PositiveCamera> with LifecycleMixin {
  FaceDetectionModel? faceDetectionModel;
  CaptureRequest? videoCaptureRequest;

  FlashMode flashMode = FlashMode.auto;

  final SensorConfig config = SensorConfig.single(
    flashMode: FlashMode.auto,
    sensor: Sensor.position(SensorPosition.front),
  );

  PositiveCameraViewMode viewMode = PositiveCameraViewMode.none;

  PermissionStatus? cameraPermissionStatus;
  PermissionStatus? microphonePermissionStatus;
  PermissionStatus? libraryImagePermissionStatus;
  PermissionStatus? libraryVideoPermissionStatus;

  bool isPhysicalDevice = true;

  bool hasStartedCamera = false;

  ///? Location to access the current camera state outside of the builder
  CameraState? cachedCameraState;

  ///? is the camera currently recording video or in the prerecording state (for delay/countdown timer)
  ClipRecordingState clipRecordingState = ClipRecordingState.notRecording;

  ///? Current Delay before begining the clip or picture
  int currentDelay = -1;
  Timer? delayTimer;

  ///? Clip timer to enact the clips maximum duration
  int clipCurrentTime = 0;
  Timer? clipTimer;

  bool get hasCameraPermission {
    final bool isCameraPermissionGranted = cameraPermissionStatus?.canUsePermission ?? false;
    final bool isMicrophonePermissionGranted = microphonePermissionStatus?.canUsePermission ?? false;

    return isCameraPermissionGranted && isMicrophonePermissionGranted;
  }

  bool get hasLibraryPermission {
    final bool isLibraryImagePermissionGranted = libraryImagePermissionStatus?.canUsePermission ?? false;
    final bool isLibraryVideoPermissionGranted = libraryVideoPermissionStatus?.canUsePermission ?? false;

    return isLibraryImagePermissionGranted && isLibraryVideoPermissionGranted;
  }

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

  final FaceDetector faceDetector = FaceDetector(
    options: FaceDetectorOptions(enableContours: true, enableLandmarks: true),
  );

  late final StreamSubscription faceDetectionSubscription;
  AnalysisConfig? faceAnalysisConfig;

  @override
  void initState() {
    super.initState();

    if (widget.useFaceDetection) {
      faceAnalysisConfig = AnalysisConfig(
        androidOptions: const AndroidAnalysisOptions.nv21(width: 500),
        maxFramesPerSecond: 5.0,
        autoStart: widget.useFaceDetection,
      );
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => attemptPreloadCameraPermissions());
  }

  Future<void> attemptPreloadCameraPermissions() async {
    await checkCameraPermission(request: true);

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
  }

  @override
  void onPause() {
    super.onPause();
    stopClipRecording();
  }

  @override
  void onResume() {
    super.onResume();

    if (!hasCameraPermission) {
      WidgetsBinding.instance.addPostFrameCallback((_) => attemptPreloadCameraPermissions());
    }
  }

  @override
  void deactivate() {
    if (!clipRecordingState.isInactive) {
      stopClipRecording();
      clipRecordingState = ClipRecordingState.notRecording;
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

  Future<void> checkLibraryPermission({bool request = true}) async {
    final BaseDeviceInfo deviceInfo = await ref.read(deviceInfoProvider.future);

    try {
      if (deviceInfo is AndroidDeviceInfo) {
        final int sdkInt = deviceInfo.version.sdkInt;
        PermissionStatus? newStatus;
        if (sdkInt <= 32 && request) {
          newStatus = await Permission.storage.request();
        } else if (sdkInt <= 32 && !request) {
          newStatus = await Permission.storage.status;
        }

        if (newStatus != null) {
          libraryImagePermissionStatus = newStatus;
          libraryVideoPermissionStatus = newStatus;
          return;
        }
      }

      // On iOS, there is no video permission, so we use the photo permission
      if (deviceInfo is IosDeviceInfo) {
        PermissionStatus? newStatus;
        if (request) {
          newStatus = await Permission.photos.request();
        } else {
          newStatus = await Permission.photos.status;
        }

        libraryImagePermissionStatus = newStatus;
        libraryVideoPermissionStatus = newStatus;
        return;
      }

      // On new Android devices, we have to request both permissions
      if (request) {
        libraryImagePermissionStatus = await Permission.photos.request();
        libraryVideoPermissionStatus = await Permission.videos.request();
      } else {
        libraryImagePermissionStatus = await Permission.photos.status;
        libraryVideoPermissionStatus = await Permission.videos.status;
      }
    } catch (e) {
      libraryImagePermissionStatus = PermissionStatus.denied;
      libraryVideoPermissionStatus = PermissionStatus.denied;
    } finally {
      setStateIfMounted();
    }
  }

  Future<void> onInternalAddImageTap(BuildContext context) async {
    await checkLibraryPermission(request: true);
    if (!hasLibraryPermission) {
      final PositiveSnackBar errorSnackBar = PositiveErrorSnackBar(text: 'Please enable access to your photo library.');
      ScaffoldMessenger.of(context).showSnackBar(errorSnackBar);
      return;
    }

    widget.onTapAddImage?.call(context);
    setStateIfMounted();
  }

  Future<void> onAnalyzeImage(AnalysisImage image) async {
    if (!mounted || !widget.useFaceDetection) {
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
    if (!mounted) {
      return;
    }

    //? do not allow the user to begin recording when recording has already begun
    if (clipRecordingState.isRecording) {
      return;
    }

    //? clear old timer if duplicated
    if (delayTimer != null) {
      delayTimer!.cancel();
    }

    //? If a maximum delay has been set then begin the delay timer
    if (widget.isDelayTimerEnabled) {
      setStateIfMounted(
        callback: () {
          currentDelay = widget.maxDelay;
          clipRecordingState = ClipRecordingState.preRecording;
        },
      );

      widget.onClipStateChange?.call(clipRecordingState);

      delayTimer = Timer.periodic(
        const Duration(seconds: 1),
        (timer) async {
          if (currentDelay <= 0) {
            timer.cancel();
            currentDelay = -1;
            await onVideoRecordingStart(cameraState);
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
    await onVideoRecordingStart(cameraState);
  }

  Future<void> onVideoRecordingStart(CameraState cameraState) async {
    if (!mounted) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    late final CameraState newCameraState;

    try {
      cameraState.setState(CaptureMode.video);
      newCameraState = await cameraState.cameraContext.stateController.stream.firstWhere((element) => element is VideoCameraState || element is VideoRecordingCameraState);
    } catch (ex) {
      logger.w("Failed to get camera state, maybe unmounted? $ex");
      rethrow;
    }

    if (newCameraState is! VideoCameraState && newCameraState is! VideoRecordingCameraState) {
      logger.e("Error starting video recording: Camera state is not a video camera state");
      throw ("Error starting video recording: Camera state is not a video camera state");
    }

    //? Begin clip recording
    try {
      if (newCameraState is VideoCameraState) {
        videoCaptureRequest = await newCameraState.startRecording();
      }

      if (newCameraState is VideoRecordingCameraState) {
        final MediaCapture? captureRequest = newCameraState.cameraContext.mediaCaptureController.value;
        if (captureRequest == null) {
          logger.e("Error starting video recording: No capture request was available");
          throw ("Error starting video recording: No capture request was available");
        }

        await newCameraState.resumeRecording(captureRequest);
      }

      clipRecordingState = ClipRecordingState.recording;
      widget.onClipStateChange?.call(clipRecordingState);
      clipCurrentTime = widget.maxRecordingLength ?? 1;
      startRecordingTimer();
    } catch (e) {
      logger.e("Error starting video recording: $e");
      rethrow;
    }

    setStateIfMounted();
  }

  void startRecordingTimer() {
    if (!mounted) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    final bool isRecording = clipRecordingState.isRecording;
    if (!isRecording) {
      logger.w("Attempted to start clip recording timer when not recording");
      return;
    }

    clipTimer = Timer.periodic(
      const Duration(milliseconds: 100),
      (timer) async {
        if (!mounted) {
          return;
        }

        if (clipCurrentTime <= 0) {
          await stopClipRecording();
          await attemptProcessVideoResult();
        } else {
          clipCurrentTime = clipCurrentTime - 100;
        }
      },
    );
  }

  Future<void> attemptProcessVideoResult() async {
    if (!mounted) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    if (videoCaptureRequest == null) {
      logger.e("Attempted to stop clip recording when no capture was available");
      return;
    }

    final XFile? file = await videoCaptureRequest?.when(
      single: (single) => single.file,
    );

    final int length = await file?.length() ?? 0;
    if (length <= 0) {
      logger.w("Attempted to stop clip recording when no file was available");
      return;
    }

    //? we do not need to call the stateChange callback here as it is implicitly called by the callback below
    clipRecordingState = ClipRecordingState.finishedRecording;
    widget.onClipStateChange?.call(clipRecordingState);
    await widget.onCameraVideoTaken?.call(file!);
  }

  ///? Attempt to stop the clip recording, does not capture the resulting video
  Future<void> stopClipRecording() async {
    if (!mounted) {
      return;
    }

    final Logger logger = ref.read(loggerProvider);
    if (cachedCameraState == null) {
      logger.w("Attempted to stop clip recording when no camera state was cached");
      return;
    }

    try {
      final bool isRecording = clipRecordingState.isRecording;
      if (isRecording) {
        final VideoRecordingCameraState videoRecordingCameraState = VideoRecordingCameraState.from(cachedCameraState!.cameraContext);
        await videoRecordingCameraState.stopRecording();
      }

      clipCurrentTime = -1;
      currentDelay = -1;

      delayTimer?.cancel();
      delayTimer = null;

      clipTimer?.cancel();
      clipTimer = null;

      clipRecordingState = ClipRecordingState.finishedRecording;
      widget.onClipStateChange?.call(clipRecordingState);
    } catch (e) {
      logger.e("Error stopping video recording: $e");
    }
  }

  ///? if forcePause is given as true always try to pause the clip.
  ///
  ///? if forcePause is given as false always try to resume the clip.
  ///
  ///? if forcePause is not given function will attempt to toggle the clip to its other state.
  Future<void> onPauseResumeClip({bool? forcePause, VideoRecordingCameraState? freshCameraState}) async {
    if (!mounted) {
      return;
    }

    //? Only use cached version if needed
    late final VideoRecordingCameraState videoRecordingCameraState;
    if (freshCameraState != null) {
      videoRecordingCameraState = freshCameraState;
    } else {
      videoRecordingCameraState = VideoRecordingCameraState.from(cachedCameraState!.cameraContext);
    }

    MediaCapture? currentCapture;
    try {
      currentCapture = videoRecordingCameraState.cameraContext.mediaCaptureController.value;
    } catch (e) {
      final Logger logger = ref.read(loggerProvider);
      logger.e("Error pausing or resuming video recording: $e");
    }

    if (currentCapture == null) {
      return;
    }

    bool pause = true;

    if (forcePause == null) {
      if (videoRecordingCameraState.captureState!.videoState == VideoState.paused) {
        pause = false;
      } else {
        pause = true;
      }
    } else {
      pause = forcePause;
    }

    if (!pause) {
      // await videoRecordingCameraState.resumeRecording(currentCapture);
      // startRecordingTimer();
      // setStateIfMounted(callback: () {
      //   clipRecordingState = ClipRecordingState.recording;
      //   widget.onClipStateChange?.call(clipRecordingState);
      // });
      // return;
    }

    if (pause) {
      if (clipRecordingState.isRecording) {
        await videoRecordingCameraState.stopRecording();
      }
      clipTimer?.cancel();
      clipRecordingState = ClipRecordingState.paused;
      widget.onClipStateChange?.call(clipRecordingState);
      setStateIfMounted();
    }
  }

  void onClipResetState() {
    clipRecordingState = ClipRecordingState.notRecording;
    widget.onClipStateChange?.call(clipRecordingState);
  }

  Future<void> onImageTaken(PhotoCameraState cameraState) async {
    if (!mounted) {
      return;
    }

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
      // topActionsBuilder: (state) => topOverlay(state),
      topActionsBuilder: (_) => const SizedBox.shrink(),
      middleContentBuilder: (state) => cameraOverlay(state),
      bottomActionsBuilder: (state) => widget.cameraNavigation?.call(state) ?? const SizedBox.shrink(),
      previewDecoratorBuilder: buildPreviewDecoratorWidgets,
      filter: AwesomeFilter.None,
      previewFit: CameraPreviewFit.contain,
      theme: AwesomeTheme(bottomActionsBackgroundColor: colours.transparent),
      onImageForAnalysis: widget.useFaceDetection ? onAnalyzeImage : null,
      imageAnalysisConfig: faceAnalysisConfig,
      progressIndicator: PositiveLoadingIndicator(color: colours.white),
    );

    //? Application bar that can be displayed before the camera widget has loaded, or if the camera widget cannot display
    final Widget tempAppBar = Positioned(
      top: kPaddingNone,
      left: kPaddingNone,
      right: kPaddingNone,
      child: AppBar(
        backgroundColor: colours.black,
        elevation: 0.0,
        shadowColor: colours.black,
        leadingWidth: kPaddingInformationBreak,
        leading: viewMode != PositiveCameraViewMode.none
            ? Container(
                // The Flutter AppBar has a default padding of 16.0, so we need to offset this
                padding: const EdgeInsets.only(left: kPaddingMedium, top: 4.0, right: 1.0),
                alignment: Alignment.centerLeft,
                child: CameraFloatingButton.close(
                  active: true,
                  onTap: widget.onTapClose ?? (context) => appRouter.removeLast(),
                ),
              )
            : const SizedBox.shrink(),
        actions: <Widget>[
          if (viewMode != PositiveCameraViewMode.camera && widget.textPostActionWidget != null) ...<Widget>[
            Container(
              padding: const EdgeInsets.only(right: kPaddingMedium),
              alignment: Alignment.centerRight,
              child: widget.textPostActionWidget!,
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
        break;
      case PositiveCameraViewMode.camera:
        children.add(camera);
        if (!hasStartedCamera) {
          children.add(tempAppBar);
        }
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
      default:
        children.add(const SizedBox.shrink());
    }

    if (viewMode != PositiveCameraViewMode.camera && hasStartedCamera) {
      children.add(tempAppBar);
    }

    return Container(
      color: colours.black,
      child: Stack(children: children),
    );
  }

  List<Widget> getPositiveCameraGenericTopChildren(CameraState state) {
    if (clipRecordingState.isRecordingOrPaused) {
      return [
        if (widget.onTapClose != null) CameraFloatingButton(active: true, onTap: widget.onTapClose!, iconData: UniconsLine.angle_left),
        const Spacer(),
        if (widget.onTapForceClose != null) CameraFloatingButton.close(active: true, onTap: widget.onTapForceClose!),
      ];
    }

    return [
      if (widget.onTapClose != null) CameraFloatingButton.close(active: true, onTap: widget.onTapClose!),
      const Spacer(),
      if (widget.enableFlashControls && hasCameraPermission && !widget.isVideoMode)
        CameraFloatingButton.flash(
          active: true,
          flashMode: flashMode,
          onTap: onFlashToggleRequest,
        ),
      const SizedBox(width: kPaddingSmall),
      if (!clipRecordingState.isFinishedRecording) widget.textPostActionWidget ?? const SizedBox(width: kIconLarge),
    ];
  }

  Widget buildPreviewDecoratorWidgets(CameraState state, PreviewSize previewSize, Rect previewRect) {
    final List<Widget> children = <Widget>[];
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));

    // Add a shade to the top and bottom of the screen, leaving a square in the middle
    final Size screenSize = MediaQuery.of(context).size;

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

    //? capture the camera state for future use
    cachedCameraState ??= state;

    if (!hasStartedCamera) {
      hasStartedCamera = true;
      widget.onCameraStarted?.call();
      WidgetsBinding.instance.addPostFrameCallback((_) async {
        setStateIfMounted();
      });
    }

    return Padding(
      padding: EdgeInsets.only(bottom: mediaQuery.padding.bottom),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              right: kPaddingMedium,
              left: kPaddingMedium,
              top: kPaddingSmall,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: getPositiveCameraGenericTopChildren(state),
            ),
          ),
          const SizedBox(height: kPaddingMedium),
          if (clipRecordingState.isRecordingOrPaused)
            Align(
              alignment: Alignment.centerRight,
              child: Padding(
                padding: const EdgeInsets.only(right: kPaddingMedium),
                child: SizedBox(
                  width: kPaddingMedium,
                  height: kPaddingMedium,
                  child: Align(
                    child: AnimatedContainer(
                      duration: kAnimationDurationFast,
                      width: clipRecordingState.isRecording ? kPaddingMedium : kPaddingNone,
                      height: clipRecordingState.isRecording ? kPaddingMedium : kPaddingNone,
                      decoration: BoxDecoration(
                        color: colours.red,
                        borderRadius: BorderRadius.circular(kBorderRadiusInfinite),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          if (widget.topAdditionalActions != null && widget.isVideoMode && clipRecordingState.isInactive) ...widget.topAdditionalActions!,
          const Spacer(),
          //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
          //* -=-=-=-=- Caption above camera button, used during onboarding  -=-=-=-=- *\\
          //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
          if (widget.takePictureCaption != null)
            Text(
              widget.takePictureCaption ?? "",
              textAlign: TextAlign.center,
              style: typography.styleTitle.copyWith(color: colours.white),
              overflow: TextOverflow.clip,
            ),
          const SizedBox(height: kPaddingMedium),
          //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
          //* -=-=-=-=-=-             Delay Timer Selection UI             -=-=-=-=-=- *\\
          //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
          if (widget.delayTimerSelection >= 0 && widget.isVideoMode && widget.isDelayTimerEnabled && clipRecordingState.isInactive)
            SizedBox(
              width: kClipsDelayTimerWidth,
              child: PositiveSlimTabBar(
                tabs: widget.delayTimerOptions,
                onTapped: (index) => widget.onDelayTimerChanged(index),
                tabColours: [colours.black, colours.black],
                unselectedColour: colours.white,
                index: widget.delayTimerSelection,
              ),
            ),
          //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
          //* -=-=-=-=-=-             Maximum Clip Duration UI             -=-=-=-=-=- *\\
          //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
          if (widget.recordingLengthSelection >= 0 && widget.isVideoMode && widget.isRecordingLengthEnabled && clipRecordingState.isInactive)
            SizedBox(
              height: kPaddingMedium,
              child: WheelChooser.custom(
                onValueChanged: (i) => widget.onRecordingLengthChanged(i),
                horizontal: true,
                perspective: 0.005,

                startPosition: widget.recordingLengthSelection,
                //? width of the buttons + spacing on either side
                itemSize: kPaddingLargeish + kPaddingVerySmall + kPaddingVerySmall,
                children: [
                  for (var i = 0; i < widget.recordingLengthOptions.length; i++) ...[
                    ScrollingSelector(
                      textValue: widget.recordingLengthOptions[i],
                      shouldHighlight: widget.recordingLengthSelection == i,
                    ),
                  ],
                ],
              ),
            ),
          const SizedBox(height: kPaddingSmallMedium),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-        Create Post without Image Attached        -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              (widget.onTapAddImage != null && clipRecordingState.isInactive) ? CameraFloatingButton.addImage(active: true, onTap: onInternalAddImageTap) : const SizedBox(width: kIconLarge, height: kIconLarge),

              const SizedBox(width: kPaddingSmall),
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-            Take Photo or Camera Button           -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              CameraButton(
                active: canTakePictureOrVideo,
                loadingColour: colours.yellow,
                isLoading: clipRecordingState.isRecordingOrPaused,
                maxCLipDuration: widget.maxRecordingLength,
                isSmallButton: clipRecordingState.isRecordingOrPrerecording,
                isPaused: clipRecordingState.isPaused,
                onTap: (context) => onActiveButtonSelected(context, state),
              ),

              const SizedBox(width: kPaddingSmall),
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-            Close Button to Pop Scope             -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              if (clipRecordingState.isActive)
                CameraFloatingButton.close(
                  active: clipRecordingState.isPaused,
                  onTap: (context) => context.popRoute(),
                  isDisplayed: clipRecordingState.isPaused,
                  iconColour: colours.black,
                  backgroundColour: colours.yellow,
                ),
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-            Change Camera Orientation             -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              if (clipRecordingState.isInactive)
                CameraFloatingButton.changeCamera(
                  active: canTakePictureOrVideo,
                  onTap: (context) => onChangeCameraRequest(context, state),
                ),
              if (clipRecordingState.isFinishedRecording) const SizedBox(width: kIconLarge),
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

  Future<void> onActiveButtonSelected(BuildContext context, CameraState state) async {
    final Logger logger = ref.read(loggerProvider);

    if (!widget.isVideoMode) {
      logger.d("Taking photo");
      state.setState(CaptureMode.photo);
      await onImageTaken(state as PhotoCameraState);
      return;
    }

    if (clipRecordingState.isRecording) {
      logger.d("Stopping video recording");
      await onPauseResumeClip();
      return;
    } else {
      if (clipRecordingState.isInactive) {
        logger.d("Starting video recording");
        await onVideoRecordingRequestStart(state);
      }
    }

    // state.when(
    //   onPhotoMode: ,
    //   onVideoMode: (recordingState) => onVideoRecordingRequestStart(recordingState),
    //   onVideoRecordingMode: (recordingState) => onPauseResumeClip(freshCameraState: recordingState),
    // );
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

enum ClipRecordingState {
  notRecording,
  preRecording,
  paused,
  recording,
  finishedRecording;

  ///Has the user begun the recording process. That is: prerecording, recording or paused the recording
  bool get isActive => (this == preRecording || this == recording || this == paused);

  ///Has the user begun the recording process but is not currently paused
  bool get isActiveUnpaused => (this == recording || this != paused);

  ///Has the recording begun but is paused
  bool get isRecordingOrPaused => (this == recording || this == paused);

  ///Has the user paused the current recording process or is not currently recording
  bool get isNotRecordingOrPaused => (this != recording || this == paused);

  /// Returns true if the user is currently not in the process of recording a clip
  /// Finished recording is treated as an active state, as the page is currently in the process of transitioning.
  bool get isInactive => (this == notRecording);

  ///Is the clip in the pre-recording countdown stage.
  bool get isPreRecording => (this == preRecording);

  ///Has the clip begun recording but is currently paused
  bool get isPaused => (this == paused);

  ///Is the clip recording now.
  bool get isRecording => (this == recording);

  ///Is the clip recording or in the pre-recording countdown stage.
  bool get isRecordingOrPrerecording => (this == recording) || (this == preRecording);

  /// Has recording finished
  bool get isFinishedRecording => (this == finishedRecording);
}
