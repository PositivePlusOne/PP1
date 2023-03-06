// Flutter imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/organisms/face_detection/components/face_tracker_button_painter.dart';
import 'package:app/widgets/organisms/face_detection/vms/profile_image_view_model.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:camera/camera.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';
import 'package:app/widgets/molecules/scaffolds/positive_scaffold.dart';
import '../../../gen/app_router.dart';
import 'components/face_tracker_painter.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

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

    final String caption = (viewModelState.faceFound) ? appLocalization.page_onboarding_selfie_selfie_ready : appLocalization.page_onboarding_selfie_position_face;

    const double buttonWidth = 72.0;
    final double buttonPositionX = (mediaQuery.size.width / 2) - buttonWidth / 2;
    final double buttonPositionY = (mediaQuery.size.height * 0.85);
    final double textPositionY = buttonPositionY - 55.0;

    return PositiveScaffold(
      onWillPopScope: () async => false,
      children: <Widget>[
        SliverFillRemaining(
          child: Stack(
            children: [
              //* -=-=-=-=-=- Camera Widget -=-=-=-=-=-
              if (viewModelState.cameraControllerInitialised)
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
              if (viewModelState.cameraControllerInitialised)
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
              //* -=-=-=-=-=- Cancel Button Widget -=-=-=-=-=-
              Positioned(
                left: mediaQuery.size.width * 0.07,
                top: mediaQuery.size.height * 0.13,
                right: 0.0,
                bottom: 0.0,
                child: Align(
                  alignment: Alignment.topLeft,
                  child: TextButton(
                    onPressed: () => appRouter.pop(),
                    child: Text(
                      appLocalization.page_onboarding_selfie_cancel,
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
