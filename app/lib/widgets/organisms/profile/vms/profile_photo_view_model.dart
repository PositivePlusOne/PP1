// Flutter imports:
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/widgets/organisms/shared/positive_camera_dialog.dart';
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

@Riverpod(keepAlive: true)
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

  Future<void> onSelectCamera(BuildContext context) async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    logger.d("onSelectCamera");
    await appRouter.pop();

    final XFile result = await showCupertinoDialog(
      context: context,
      builder: (_) => const PositiveCameraDialog(),
    );

    logger.d("onSelectCamera: result is $result");
    state = state.copyWith(isBusy: true);

    try {
      await profileController.updateProfileImage(result);
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
    final ImagePicker picker = ref.read(imagePickerProvider);

    await appRouter.pop();

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
