// Dart imports:
import 'dart:async';
import 'dart:convert';
import 'dart:isolate';

// Flutter imports:
import 'package:app/widgets/organisms/shared/components/mlkit_utils.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:google_ml_kit/google_ml_kit.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:rxdart/rxdart.dart';
import 'package:universal_platform/universal_platform.dart';

// Project imports:
import 'package:app/extensions/future_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/profile/profile_reference_image_page.dart';
import '../../../../helpers/behaviour_subject.dart';
import '../../../../helpers/dialog_hint_helpers.dart';
import '../../../../helpers/image_helpers.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../shared/components/faceDetectionModel.dart';

// Project imports:
part 'profile_reference_image_view_model.freezed.dart';
part 'profile_reference_image_view_model.g.dart';

@freezed
class ProfileReferenceImageViewModelState with _$ProfileReferenceImageViewModelState {
  const factory ProfileReferenceImageViewModelState({
    @Default(false) bool isBusy,
    //? has a face been found
    @Default(false) bool faceFound,
    //? camera has been started and is available for interactions
    @Default(false) bool cameraControllerInitialised,
  }) = _ProfileReferenceImageViewModelState;

  factory ProfileReferenceImageViewModelState.initialState() => const ProfileReferenceImageViewModelState();
}

@riverpod
class ProfileReferenceImageViewModel extends _$ProfileReferenceImageViewModel with LifecycleMixin {
  //? InputImageRotation is the format required for Googles MLkit face detection plugin
  InputImageRotation cameraRotation = InputImageRotation.rotation270deg;

  Size cameraResolution = Size(100, 100);

  //? List of faces currently within the viewport
  List<Face> faces = List.empty(growable: true);

  //? FaceDertector from google MLKit
  final FaceDetectorOptions options = FaceDetectorOptions(
    enableContours: true,
    enableLandmarks: true,
  );
  late final faceDetector = FaceDetector(options: options);

  //? Time since face was last found (to prevent take picture failing due to face recognition software losing the face for a short period of time)
  DateTime? canResetFaceDetectorTimestamp;
  int milisecondsSinceFaceFound = 0;
  static int maximumMilisecondsSinceFaceFound = 1000;
  static int maximumMilisecondsSinceTakeImagePressed = 2000;

  bool get faceFoundRecently {
    return DateTime.now().millisecondsSinceEpoch - milisecondsSinceFaceFound <= maximumMilisecondsSinceFaceFound;
  }

  @override
  ProfileReferenceImageViewModelState build() {
    return ProfileReferenceImageViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    resetState().then((_) => startCamera());
    super.onFirstRender();
  }

  Future<void> onHelpPressed(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final HintDialogRoute route = buildReferencePhotoHint(context);
    await appRouter.push(route);
  }

  Future<void> onRequestCamera() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.i("Continue pressed, attempting to get camera permissions");
    final PermissionStatus permissionStatus = await ref.read(cameraPermissionsProvider.future);
    if (permissionStatus != PermissionStatus.granted && permissionStatus != PermissionStatus.limited) {
      logger.w("Camera permissions not granted: $permissionStatus");
      appRouter.push(ErrorRoute(errorMessage: "Please enable camera permissions in your phone settings and restart the app to use this feature."));
      // throw permissionStatus;
    }

    //TODO: is it possible to re-check permissions if the user changes this in settings
    //? Right now the app chaches the permissions somewhere and does not update, requiring a restart
    // TODO(ryan): add a check for the camera being in use and or exists

    logger.i("Camera permissions granted, attempting to get image");
    await appRouter.push(const ProfileReferenceImageRoute());
  }

  void onBackSelected() async {
    final AppRouter appRouter = ref.watch(appRouterProvider);
    appRouter.pop();
  }

  Future<void> onCompletion() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.i("Profile image completed, navigating to profile");
    appRouter.removeWhere((route) => true);
    appRouter.push(const HomeRoute());
  }

  void onCancel() {
    final AppRouter appRouter = ref.read(appRouterProvider);
    appRouter.removeLast();
    resetState();
  }

  Future<void> resetState() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i("Resetting state");

    await faceDetector.close();
    //TODO close function
    // await faceDetectionController.close();

    state = state.copyWith(
      isBusy: false,
      faceFound: false,
    );
  }

  Future<void> startCamera() async {}

  //*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*\\
  //*     reformat the image data into a usable form for the google MLkit face detection       *\\
  //*-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=*\\

  Future<void> preprocessImage(AnalysisImage image) async {
    final inputImage = image.toInputImage();

    cameraResolution = inputImage.inputImageData!.size;
    updateOrientation(image.rotation);

    await processImage(
      image.toInputImage(),
    );
    state = state.copyWith(isBusy: false);
  }

  Future<List<Face>> processImage(InputImage inputImage) async {
    final AppRouter appRouter = ref.read(appRouterProvider);

    final MediaQueryData mediaQuery = MediaQuery.of(appRouter.navigatorKey.currentState!.context);

    faces = await faceDetector.processImage(inputImage);

    final bool faceFound = checkFace(
      mediaQuery.size,
      faces,
    );

    // if (faceFound) {
    //   canResetFaceDetectorTimestamp = DateTime.now().add(const Duration(milliseconds: 150));
    //   milisecondsSinceFaceFound = DateTime.now().millisecondsSinceEpoch;
    // } else if (canResetFaceDetectorTimestamp != null && DateTime.now().isBefore(canResetFaceDetectorTimestamp!)) {}

    state = state.copyWith(faceFound: faceFound);
    return faces;
  }

  bool checkFace(Size size, List<Face> facesToCheck) {
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

  void updateOrientation(InputAnalysisImageRotation rotation) {
    // * check the deviceOrientation and update the cameraRotation variable
    // * (google MLkit requires the orientation of the image and the video stream from the camera plugin does not contain the relavent metadata)
    // * we get the image rotation from the phone orientation this needs testing on other devices
    // if (cameraController!.value.deviceOrientation != previousCameraRotation) {
    switch (rotation) {
      case InputAnalysisImageRotation.rotation0deg:
        cameraRotation = InputImageRotation.rotation0deg;
        break;
      case InputAnalysisImageRotation.rotation180deg:
        cameraRotation = InputImageRotation.rotation180deg;
        break;
      case InputAnalysisImageRotation.rotation90deg:
        cameraRotation = InputImageRotation.rotation90deg;
        break;
      case InputAnalysisImageRotation.rotation270deg:
        cameraRotation = InputImageRotation.rotation270deg;
        break;
      // }
      // previousCameraRotation = cameraController!.value.deviceOrientation;
    }
  }

  // Future<void> requestSelfie() async {
  //   final Logger logger = ref.read(loggerProvider);
  //   final ProfileController profileController = ref.read(profileControllerProvider.notifier);
  //   final AppRouter appRouter = ref.read(appRouterProvider);

  //   if (!faceFoundRecently) {
  //     logger.i('Face not found recently, requesting selfie');
  //     return;
  //   }

  //   logger.d('Requesting selfie');
  //   await runWithMutex(() async {
  //     state = state.copyWith(isBusy: true);

  //     try {
  //       // await cameraController?.pausePreview();
  //       final Uint8List data = await imageFromRepaintBoundary(ProfileReferenceImagePage.cameraGlobalKey);
  //       await uploadImageToFirebase(data);

  //       await profileController.updateUserProfile();

  //       appRouter.removeWhere((route) => true);
  //       appRouter.push(const ProfileReferenceImageSuccessRoute());
  //       resetState();
  //     } catch (e) {
  //       state = state.copyWith(isBusy: false);
  //       rethrow;
  //     }
  //   }, key: 'positive-actions-request-selfie');
  // }

  // Future<void> uploadImageToFirebase(Uint8List image) async {
  //   final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
  //   final Logger logger = ref.read(loggerProvider);

  //   try {
  //     final List<int> jpgImageStd = encodeCameraBytes(image);
  //     final String base64String = await Isolate.run(() async {
  //       return base64Encode(jpgImageStd);
  //     });

  //     await firebaseFunctions.httpsCallable('profile-updateReferenceImage').call({
  //       'referenceImage': base64String,
  //     });
  //   } catch (e) {
  //     logger.e("Error uploading image", e);

  //     // await cameraController?.resumePreview();
  //     state = state.copyWith(isBusy: false);
  //   }
  // }
}
