// Dart imports:
import 'dart:async';

// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/ml/face_detector_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/organisms/profile/profile_reference_image_camera_page.dart';
import '../../../../helpers/dialog_hint_helpers.dart';

// Project imports:
part 'profile_reference_image_view_model.freezed.dart';
part 'profile_reference_image_view_model.g.dart';

@freezed
class ProfileReferenceImageViewModelState with _$ProfileReferenceImageViewModelState {
  const factory ProfileReferenceImageViewModelState({
    @Default(false) bool isBusy,
    FaceDetectionModel? faceDetectionModel,
  }) = _ProfileReferenceImageViewModelState;

  factory ProfileReferenceImageViewModelState.initialState() => const ProfileReferenceImageViewModelState();
}

@riverpod
class ProfileReferenceImageViewModel extends _$ProfileReferenceImageViewModel {
  bool get canSubmitPhoto => state.faceDetectionModel != null && state.faceDetectionModel!.faces.isNotEmpty && state.faceDetectionModel!.isFacingCamera && state.faceDetectionModel!.isInsideBoundingBox;

  @override
  ProfileReferenceImageViewModelState build() {
    return ProfileReferenceImageViewModelState.initialState();
  }

  Future<void> resetState() async {
    final Logger logger = ref.read(loggerProvider);
    logger.i("Resetting state");

    state = state.copyWith(
      isBusy: false,
      faceDetectionModel: null,
    );
  }

  Future<void> onHelpPressed(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final HintDialogRoute route = buildReferencePhotoHint(context);
    await appRouter.push(route);
  }

  Future<void> onRequestCamera(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d("Requesting camera");
    appRouter.push(const ProfileReferenceImageCameraRoute());
  }

  Future<void> onReferenceImageTaken(XFile result) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    state = state.copyWith(isBusy: true);

    try {
      await profileController.updateReferenceImage(result);
      logger.i("Reference image saved, navigating to profile");

      appRouter.removeWhere((route) => true);
      appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
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

  void onFaceDetected(FaceDetectionModel? model) {
    state = state.copyWith(faceDetectionModel: model);
  }
}
