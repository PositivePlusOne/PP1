// Dart imports:

// Flutter imports:

// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

// Flutter imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/profiles/profile_controller.dart';
import '../../../../gen/app_router.dart';
import '../../../../helpers/dialog_hint_helpers.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'profile_photo_view_model.freezed.dart';
part 'profile_photo_view_model.g.dart';

@freezed
class ProfilePhotoViewModelState with _$ProfilePhotoViewModelState {
  const factory ProfilePhotoViewModelState({
    @Default(false) bool isBusy,
  }) = _ProfilePhotoViewModelState;

  factory ProfilePhotoViewModelState.initialState() => const ProfilePhotoViewModelState();
}

@riverpod
class ProfilePhotoViewModel extends _$ProfilePhotoViewModel with LifecycleMixin {
  @override
  ProfilePhotoViewModelState build() {
    return ProfilePhotoViewModelState.initialState();
  }

  void onCancelSelectCamera() {
    final AppRouter appRouter = ref.read(appRouterProvider);
    appRouter.pop();
  }

  void moreInformation(BuildContext context) {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final HintDialogRoute route = buildProfilePhotoHint(context);
    appRouter.push(route);
  }

  void onSelectCamera() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    logger.d("onSelectCamera");
    appRouter.push(const ProfileCameraRoute());
  }

  void onTakeSelfie(String filePath) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    logger.d("taking image");
    appRouter.pop();
    state = state.copyWith(isBusy: true);

    try {
      final File picture = File(filePath);

      final String base64String = await Isolate.run(() async {
        final Uint8List imageAsUint8List = await picture.readAsBytes();
        final img.Image? decodedImage = img.decodeImage(imageAsUint8List);
        if (decodedImage == null) {
          logger.i("Failed to decode image");
          return "";
        }

        final List<int> encodedJpg = img.encodeJpg(decodedImage);
        return base64Encode(encodedJpg);
      });

      if (base64String.isEmpty) {
        logger.d("onSelectCamera: base64String is empty");
        return;
      }

      await profileController.updateProfileImage(base64String);
      await profileController.updateUserProfile();

      state = state.copyWith(isBusy: false);
      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onImagePicker() async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ImagePicker picker = ImagePicker();

    appRouter.pop();
    state = state.copyWith(isBusy: true);
    logger.d("onImagePicker");

    final XFile? picture = await picker.pickImage(source: ImageSource.gallery);

    try {
      if (picture == null) {
        logger.d("onImagePicker: picture is null");
        return;
      }

      final String base64String = await Isolate.run(() async {
        final Uint8List imageAsUint8List = await File(picture.path).readAsBytes();
        final img.Image? decodedImage = img.decodeImage(imageAsUint8List);
        if (decodedImage == null) {
          logger.i("Failed to decode image");
          return "";
        }

        final List<int> encodedJpg = img.encodeJpg(decodedImage);
        return base64Encode(encodedJpg);
      });

      if (base64String.isEmpty) {
        logger.d("onImagePicker: base64String is empty");
        return;
      }

      await profileController.updateProfileImage(base64String);
      await profileController.updateUserProfile();

      state = state.copyWith(isBusy: false);
      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
