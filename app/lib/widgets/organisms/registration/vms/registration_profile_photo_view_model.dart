// Dart imports:

// Flutter imports:

// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:isolate';
import 'dart:typed_data';

// Flutter imports:
import 'package:flutter/widgets.dart';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../../gen/app_router.dart';
import '../../../../helpers/dialog_hint_helpers.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'registration_profile_photo_view_model.freezed.dart';
part 'registration_profile_photo_view_model.g.dart';

@freezed
class RegistrationProfilePhotoViewModelState with _$RegistrationProfilePhotoViewModelState {
  const factory RegistrationProfilePhotoViewModelState({
    @Default(false) bool isBusy,
  }) = _RegistrationProfilePhotoViewModelState;

  factory RegistrationProfilePhotoViewModelState.initialState() => const RegistrationProfilePhotoViewModelState();
}

@riverpod
class RegistrationProfilePhotoViewModel extends _$RegistrationProfilePhotoViewModel with LifecycleMixin {
  @override
  RegistrationProfilePhotoViewModelState build() {
    return RegistrationProfilePhotoViewModelState.initialState();
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
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    logger.d("onSelectCamera");
    state = state.copyWith(isBusy: true);

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? picture = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

      if (picture == null) {
        logger.d("onSelectCamera: picture is null");
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
        logger.d("onSelectCamera: base64String is empty");
        return;
      }

      await firebaseFunctions.httpsCallable('profile-updateProfileImage').call({
        'profileImage': base64String,
      });

      state = state.copyWith(isBusy: false);
      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onImagePicker() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    final ImagePicker picker = ImagePicker();
    state = state.copyWith(isBusy: true);
    logger.d("onImagePicker");

    final XFile? picture = await picker.pickImage(source: ImageSource.gallery);

    try {
      if (picture == null) {
        logger.d("onImagePicker: picture is null");
        return;
      }

      final String? base64String = await Isolate.run(() async {
        final Uint8List imageAsUint8List = await File(picture.path).readAsBytes();
        final img.Image? decodedImage = img.decodeImage(imageAsUint8List);
        if (decodedImage == null) {
          logger.i("Failed to decode image");
          return "";
        }

        final List<int> encodedJpg = img.encodeJpg(decodedImage);
        return base64Encode(encodedJpg);
      });

      if (base64String == null || base64String.isEmpty) {
        logger.d("onImagePicker: base64String is empty");
        return;
      }

      await firebaseFunctions.httpsCallable('profile-updateProfileImage').call({
        'profileImage': base64String,
      });

      state = state.copyWith(isBusy: false);
      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
