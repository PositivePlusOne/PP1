// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:image/image.dart' as img;
import 'package:logger/logger.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/user/profile_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:universal_platform/universal_platform.dart';
import '../../../../helpers/image_helpers.dart';
import '../../../../hooks/lifecycle_hook.dart';

part 'profile_image_view_model.freezed.dart';
part 'profile_image_view_model.g.dart';

@freezed
class ProfileImageViewModelState with _$ProfileImageViewModelState {
  const factory ProfileImageViewModelState({
    @Default(false) bool isBusy,
    //? has a face been found
    @Default(false) bool faceFound,
    //? camera has been started and is available for interactions
    @Default(false) bool cameraControllerInitialised,
    //? The current error to be shown to the user
    Object? currentError,
  }) = _ProfileImageViewModelState;

  factory ProfileImageViewModelState.initialState() => const ProfileImageViewModelState();
}

@riverpod
class ProfileImageViewModel extends _$ProfileImageViewModel with LifecycleMixin {
  CameraController? cameraController;

  //? InputImageRotation is the format required for Googles MLkit face detection plugin
  InputImageRotation cameraRotation = InputImageRotation.rotation0deg;

  //? DeviceOrientation is the default format as given by the Camera package
  DeviceOrientation previousCameraRotation = DeviceOrientation.landscapeLeft;

  //? List of Cameras available
  final List<CameraDescription> cameras = List.empty(growable: true);
  int cameraID = 0;

  //? List of faces currently within the viewport
  final List<Face> faces = List.empty(growable: true);

  //? FaceDertector from google MLKit
  FaceDetector? faceDetector;
  DateTime? canResetFaceDetectorTimestamp;

  //? Variable denoting the users reqest to take picture
  bool requestTakeSelfie = false;

  bool cameraIsStreaming = false;

  //? Throttle the face update rate
  final int throttleEnd = 5;
  int throttle = 0;

  //? get viewport scale
  double get scale {
    final AppRouter appRouter = ref.read(appRouterProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(appRouter.navigatorKey.currentState!.context);

    double scale = 1;
    if (state.cameraControllerInitialised) {
      if (mediaQuery.orientation == Orientation.portrait || (mediaQuery.orientation == Orientation.landscape && UniversalPlatform.isIOS)) {
        scale = mediaQuery.size.aspectRatio * cameraController!.value.aspectRatio;
      } else {
        scale = 1 / mediaQuery.size.aspectRatio * cameraController!.value.aspectRatio;
      }
    }

    if (scale < 1) scale = 1 / scale;
    return scale;
  }

  @override
  ProfileImageViewModelState build() {
    return ProfileImageViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    resetState().then((_) => startCamera());
    super.onFirstRender();
  }

  Future<void> onHelpPressed() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    await appRouter.push(const ProfileImageDialogRoute());
  }

  Future<void> onRequestCamera() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    state = state.copyWith(currentError: null);

    logger.i("Continue pressed, attempting to get camera permissions");
    final PermissionStatus permissionStatus = await ref.read(cameraPermissionsProvider.future);
    if (permissionStatus != PermissionStatus.granted && permissionStatus != PermissionStatus.limited) {
      logger.w("Camera permissions not granted: $permissionStatus");
      state = state.copyWith(currentError: permissionStatus);
      return;
    }

    // TODO(ryan): add a check for the camera being in use and or exists

    logger.i("Camera permissions granted, attempting to get image");
    await appRouter.push(const ProfileImageRoute());
  }

  Future<void> onCompletion() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    state = state.copyWith(currentError: null);

    logger.i("Profile image completed, navigating to profile");
    appRouter.removeWhere((route) => true);
    appRouter.push(const HomeRoute());
  }

  Future<void> resetState() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i("Resetting state");

    await faceDetector?.close();
    faceDetector = null;

    await cameraController?.stopImageStream();
    cameraController = null;

    state = state.copyWith(
      isBusy: false,
      faceFound: false,
      cameraControllerInitialised: false,
      currentError: null,
    );
  }

  Future<void> startCamera() async {
    final Logger logger = ref.read(loggerProvider);
    if (state.cameraControllerInitialised) {
      logger.w("Cannot run startCamera, camera controller is already initialised");
      return;
    }

    cameras.clear();
    cameras.addAll(await availableCameras());
    if (!cameras.any((element) => element.lensDirection == CameraLensDirection.front)) {
      logger.w("No camera found");
      return;
    }

    final CameraDescription selectedCamera = cameras.firstWhere((element) => element.lensDirection == CameraLensDirection.front);
    cameraID = cameras.indexOf(selectedCamera);

    final FaceDetectorOptions options = FaceDetectorOptions();
    faceDetector = FaceDetector(options: options);

    cameraController = CameraController(
      cameras[cameraID],
      ResolutionPreset.max,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await cameraController?.initialize().then(
      (_) async {
        state = state.copyWith(cameraControllerInitialised: true);
        startCameraStream();
      },
    );
  }

  //*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*\\
  //*     reformat the image data into a usable form for the google MLkit face detection       *\\
  //*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*\\
  Future<void> preprocessImage(CameraImage image) async {
    if (throttle < throttleEnd) {
      throttle++;
      return;
    }
    throttle = 0;

    if (state.isBusy) return;

    state = state.copyWith(isBusy: true);

    updateOrientation();

    final WriteBuffer allBytes = WriteBuffer();

    for (final Plane plane in image.planes) {
      allBytes.putUint8List(plane.bytes);
    }
    final bytes = allBytes.done().buffer.asUint8List();

    final Size imageSize = Size(image.width.toDouble(), image.height.toDouble());

    final camera = cameras[cameraID];
    final imageRotation = InputImageRotationValue.fromRawValue(camera.sensorOrientation);

    if (imageRotation == null) return;

    final InputImageFormat? inputImageFormat = InputImageFormatValue.fromRawValue(image.format.raw);
    if (inputImageFormat == null) return;

    final planeData = image.planes.map(
      (Plane plane) {
        return InputImagePlaneMetadata(
          bytesPerRow: plane.bytesPerRow,
          height: plane.height,
          width: plane.width,
        );
      },
    ).toList();

    final inputImageData = InputImageData(
      size: imageSize,
      imageRotation: cameraRotation,
      inputImageFormat: inputImageFormat,
      planeData: planeData,
    );

    final inputImage = InputImage.fromBytes(bytes: bytes, inputImageData: inputImageData);
    await processImage(inputImage);

    state = state.copyWith(isBusy: false);

    if (requestTakeSelfie) {
      requestTakeSelfie = false;
      uploadImageToFirebase(image);
    }
  }

  Future<void> processImage(InputImage inputImage) async {
    final AppRouter appRouter = ref.read(appRouterProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(appRouter.navigatorKey.currentState!.context);

    final List<Face> newFaces = await faceDetector!.processImage(inputImage);
    faces.clear();
    faces.addAll(newFaces);

    final bool faceFound = checkFace(
      mediaQuery.size,
      faces,
    );

    if (faceFound) {
      canResetFaceDetectorTimestamp = DateTime.now().add(const Duration(milliseconds: 150));
    } else if (canResetFaceDetectorTimestamp != null && DateTime.now().isBefore(canResetFaceDetectorTimestamp!)) {
      return;
    }

    state = state.copyWith(faceFound: faceFound);
  }

  bool checkFace(Size size, List<Face> facesToCheck) {
    final Size cameraResolution = Size(
      cameraController!.value.previewSize!.width,
      cameraController!.value.previewSize!.height,
    );

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
      final double faceLeft = rotateResizeImageX(faceBoundingBox.right, cameraRotation, size, cameraResolution);
      final double faceRight = rotateResizeImageX(faceBoundingBox.left, cameraRotation, size, cameraResolution);
      final double faceTop = rotateResizeImageY(faceBoundingBox.top, cameraRotation, size, cameraResolution);
      final double faceBottom = rotateResizeImageY(faceBoundingBox.bottom, cameraRotation, size, cameraResolution);

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

  void updateOrientation() {
    //* check the deviceOrientation and update the cameraRotation variable
    //* (google MLkit requires the orientation of the image and the video stream from the camera plugin does not contain the relavent metadata)
    //* we get the image rotation from the phone orientation this needs testing on other devices
    if (cameraController!.value.deviceOrientation != previousCameraRotation) {
      switch (cameraController!.value.deviceOrientation) {
        case DeviceOrientation.landscapeLeft:
          cameraRotation = InputImageRotation.rotation0deg;
          break;
        case DeviceOrientation.landscapeRight:
          cameraRotation = InputImageRotation.rotation180deg;
          break;
        case DeviceOrientation.portraitDown:
          cameraRotation = InputImageRotation.rotation90deg;
          break;
        case DeviceOrientation.portraitUp:
          cameraRotation = InputImageRotation.rotation270deg;
          break;
      }
      previousCameraRotation = cameraController!.value.deviceOrientation;
    }
  }

  Future<void> stopCameraStream() async {
    if (cameraIsStreaming == false) {
      return;
    }
    cameraIsStreaming = false;
    await cameraController!.stopImageStream();
  }

  Future<void> startCameraStream() async {
    if (cameraIsStreaming == true) {
      return;
    }
    cameraIsStreaming = true;
    await cameraController!.startImageStream(preprocessImage);
  }

  Future<void> requestSelfie() async {
    if (state.isBusy) {
      return;
    }

    requestTakeSelfie = true;
  }

  Future<void> uploadImageToFirebase(CameraImage image) async {
    if (state.isBusy) {
      return;
    }

    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    try {
      await cameraController?.pausePreview();

      state = state.copyWith(isBusy: true);

      final img.Image unencodedImage = _convertYUV420(image);

      final String base64String = await Isolate.run(() async {
        final List<int> pngImageStd = img.encodePng(unencodedImage);
        final Uint8List pngImage = Uint8List.fromList(pngImageStd);
        return base64Encode(pngImage);
      });

      await firebaseFunctions.httpsCallable('profile-updateReferenceImage').call({
        'referenceImage': base64String,
      });

      await profileController.loadProfile();
      state = state.copyWith(isBusy: false);

      appRouter.removeWhere((route) => true);
      appRouter.push(const ProfileImageSuccessRoute());
      resetState();
    } catch (e) {
      logger.e("Error uploading image", e);

      await cameraController?.resumePreview();
      state = state.copyWith(isBusy: false);
    }
  }

  // CameraImage YUV420_888 -> PNG -> Image (compresion:0, filter: none)
  // Black
  img.Image _convertYUV420(CameraImage image) {
    var imgage = img.Image(image.width, image.height); // Create Image buffer

    Plane plane = image.planes[0];
    const int shift = (0xFF << 24);

    // Fill image buffer with plane[0] from YUV420_888
    for (int x = 0; x < image.width; x++) {
      for (int planeOffset = 0; planeOffset < image.height * image.width; planeOffset += image.width) {
        final pixelColor = plane.bytes[planeOffset + x];
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        // Calculate pixel color
        var newVal = shift | (pixelColor << 16) | (pixelColor << 8) | pixelColor;

        imgage.data[planeOffset + x] = newVal;
      }
    }

    return imgage;
  }
}
