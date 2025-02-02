// Flutter imports:
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/organisms/post/component/positive_clip_External_shader.dart';
import 'package:app/widgets/organisms/shared/positive_camera.dart';
import 'package:app/widgets/organisms/shared/positive_camera_dialog.dart';
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

@Riverpod(keepAlive: true)
class ProfilePhotoViewModel extends _$ProfilePhotoViewModel with LifecycleMixin {
  @override
  ProfilePhotoViewModelState build() {
    return ProfilePhotoViewModelState.initialState();
  }

  Future<bool> onWillPopScope() async {
    if (state.isBusy) {
      return false;
    }
    return true;
  }

  void onCancelSelectCamera() {
    final AppRouter appRouter = ref.read(appRouterProvider);
    appRouter.pop();
  }

  Future<void> onSelectCamera(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final Size screenSize = MediaQuery.of(context).size;
    final double topPaddingCameraShader = (screenSize.height - screenSize.width) / 2;

    logger.d("onSelectCamera");
    await appRouter.pop();

    try {
      state = state.copyWith(isBusy: true);

      final XFile result = await showCupertinoDialog(
        context: context,
        builder: (_) {
          return Stack(
            children: [
              const Positioned.fill(
                child: PositiveCameraDialog(
                  displayCameraShade: false,
                ),
              ),
              Positioned.fill(
                child: PositiveClipExternalShader(
                  paddingLeft: kPaddingNone,
                  paddingRight: kPaddingNone,
                  paddingTop: topPaddingCameraShader,
                  paddingBottom: topPaddingCameraShader,
                  colour: colours.black.withOpacity(kOpacityBarrier),
                  radius: kBorderRadiusInfinite,
                ),
              ),
            ],
          );
        },
      );

      logger.d("onSelectCamera: result is $result");

      await profileController.updateProfileImage(result);
      state = state.copyWith(isBusy: false);

      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onImagePicker(BuildContext context) async {
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final ImagePicker picker = ref.read(imagePickerProvider);

    await appRouter.pop();

    final Permission libraryPermission = await PositiveCameraState.getValidCameraPermissions();
    PermissionStatus libraryPermissionStatus = await libraryPermission.status;

    // Check if can request permission
    if (libraryPermissionStatus.isDenied) {
      libraryPermissionStatus = await libraryPermission.request();
    }

    // Check if permission is granted
    if (libraryPermissionStatus.isDenied || libraryPermissionStatus.isPermanentlyDenied) {
      logger.d("onImagePicker: permission denied");
      final AppLocalizations localizations = AppLocalizations.of(context)!;
      ScaffoldMessenger.of(context).showSnackBar(PositiveErrorSnackBar(text: localizations.shared_errors_permissions));
      return;
    }

    logger.d("[ProfilePhotoViewModel] onImagePicker [start]");
    state = state.copyWith(isBusy: true);

    try {
      final XFile? picture = await picker.pickImage(source: ImageSource.gallery);
      if (picture == null) {
        logger.d("onImagePicker: picture is null");
        return;
      }

      await profileController.updateProfileImage(picture);
      state = state.copyWith(isBusy: false);

      appRouter.removeWhere((route) => true);
      await appRouter.push(const HomeRoute());
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
