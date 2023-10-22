// Flutter imports:

// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:auto_route/auto_route.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/widgets/organisms/post/component/positive_image_editor.dart';
import 'package:app/widgets/organisms/post/create_post_clip_editor.dart';
import 'package:app/widgets/organisms/post/create_post_dialogue.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/organisms/post/vms/create_post_view_model.dart';
import 'package:app/widgets/organisms/shared/components/positive_post_navigation_bar.dart';
import 'package:app/widgets/organisms/shared/positive_camera.dart';
import '../../../dtos/system/design_colors_model.dart';
import '../../../providers/system/design_controller.dart';
import '../../atoms/camera/camera_floating_button.dart';

@RoutePage()
class CreatePostPage extends StatefulHookConsumerWidget {
  const CreatePostPage({
    this.isEditPage = false,
    this.activityData,
    super.key,
  }) : assert(isEditPage == false || (activityData != null));

  final bool isEditPage;
  final ActivityData? activityData;

  @override
  ConsumerState<CreatePostPage> createState() => _CreatePostPageState();
}

class _CreatePostPageState extends ConsumerState<CreatePostPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback(onFirstRender);
  }

  void onFirstRender(Duration timeStamp) {
    ref.read(createPostViewModelProvider.notifier).onFilterSelected(AwesomeFilter.None);
    if (widget.isEditPage && widget.activityData != null) {
      ref.read(createPostViewModelProvider.notifier).loadActivityData(context, widget.activityData!);
    } else {
      ref.read(createPostViewModelProvider.notifier).initCamera(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final DesignColorsModel colours = ref.watch(designControllerProvider.select((value) => value.colors));
    final MediaQueryData mediaQueryData = MediaQuery.of(context);
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));

    final CreatePostViewModel viewModel = ref.read(createPostViewModelProvider.notifier);
    final CreatePostViewModelState state = ref.watch(createPostViewModelProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    final Profile? currentProfile = ref.watch(profileControllerProvider.select((value) => value.currentProfile));
    final currentProfileId = currentProfile?.flMeta?.id;

    //? Aspect ratio of the available screen space
    final double aspectRatio = (mediaQueryData.size.width - mediaQueryData.padding.right - mediaQueryData.padding.left) / (mediaQueryData.size.height - mediaQueryData.padding.bottom - mediaQueryData.padding.top);

    //? phone reserved bottom padding + navigation bar height + padding between navigation and bottom of the screen
    final double bottomNavigationArea = mediaQueryData.padding.bottom + kCreatePostNavigationHeight + kPaddingMedium;

    return WillPopScope(
      onWillPop: state.isBusy ? (() async => false) : viewModel.onWillPopScope,
      child: Scaffold(
        backgroundColor: colours.black,
        resizeToAvoidBottomInset: false,
        body: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
          child: Stack(
            children: <Widget>[
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-                    Camera                    -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              if (state.currentCreatePostPage == CreatePostCurrentPage.camera) ...[
                Positioned.fill(
                  child: PositiveCamera(
                    key: state.cameraWidgetKey,
                    onCameraImageTaken: (image) => viewModel.onImageTaken(context, image),
                    onCameraVideoTaken: (video) => viewModel.onVideoTaken(context, video),
                    //? Padding at the bottom of the screen to move the camera button above the bottom navigation
                    cameraNavigation: (_) {
                      return const SizedBox(
                        //? bottomNavigationArea + extra medium padding - the safe area as this widget includes that already
                        height: kCreatePostNavigationHeight + kPaddingMedium + kPaddingMedium,
                      );
                    },
                    //? Widget found near the bottom of the screen to the left of the take photo button
                    leftActionWidget: state.currentPostType == PostType.image
                        ? CameraFloatingButton.postWithoutImage(
                            active: true,
                            onTap: (context) => viewModel.showCreateTextPost(context),
                          )
                        : const SizedBox(
                            width: kIconLarge,
                            height: kIconLarge,
                          ),
                    onTapClose: (_) => appRouter.pop(),
                    onTapAddImage: (context) => viewModel.onMultiImagePicker(context),
                    isVideoMode: state.currentPostType == PostType.clip,
                    bottomNavigationSize: bottomNavigationArea + kPaddingSmall,
                    topNavigationSize: mediaQueryData.padding.top + kIconLarge + kPaddingSmall * 2,

                    ///? Change UI state based on current clip state
                    onClipStateChange: viewModel.onClipStateChange,

                    ///? Options for camera delay before taking picture or clip
                    maxDelay: viewModel.delayTimerOptions[state.delayTimerCurrentSelection],
                    delayTimerOptions: viewModel.delayTimerOptions.map((e) => "$e${localisations.page_create_post_seconds}").toList(),
                    delayTimerSelection: state.delayTimerCurrentSelection,
                    onDelayTimerChanged: viewModel.onDelayTimerChanged,
                    isDelayTimerEnabled: state.isDelayTimerEnabled,

                    ///? Options for camera Maximum recording lenght before forcing the clip to end
                    maxRecordingLength: viewModel.maximumClipDurationOptions[state.maximumClipDurationSelection],
                    recordingLengthOptions: viewModel.maximumClipDurationOptions.map((e) => viewModel.clipDurationString(context, e)).toList(),
                    recordingLengthSelection: state.maximumClipDurationSelection,
                    onRecordingLengthChanged: viewModel.onClipDurationChanged,
                    isRecordingLengthEnabled: true,
                    // isRecordingLengthEnabled: state.isMaximumClipDurationEnabled,

                    topAdditionalActions: [
                      Row(
                        children: [
                          //? top right set of icons found on the clips page, move this later to a builder?
                          const Spacer(),
                          Text(
                            localisations.page_create_post_ui_timer,
                            style: typography.styleButtonRegular.copyWith(color: colours.white),
                          ),
                          const SizedBox(
                            width: kPaddingSmall,
                          ),
                          CameraFloatingButton.timer(
                            active: true,
                            iconColour: colours.black,
                            backgroundColour: colours.white,
                            isOn: state.isDelayTimerEnabled,
                            onTap: (_) => viewModel.onTimerToggleRequest(),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-                  Edit Photo                  -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              if (state.currentCreatePostPage == CreatePostCurrentPage.editPhoto) ...[
                PositiveImageEditor(
                  galleryEntry: state.editingGalleryEntry,
                  currentFilter: state.currentFilter,
                  onFilterSelected: viewModel.onFilterSelected,
                  onBackButtonPressed: viewModel.onWillPopScope,
                ),
              ],
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-    Background Image on Create Image Post     -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              if (state.currentCreatePostPage == CreatePostCurrentPage.createPostImage && state.galleryEntries.length == 1) ...[
                Positioned.fill(
                  child: ColorFiltered(
                    colorFilter: ColorFilter.matrix(state.currentFilter.matrix),
                    child: Image.memory(
                      state.galleryEntries.first.data ?? Uint8List(0),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-              Create Post Dialog              -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              if (state.currentCreatePostPage.isCreationDialog) ...<Widget>[
                Positioned.fill(
                  child: CreatePostDialogue(
                    isBusy: state.isBusy,
                    postType: state.currentPostType,
                    captionController: viewModel.captionController,
                    altTextController: viewModel.altTextController,
                    promotionKeyTextController: viewModel.promotionKeyTextController,
                    onTagsPressed: (context) => viewModel.onTagsPressed(context),
                    onUpdateAllowSharing: viewModel.onUpdateAllowSharing,
                    onUpdateAllowComments: viewModel.onUpdateAllowComments,
                    onUpdatePromotedPost: (ctx) => viewModel.onUpdatePromotePost(ctx, currentProfileId!),
                    onUpdateSaveToGallery: state.isEditing ? null : viewModel.onUpdateSaveToGallery,
                    onUpdateVisibleTo: viewModel.onUpdateVisibleTo,
                    valueAllowSharing: state.allowSharing,
                    valueSaveToGallery: state.saveToGallery,
                    valuePromotedPost: viewModel.isPromotedPost,
                    galleryEntries: state.galleryEntries,
                    tags: state.tags,
                    initialValueAllowComments: state.allowComments,
                    initialValueSharingVisibility: state.visibleTo,
                  ),
                ),
              ],
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-                 Clip Editor                  -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              if (state.currentCreatePostPage == CreatePostCurrentPage.createPostEditClip) ...<Widget>[
                Positioned.fill(
                  child: PositiveClipEditor(
                    onTapClose: (_) => appRouter.pop(),
                    controller: viewModel.videoEditorController,
                    // targetVideoAspectRatio: aspectRatio,
                    bottomNavigationSize: kCreatePostNavigationHeight + kPaddingMedium + kPaddingSmall,
                    topNavigationSize: kIconLarge + kPaddingSmall * 2,
                  ),
                ),
              ],
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              //* -=-=-=-=-=-              Bottom Navigation               -=-=-=-=-=- *\\
              //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
              AnimatedPositioned(
                duration: kAnimationDurationRegular,
                bottom: state.isBottomNavigationEnabled ? kPaddingMedium + mediaQueryData.padding.bottom : -(kPaddingMedium + kCreatePostNavigationHeight),
                height: kCreatePostNavigationHeight,
                left: kPaddingSmall,
                right: kPaddingSmall,
                child: PositivePostNavigationBar(
                  onTapPost: (context) => viewModel.onPostPressed(context),
                  onTapClip: (context) => viewModel.onClipPressed(context),
                  onTapEvent: (context) => viewModel.onEventPressed(context),
                  onTapFlex: (context) => viewModel.onFlexButtonPressed(context),
                  activeButton: state.activeButton,
                  flexCaption: state.activeButtonFlexText,
                  isEnabled: viewModel.isNavigationEnabled && !state.isBusy && state.isBottomNavigationEnabled,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
