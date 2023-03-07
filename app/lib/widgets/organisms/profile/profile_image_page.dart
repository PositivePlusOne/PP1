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
import 'package:app/widgets/organisms/profile/vms/profile_image_view_model.dart';
import '../../../gen/app_router.dart';
import 'components/face_tracker_button_painter.dart';
import 'components/face_tracker_painter.dart';

class ProfileImagePage extends HookConsumerWidget {
  const ProfileImagePage({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileImageViewModel viewModel = ref.read(profileImageViewModelProvider.notifier);
    final ProfileImageViewModelState viewModelState = ref.watch(profileImageViewModelProvider);
    useLifecycleHook(viewModel);

    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    final DesignColorsModel designColours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel designTypography = ref.read(designControllerProvider.select((value) => value.typography));

    final double scale = viewModel.scale;

    final AppRouter appRouter = ref.read(appRouterProvider);
    final MediaQueryData mediaQuery = MediaQuery.of(appRouter.navigatorKey.currentState!.context);

    String caption = appLocalization.page_profile_image_selfie_pending;
    if (viewModelState.cameraControllerInitialised && viewModel.cameraController!.value.isPreviewPaused) {
      caption = appLocalization.shared_actions_uploading;
    } else if (viewModelState.faceFound) {
      caption = appLocalization.page_profile_image_selfie_ready;
    }

    const double buttonWidth = 72.0;
    final double buttonPositionX = (mediaQuery.size.width / 2) - buttonWidth / 2;
    final double buttonPositionY = (mediaQuery.size.height * 0.85);
    final double textPositionY = buttonPositionY - 55.0;

    return PositiveScaffold(
      hideBottomPadding: true,
      headingWidgets: <Widget>[
        SliverFillRemaining(
          child: Stack(
            children: [
              if (viewModelState.cameraControllerInitialised) ...<Widget>[
                //* -=-=-=-=-=- Camera Widget -=-=-=-=-=-
                Positioned.fill(
                  child: Transform.scale(
                    scale: scale,
                    child: Center(
                      child: CameraPreview(
                        viewModel.cameraController!,
                      ),
                    ),
                  ),
                ),
                //* -=-=-=-=-=- Face Tracker Custom Painter Widget -=-=-=-=-=-
                Positioned.fill(
                  child: CustomPaint(
                    painter: FaceTrackerPainter(
                      faces: viewModel.faces,
                      cameraResolution: Size(
                        viewModel.cameraController!.value.previewSize!.width,
                        viewModel.cameraController!.value.previewSize!.height,
                      ),
                      scale: scale,
                      rotationAngle: viewModel.cameraRotation,
                      ref: ref,
                      faceFound: viewModelState.faceFound,
                    ),
                  ),
                ),
              ],

              //* -=-=-=-=-=- Cancel Button Widget -=-=-=-=-=-
              if (viewModelState.cameraControllerInitialised && !viewModel.cameraController!.value.isPreviewPaused)
                Positioned(
                  left: mediaQuery.size.width * 0.07,
                  top: mediaQuery.size.height * 0.13,
                  right: 0.0,
                  bottom: 0.0,
                  child: Align(
                    alignment: Alignment.topLeft,
                    child: TextButton(
                      style: ButtonStyle(
                        overlayColor: MaterialStateColor.resolveWith((states) => designColours.white.withOpacity(0.1)),
                      ),
                      onPressed: () => appRouter.removeLast(),
                      child: Text(
                        appLocalization.shared_actions_cancel,
                        textAlign: TextAlign.start,
                        style: designTypography.styleButtonBold.copyWith(color: designColours.white),
                      ),
                    ),
                  ),
                ),
              //* -=-=-=-=-=- Information Text Widget -=-=-=-=-=-
              Positioned(
                left: 0.0,
                right: 0.0,
                bottom: 0.0,
                top: textPositionY,
                child: Text(
                  caption,
                  textAlign: TextAlign.center,
                  style: designTypography.styleTitle.copyWith(color: designColours.white),
                ),
              ),
              //* -=-=-=-=-=- Take Picture Widget -=-=-=-=-=-
              if (viewModelState.cameraControllerInitialised && !viewModel.cameraController!.value.isPreviewPaused)
                Positioned(
                  left: buttonPositionX,
                  top: buttonPositionY,
                  width: buttonWidth,
                  height: buttonWidth,
                  child: FaceTrackerButton(
                    active: viewModelState.faceFound && !viewModelState.isBusy,
                    onTap: viewModel.requestSelfie,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
