// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../gen/app_router.dart';
import 'components/face_tracker_button_painter.dart';
import 'vms/registration_profile_image_view_model.dart';
import 'vms/registration_profile_photo_view_model.dart';

class RegistrationProfilePhotoPage extends HookConsumerWidget {
  const RegistrationProfilePhotoPage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel designTypography = ref.read(designControllerProvider.select((value) => value.typography));

    final AppRouter appRouter = ref.read(appRouterProvider);
    final MediaQueryData mediaQuery = MediaQuery.of(appRouter.navigatorKey.currentState!.context);

    final RegistrationProfilePhotoViewModel viewModel = ref.read(registrationProfilePhotoViewModelProvider.notifier);
    final RegistrationProfilePhotoViewModelState viewModelState = ref.watch(registrationProfilePhotoViewModelProvider);

    useLifecycleHook(viewModel);

    return PositiveScaffold(
      hideBottomPadding: true,
      backgroundColor: colours.black,
      headingWidgets: <Widget>[
        SliverFillRemaining(
          child: Stack(
            children: [
              //* -=-=-=-=-=- Camera Widget -=-=-=-=-=-
              if (viewModel.cameraController != null)
                Positioned.fill(
                  child: Transform.scale(
                    scale: viewModel.scale,
                    child: Center(
                      child: CameraPreview(
                        viewModel.cameraController!,
                      ),
                    ),
                  ),
                ),
              //* -=-=-=-=-=- Take Picture Widget -=-=-=-=-=-
              if (viewModelState.cameraControllerInitialised && !viewModel.cameraController!.value.isPreviewPaused)
                FaceTrackerButtonPosition(
                  displayHintText: true,
                  mediaQuery: mediaQuery,
                  caption: "caption",
                  active: true,
                  onTap: viewModel.onTakePicture,
                ),
            ],
          ),
        ),
      ],
    );
  }
}
