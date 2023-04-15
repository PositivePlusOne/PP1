// Dart imports:

// Flutter imports:

// Dart imports:
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

// Package imports:
import 'package:cloud_functions/cloud_functions.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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

  void onSelectCamera() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    final ImagePicker picker = ImagePicker();
    final XFile? picture = await picker.pickImage(source: ImageSource.camera, preferredCameraDevice: CameraDevice.front);

    if (picture == null) return;

    Uint8List imageAsUint8List = await File(picture.path).readAsBytes();
    img.Image? decodedImage = img.decodeImage(imageAsUint8List);
    if (decodedImage == null) {
      logger.i("Failed to decode image");
      return;
    }

    List<int> encodedPng = img.encodePng(decodedImage);
    final String base64String = base64Encode(encodedPng);

    await firebaseFunctions.httpsCallable('profile-addProfileImages').call({
      'profileImages': [base64String],
    });
  }

  void onImagePicker() async {
    final Logger logger = ref.read(loggerProvider);
    final FirebaseFunctions firebaseFunctions = ref.read(firebaseFunctionsProvider);

    final ImagePicker picker = ImagePicker();
    final XFile? picture = await picker.pickImage(source: ImageSource.gallery);

    if (picture == null) return;

    Uint8List imageAsUint8List = await File(picture.path).readAsBytes();
    img.Image? decodedImage = img.decodeImage(imageAsUint8List);
    if (decodedImage == null) {
      logger.i("Failed to decode image");
      return;
    }

    List<int> encodedPng = img.encodePng(decodedImage);
    final String base64String = base64Encode(encodedPng);

    await firebaseFunctions.httpsCallable('profile-addProfileImages').call({
      'profileImages': [base64String],
    });
  }
}
