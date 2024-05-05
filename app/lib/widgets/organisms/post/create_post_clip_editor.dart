// Dart imports:

// Flutter imports:
import 'package:app/widgets/organisms/post/component/positive_clip_External_shader.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:unicons/unicons.dart';
import 'package:video_editor/video_editor.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/widget_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/third_party.dart';
import 'package:app/widgets/atoms/camera/camera_floating_button.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/molecules/containers/positive_glass_sheet.dart';

//*-------------------*//
//*VIDEO EDITOR SCREEN*//
//*-------------------*//
class PositiveClipEditor extends StatefulHookConsumerWidget {
  const PositiveClipEditor({
    required this.topNavigationSize,
    required this.bottomNavigationSize,
    required this.controller,
    this.targetVideoAspectRatio,
    this.onTapClose,
    this.onTapFullClose,
    this.onInternalAddImageTap,
    super.key,
  });

  final double topNavigationSize;
  final double bottomNavigationSize;
  final double? targetVideoAspectRatio;

  final VideoEditorController? controller;

  final Function(BuildContext context)? onTapClose;
  final Function(BuildContext context)? onTapFullClose;
  final Function(BuildContext context)? onInternalAddImageTap;

  @override
  ConsumerState<PositiveClipEditor> createState() => _PositiveClipEditorState();
}

class _PositiveClipEditorState extends ConsumerState<PositiveClipEditor> {
  final double height = 60;

  @override
  void initState() {
    super.initState();
    setupController();
  }

  @override
  void didUpdateWidget(PositiveClipEditor oldWidget) {
    super.didUpdateWidget(oldWidget);

    final String? newFile = widget.controller?.file.path;
    final String? oldFile = oldWidget.controller?.file.path;
    if (newFile != null && newFile != oldFile) {
      setupController();
    }
  }

  @override
  void dispose() async {
    widget.controller?.dispose();
    super.dispose();
  }

  Future<void> setupController() async {
    final Logger logger = providerContainer.read(loggerProvider);
    if (widget.controller == null) {
      logger.e('VideoEditorController is null');
      return;
    }

    if (widget.controller?.initialized == true) {
      logger.i('VideoEditorController is already initialized');
      return;
    }

    await Future<void>.delayed(kAnimationDurationDebounce);
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        await widget.controller?.initialize(aspectRatio: widget.targetVideoAspectRatio);
        setStateIfMounted();
      } catch (e) {
        logger.e('VideoEditorController failed to initialize');
        logger.e(e);
        providerContainer.read(appRouterProvider).removeLast();
        ScaffoldMessenger.of(context).showSnackBar(PositiveErrorSnackBar(text: 'An error occured while loading the video editor.'));
      }
    });
  }

  bool get checkVideoLength {
    //TODO(S): This requires a callback on the controller, when controller is remade update this
    if (widget.controller != null && widget.controller!.trimmedDuration.inSeconds <= kMaxClipDurationSeconds) {
      return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.watch(designControllerProvider.select((value) => value.typography));
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: Colors.black,
        body: (widget.controller != null && widget.controller!.initialized)
            ? SafeArea(
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-            Video Preview             -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    if (widget.controller != null)
                      Positioned.fill(
                        child: CropGridViewer.preview(
                          controller: widget.controller!,
                        ),
                      ),
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-           Video Trim Slider          -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    if (widget.controller != null)
                      Positioned(
                        bottom: widget.bottomNavigationSize + kPaddingMediumLarge,
                        height: kIconHuge,
                        left: kPaddingMediumLarge,
                        right: kPaddingMediumLarge,
                        child: SizedBox(
                          height: kIconHuge,
                          child: _trimSlider(),
                        ),
                      ),
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-            Overlay Shader            -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    Positioned.fill(
                      child: PositiveClipExternalShader(
                        paddingLeft: kPaddingNone,
                        paddingRight: kPaddingNone,
                        paddingTop: widget.topNavigationSize,
                        paddingBottom: widget.bottomNavigationSize,
                        colour: colours.black.withOpacity(kOpacityVignette),
                        radius: kBorderRadiusLarge,
                      ),
                    ),
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-            Top Navigation            -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    Positioned(
                      left: kPaddingMedium,
                      right: kPaddingMedium,
                      top: kPaddingSmall,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CameraFloatingButton(active: true, onTap: widget.onTapClose ?? (_) {}, iconData: UniconsLine.angle_left),
                          const Spacer(),
                          CameraFloatingButton.close(active: true, onTap: widget.onTapFullClose ?? (_) {}),
                        ],
                      ),
                    ),
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    //* -=-=-=-=-=-         Video Error Overlay          -=-=-=-=-=- *\\
                    //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                    Positioned(
                      left: kPaddingMedium,
                      right: kPaddingMedium,
                      top: widget.topNavigationSize + kPaddingMedium,
                      child: IgnorePointer(
                        child: AnimatedOpacity(
                          opacity: checkVideoLength ? kOpacityNone : kOpacityFull,
                          duration: kAnimationDurationRegular,
                          child: PositiveGlassSheet(
                            borderRadius: kBorderRadiusMedium,
                            horizontalPadding: kPaddingMedium,
                            verticalPadding: kPaddingExtraSmall,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    UniconsLine.exclamation_triangle,
                                    color: colours.white,
                                  ),
                                  const SizedBox(width: kPaddingSmall),
                                  Expanded(
                                    child: Text(
                                      localisations.page_create_post_clip_length_limit,
                                      style: typography.styleSubtitle.copyWith(color: colours.white),
                                      softWrap: true,
                                    ),
                                  ),
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }

  Widget _trimSlider() {
    if (widget.controller != null) {
      return TrimSlider(
        controller: widget.controller!,
        height: 50,
      );
    }
    return const SizedBox();
  }
}
