// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/widgets/organisms/profile/vms/profile_reference_image_view_model.dart';
import 'package:app/widgets/organisms/shared/positive_camera_dialog.dart';

@RoutePage()
class ProfileReferenceImageCameraPage extends ConsumerWidget {
  const ProfileReferenceImageCameraPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    final ProfileReferenceImageViewModel viewModel = ref.read(profileReferenceImageViewModelProvider.notifier);
    final ProfileReferenceImageViewModelState state = ref.watch(profileReferenceImageViewModelProvider);

    String caption = appLocalization.page_profile_image_selfie_pending;
    if (state.isBusy) {
      caption = appLocalization.shared_actions_uploading;
    } else if (state.faceDetectionModel != null) {
      caption = appLocalization.page_profile_image_selfie_ready;
    }

    return WillPopScope(
      onWillPop: () => onWillPopScope(context, state.isBusy),
      child: PositiveCameraDialog(
        useFaceDetection: true,
        displayCameraShade: false,
        onFaceDetected: (p0) => viewModel.onFaceDetected(p0),
        onCameraImageTaken: (p0) => viewModel.onReferenceImageTaken(p0),
        takePictureCaption: caption,
        isBusy: state.isBusy,
      ),
    );
  }

  Future<bool> onWillPopScope(BuildContext context, bool isBusy) async {
    if (isBusy) {
      return false;
    }

    return true;
  }
}
