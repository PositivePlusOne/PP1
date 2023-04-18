// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
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
import '../registration/components/face_tracker_button_painter.dart';
import '../registration/components/face_tracker_painter.dart';
import 'vms/profile_reference_image_view_model.dart';

@RoutePage()
class ProfileReferenceImagePage extends HookConsumerWidget {
  const ProfileReferenceImagePage({
    super.key,
  });

  static final GlobalKey cameraGlobalKey = GlobalKey();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ProfileReferenceImageViewModel viewModel = ref.read(profileReferenceImageViewModelProvider.notifier);
    final ProfileReferenceImageViewModelState viewModelState = ref.watch(profileReferenceImageViewModelProvider);
    useLifecycleHook(viewModel);

    final AppLocalizations appLocalization = AppLocalizations.of(context)!;
    final DesignColorsModel designColours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel designTypography = ref.read(designControllerProvider.select((value) => value.typography));

    final AppRouter appRouter = ref.read(appRouterProvider);
    final MediaQueryData mediaQuery = MediaQuery.of(appRouter.navigatorKey.currentState!.context);

    String caption = appLocalization.page_profile_image_selfie_pending;
    if (viewModelState.cameraControllerInitialised && viewModel.cameraController!.value.isPreviewPaused) {
      caption = appLocalization.shared_actions_uploading;
    } else if (viewModelState.faceFound) {
      caption = appLocalization.page_profile_image_selfie_ready;
    }

    return PositiveScaffold(
      hideBottomPadding: true,
      headingWidgets: <Widget>[
        SliverFillRemaining(
          child: Stack(
            children: [
              if (viewModelState.cameraControllerInitialised) ...<Widget>[
                //* -=-=-=-=-=- Camera Widget -=-=-=-=-=-
                Positioned.fill(
                  child: RepaintBoundary(
                    key: cameraGlobalKey,
                    child: Transform.scale(
                      scale: viewModel.scale,
                      child: Center(
                        child: CameraPreview(
                          viewModel.cameraController!,
                        ),
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
                      scale: viewModel.scale,
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
                      onPressed: viewModel.onCancel,
                      child: Text(
                        appLocalization.shared_actions_cancel,
                        textAlign: TextAlign.start,
                        style: designTypography.styleButtonBold.copyWith(color: designColours.white),
                      ),
                    ),
                  ),
                ),
              //* -=-=-=-=-=- Information Text and Take Picture Widget -=-=-=-=-=-
              if (viewModelState.cameraControllerInitialised && !viewModel.cameraController!.value.isPreviewPaused)
                FaceTrackerButtonPosition(
                  displayHintText: true,
                  mediaQuery: mediaQuery,
                  active: viewModel.faceFoundRecently && !viewModelState.isBusy,
                  onTap: viewModel.requestSelfie,
                  caption: caption,
                )
            ],
          ),
        ),
      ],
    );
  }
}
