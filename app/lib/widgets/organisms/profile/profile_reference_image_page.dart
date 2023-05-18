// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../atoms/camera/camera_floating_button.dart';
import '../../atoms/camera/face_tracker_painter.dart';
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
    if (viewModelState.cameraControllerInitialised) {
      caption = appLocalization.shared_actions_uploading;
    } else if (viewModelState.faceFound) {
      caption = appLocalization.page_profile_image_selfie_ready;
    }

    return Material(
      child: PositiveCamera(
        onCameraImageTaken: (path) {
          // viewModel.onTakeSelfie(path);
        },
        faceTrackerActive: true,
        topChildren: <Widget>[
          CameraFloatingButton.close(active: true, onTap: viewModel.onCancel),
        ],
        takePictureCaption: caption,
        takePictureActive: !viewModelState.isBusy,
      ),
    );
  }
}
