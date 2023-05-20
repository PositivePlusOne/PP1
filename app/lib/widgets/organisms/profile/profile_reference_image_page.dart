// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';
import '../../atoms/camera/camera_floating_button.dart';
import '../shared/positive_camera.dart';
import 'vms/profile_reference_image_view_model.dart';

@RoutePage()
class ProfileReferenceImagePage extends HookConsumerWidget {
  const ProfileReferenceImagePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileReferenceImageViewModel viewModel = ref.read(profileReferenceImageViewModelProvider.notifier);
    final ProfileReferenceImageViewModelState viewModelState = ref.watch(profileReferenceImageViewModelProvider);
    useLifecycleHook(viewModel);

    final AppLocalizations appLocalization = AppLocalizations.of(context)!;

    String caption = appLocalization.page_profile_image_selfie_pending;
    if (viewModelState.isBusy) {
      caption = appLocalization.shared_actions_uploading;
    } else if (viewModelState.currentFaceModel != null) {
      caption = appLocalization.page_profile_image_selfie_ready;
    }

    return Material(
      child: PositiveCamera(
        useFaceDetection: true,
        onCameraImageTaken: viewModel.onImageTaken,
        onFaceDetected: viewModel.onFaceDetected,
        topChildren: <Widget>[
          CameraFloatingButton.close(active: true, onTap: viewModel.onCancel),
        ],
        takePictureCaption: caption,
        isBusy: viewModelState.isBusy,
      ),
    );
  }
}
