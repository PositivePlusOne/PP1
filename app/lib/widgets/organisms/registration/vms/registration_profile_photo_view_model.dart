// Dart imports:

// Flutter imports:

// Package imports:
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:universal_platform/universal_platform.dart';
import 'package:image/image.dart' as img;

// Project imports:
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'registration_profile_photo_view_model.freezed.dart';
part 'registration_profile_photo_view_model.g.dart';

@freezed
class RegistrationProfilePhotoViewModelState with _$RegistrationProfilePhotoViewModelState {
  const factory RegistrationProfilePhotoViewModelState({
    @Default(false) bool isBusy,
    //? camera has been started and is available for interactions
    @Default(false) bool cameraControllerInitialised,
  }) = _RegistrationProfilePhotoViewModelState;

  factory RegistrationProfilePhotoViewModelState.initialState() => const RegistrationProfilePhotoViewModelState();
}

@riverpod
class RegistrationProfilePhotoViewModel extends _$RegistrationProfilePhotoViewModel with LifecycleMixin {
  //? List of Cameras available
  final List<CameraDescription> cameras = List.empty(growable: true);
  int cameraID = 0;
  CameraController? cameraController;

  @override
  void onFirstRender() {
    resetState().then((_) => startCamera());
    super.onFirstRender();
  }

  Future<void> resetState() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i("Resetting state");

    if (cameraController != null && cameraController!.value.isStreamingImages) {
      state = state.copyWith(
        cameraControllerInitialised: false,
      );
      await cameraController?.stopImageStream();
      await cameraController?.dispose();
      cameraController = null;
    }

    state = state.copyWith(
      isBusy: false,
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

    cameraController = CameraController(
      cameras[cameraID],
      ResolutionPreset.veryHigh,
      enableAudio: false,
      imageFormatGroup: ImageFormatGroup.yuv420,
    );

    await cameraController?.initialize().then(
      (_) async {
        state = state.copyWith(cameraControllerInitialised: true);
      },
    );
  }

  Future<void> onRequestCamera() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.i("Continue pressed, attempting to get camera permissions");
    final PermissionStatus permissionStatus = await ref.read(cameraPermissionsProvider.future);
    if (permissionStatus != PermissionStatus.granted && permissionStatus != PermissionStatus.limited) {
      logger.w("Camera permissions not granted: $permissionStatus");
      throw permissionStatus;
    }

    logger.i("Camera permissions granted, attempting to get image");
    await appRouter.push(const RegistrationProfileImageRoute());
  }

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
  RegistrationProfilePhotoViewModelState build() {
    return RegistrationProfilePhotoViewModelState.initialState();
  }

  void onSelectCamera() {
    final AppRouter appRouter = ref.read(appRouterProvider);

    appRouter.removeLast();
    appRouter.push(const RegistrationProfilePhotoRoute());
  }

  void onCancelSelectCamera() {
    final AppRouter appRouter = ref.read(appRouterProvider);

    appRouter.pop();
  }

  void onImagePicker() {
    final ImagePicker picker = ImagePicker();
    final pic = picker.pickImage(source: ImageSource.camera);
  }

  void onTakePicture() async {
    final Logger logger = ref.read(loggerProvider);
    if (state.cameraControllerInitialised) {
      XFile picture = await cameraController!.takePicture();
      Uint8List imageAsUint8List = await File(picture.path).readAsBytes();
      img.Image? decodedImage = img.decodeImage(imageAsUint8List);
      if (decodedImage == null) {
        logger.i("Failed to decode image");
        return;
      }

      List<int> encodedPng = img.encodePng(decodedImage);
      final String base64String = base64Encode(encodedPng);
    }
  }
}
