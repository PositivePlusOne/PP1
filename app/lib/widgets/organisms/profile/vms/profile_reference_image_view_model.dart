// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler_platform_interface/permission_handler_platform_interface.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import '../../../../dtos/ml/face_detector_model.dart';
import '../../../../helpers/dialog_hint_helpers.dart';
import '../../../../hooks/lifecycle_hook.dart';

// Project imports:
part 'profile_reference_image_view_model.freezed.dart';
part 'profile_reference_image_view_model.g.dart';

@freezed
class ProfileReferenceImageViewModelState with _$ProfileReferenceImageViewModelState {
  const factory ProfileReferenceImageViewModelState({
    @Default(false) bool isBusy,
    FaceDetectionModel? currentFaceModel,
  }) = _ProfileReferenceImageViewModelState;

  factory ProfileReferenceImageViewModelState.initialState() => const ProfileReferenceImageViewModelState();
}

@riverpod
class ProfileReferenceImageViewModel extends _$ProfileReferenceImageViewModel with LifecycleMixin {
  @override
  ProfileReferenceImageViewModelState build() {
    return ProfileReferenceImageViewModelState.initialState();
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
    }

    logger.i("Camera permissions granted, attempting to get image");
    await appRouter.push(const ProfileReferenceImageRoute());
  }

  void onBackSelected() async {
    final AppRouter appRouter = ref.watch(appRouterProvider);
    appRouter.pop();
  }

  Future<void> onImageTaken(String path) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    logger.i("Image taken, saving reference image");
    state = state.copyWith(isBusy: true);

    try {
      await profileController.updateReferenceImage(path);
      logger.i("Reference image saved, navigating to profile");

      appRouter.removeWhere((route) => true);
      appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
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

    state = state.copyWith(
      isBusy: false,
      currentFaceModel: null,
    );
  }

  void onFaceDetected(FaceDetectionModel? model) {
    final Logger logger = ref.read(loggerProvider);
    logger.i("Face detected: $model");

    state = state.copyWith(currentFaceModel: model);
  }
}
