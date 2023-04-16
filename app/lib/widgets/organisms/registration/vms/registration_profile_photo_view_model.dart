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
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    final ImagePicker picker = ImagePicker();
    final XFile? picture = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

    if (picture == null) return;

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

    if (base64String.isEmpty) return;

    await firebaseFunctions.httpsCallable('profile-updateProfileImage').call({
      'profileImage': base64String,
    });
  }

  void onImagePicker() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    final ImagePicker picker = ImagePicker();
    final XFile? picture = await picker.pickImage(source: ImageSource.gallery);

    if (picture == null) return;

    final String base64String = await Isolate.run(() async {
      final Uint8List imageAsUint8List = await File(picture.path).readAsBytes();
      final img.Image? decodedImage = img.decodeImage(imageAsUint8List);
      if (decodedImage == null) {
        logger.i("Failed to decode image");
        throw Exception("Failed to decode image");
      }

      final List<int> encodedJpg = img.encodeJpg(decodedImage);
      return base64Encode(encodedJpg);
    });

    await firebaseFunctions.httpsCallable('profile-updateProfileImage').call({
      'profileImage': base64String,
    });
  }
}
