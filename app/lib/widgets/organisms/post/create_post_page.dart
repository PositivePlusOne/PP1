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
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/reactions.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/database/relationships/relationship.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/cache_controller.dart';
import 'package:app/widgets/atoms/buttons/positive_close_button.dart';
import 'package:app/widgets/atoms/indicators/positive_loading_indicator.dart';
import 'package:app/widgets/molecules/content/positive_activity_widget.dart';
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
    if (widget.isEditPage || widget.activityData != null) {
      ref.read(createPostViewModelProvider.notifier).loadActivityData(widget.activityData!);
    } else {
      ref.read(createPostViewModelProvider.notifier).initCamera();
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
    final String currentProfileId = currentProfile?.flMeta?.id ?? '';

    //? Aspect ratio of the available screen space used to measure the clip preview when taking video
    // final double aspectRatio = (mediaQueryData.size.width - mediaQueryData.padding.right - mediaQueryData.padding.left) / (mediaQueryData.size.height - mediaQueryData.padding.bottom - mediaQueryData.padding.top);

    //? phone reserved bottom padding + navigation bar height + padding between navigation and bottom of the screen
    final double bottomNavigationArea = mediaQueryData.padding.bottom + kCreatePostNavigationHeight + kPaddingMedium;

    return WillPopScope(
      onWillPop: state.isBusy ? (() async => false) : () => viewModel.onWillPopScope(),
      child: AnnotatedRegion<SystemUiOverlayStyle>(
        value: buildSystemUiOverlayStyle(appBarColor: colours.black, backgroundColor: colours.black),
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
                      onCameraImageTaken: (image) => viewModel.onImageTaken(image),
                      onCameraVideoTaken: (video) => viewModel.onVideoTaken(video),
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
                              onTap: (context) => viewModel.showCreateTextPost(),
                            )
                          : const SizedBox(
                              width: kIconLarge,
                              height: kIconLarge,
                            ),
                      onTapClose: (_) => appRouter.pop(),
                      onTapAddImage: (context) => viewModel.onMultiImagePicker(),
                      isVideoMode: state.currentPostType == PostType.clip,
                      bottomNavigationSize: bottomNavigationArea + kPaddingSmall,
                      topNavigationSize: mediaQueryData.padding.top + kIconLarge + kPaddingSmall * 2,

                      ///? Change UI state based on current clip state
                      onClipStateChange: (state) => viewModel.onClipStateChange(state),

                      ///? Options for camera delay before taking picture or clip
                      maxDelay: viewModel.delayTimerOptions[state.delayTimerCurrentSelection],
                      delayTimerOptions: viewModel.delayTimerOptions.map((e) => "$e${localisations.page_create_post_seconds}").toList(),
                      delayTimerSelection: state.delayTimerCurrentSelection,
                      onDelayTimerChanged: viewModel.onDelayTimerChanged,
                      isDelayTimerEnabled: state.isDelayTimerEnabled,

                      ///? Options for camera Maximum recording lenght before forcing the clip to end
                      maxRecordingLength: viewModel.maximumClipDurationOptions[state.maximumClipDurationSelection],
                      recordingLengthOptions: viewModel.maximumClipDurationOptions.map((e) => viewModel.clipDurationString(e)).toList(),
                      recordingLengthSelection: state.maximumClipDurationSelection,
                      onRecordingLengthChanged: viewModel.onClipDurationChanged,
                      isRecordingLengthEnabled: true,
                      // isRecordingLengthEnabled: state.isMaximumClipDurationEnabled,

                      topAdditionalActions: [
                        Row(
                          children: [
                            //? top right set of icons found on the clips page, move this later to a builder?
                            const Spacer(),
                            if (state.isDelayTimerEnabled)
                              Text(
                                localisations.page_create_post_ui_timer,
                                style: typography.styleButtonRegular.copyWith(color: colours.white),
                              ),
                            const SizedBox(
                              width: kPaddingSmall,
                            ),
                            SizedBox(
                              height: kIconLarge + kPaddingExtraSmall,
                              width: kIconLarge + kPaddingVerySmall,
                              child: Stack(
                                alignment: Alignment.topRight,
                                children: [
                                  Positioned(
                                    bottom: kPaddingNone,
                                    left: kPaddingNone,
                                    width: kIconLarge,
                                    height: kIconLarge,
                                    child: CameraFloatingButton.timer(
                                      active: true,
                                      iconColour: colours.black,
                                      backgroundColour: colours.white,
                                      isOn: state.isDelayTimerEnabled,
                                      onTap: (_) => viewModel.onTimerToggleRequest(),
                                    ),
                                  ),
                                  Positioned(
                                    child: IgnorePointer(
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: state.isDelayTimerEnabled ? colours.black : colours.white,
                                          borderRadius: BorderRadius.circular(
                                            kBorderRadiusHuge,
                                          ),
                                        ),
                                        width: kIconSmall,
                                        height: kIconSmall,
                                        child: Align(
                                          child: Text(
                                            "${viewModel.delayTimerOptions[state.delayTimerCurrentSelection]}${localisations.page_create_post_seconds}",
                                            style: typography.styleSubtextBold.copyWith(color: state.isDelayTimerEnabled ? colours.white : colours.black),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
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
                    onBackButtonPressed: () => viewModel.onWillPopScope(),
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
                //* -=-=-=-=-=-              Reposter preview                -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                if (state.currentCreatePostPage == CreatePostCurrentPage.repostPreview) ...[
                  Positioned.fill(
                    child: CreatePostShareActivityPlaceholder(
                      colours: colours,
                      currentProfile: currentProfile,
                      repostActivityId: state.reposterActivityID ?? '',
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
                      onTagsPressed: (context) => viewModel.onTagsPressed(),
                      onUpdateAllowSharing: (_) => viewModel.onUpdateAllowSharing(),
                      onUpdateAllowComments: viewModel.onUpdateAllowComments,
                      onUpdatePromotedPost: (ctx) => viewModel.onUpdatePromotePost(currentProfileId),
                      onUpdateSaveToGallery: state.isEditing ? null : (_) => viewModel.onUpdateSaveToGallery(),
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
                    onTapPost: (_) => viewModel.onPostPressed(),
                    onTapClip: (_) => viewModel.onClipPressed(),
                    onTapEvent: (_) => viewModel.onEventPressed(),
                    onTapFlex: (_) => viewModel.onFlexButtonPressed(),
                    activeButton: state.activeButton,
                    flexCaption: state.activeButtonFlexText,
                    isEnabled: viewModel.isNavigationEnabled && !state.isBusy && state.isBottomNavigationEnabled,
                  ),
                ),
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                //* -=-=-=-=-=-              Blocking Overlay               -=-=-=-=-=- *\\
                //* -=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-= *\\
                if (state.isProcessingMedia) ...<Widget>[
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        color: colours.black.withOpacity(kOpacityBarrier),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            PositiveLoadingIndicator(color: colours.white),
                            const SizedBox(height: kPaddingSmall),
                            Text(
                              localisations.page_create_post_processing,
                              style: typography.styleSubtextBold.copyWith(color: colours.white),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
                if (state.isCreatingPost) ...<Widget>[
                  Positioned.fill(
                    child: IgnorePointer(
                      child: Container(
                        color: colours.black.withOpacity(kOpacityBarrier),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            PositiveLoadingIndicator(color: colours.white),
                            if (state.isUploadingMedia) ...<Widget>[
                              const SizedBox(height: kPaddingSmall),
                              Text(
                                state.isEditing ? localisations.page_edit_post_uploading : localisations.page_create_post_uploading,
                                style: typography.styleSubtextBold.copyWith(color: colours.white),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class CreatePostShareActivityPlaceholder extends StatelessWidget {
  const CreatePostShareActivityPlaceholder({
    super.key,
    required this.colours,
    required this.currentProfile,
    required this.repostActivityId,
  });

  final DesignColorsModel colours;
  final Profile? currentProfile;
  final String repostActivityId;

  @override
  Widget build(BuildContext context) {
    final AppLocalizations localizations = AppLocalizations.of(context)!;
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = providerContainer.read(designControllerProvider.select((value) => value.typography));

    final CacheController cacheController = providerContainer.read(cacheControllerProvider);
    final Activity? reposterActivity = cacheController.get(repostActivityId);

    final String reposterProfileId = reposterActivity?.publisherInformation?.publisherId ?? '';
    final String reposterOriginFeed = reposterActivity?.publisherInformation?.originFeed ?? '';

    final Profile? reposterProfile = cacheController.get(reposterProfileId);

    final String reposterRelationshipId = [reposterProfileId, currentProfile?.flMeta?.id ?? ''].asGUID;
    final Relationship? reposterRelationship = cacheController.get(reposterRelationshipId);

    final TargetFeed reposterFeed = TargetFeed.fromOrigin(reposterOriginFeed);

    final MediaQueryData mediaQueryData = MediaQuery.of(context);

    return ListView(
      padding: EdgeInsets.only(
        top: mediaQueryData.padding.top + kPaddingMedium,
        bottom: mediaQueryData.padding.bottom + kPaddingMedium,
        left: kPaddingMedium,
        right: kPaddingMedium,
      ),
      children: <Widget>[
        const Align(
          alignment: Alignment.centerLeft,
          child: PositiveCloseButton(brightness: Brightness.dark),
        ),
        const SizedBox(height: kPaddingMassive),
        Text(
          localizations.page_create_post_repost_heading,
          style: typography.styleHeroMedium.copyWith(color: colours.white),
        ),
        const SizedBox(height: kPaddingMedium),
        Container(
          decoration: BoxDecoration(
            color: colours.white,
            borderRadius: BorderRadius.circular(kBorderRadiusMedium),
          ),
          margin: const EdgeInsets.all(kPaddingSmall),
          padding: const EdgeInsets.all(kPaddingSmall),
          child: PositiveActivityWidget(
            index: 0,
            currentProfile: currentProfile,
            targetFeed: reposterFeed,
            targetProfile: reposterProfile,
            targetRelationship: reposterRelationship,
            activity: reposterActivity,
            activityReactionStatistics: null,
            activityPromotion: null,
            activityProfileReactions: const [],
            isEnabled: false,
            isFullscreen: false,
            reposterProfile: null,
            reposterRelationship: null,
            reposterActivity: null,
            reposterReactionStatistics: null,
            reposterActivityProfileReactions: const [],
            isShared: true,
          ),
        ),
        const SizedBox(height: kPaddingAppBarBreak),
      ],
    );
  }
}
