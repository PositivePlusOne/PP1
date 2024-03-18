// Dart imports:
import 'dart:io';

// Flutter imports:
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unicons/unicons.dart';
import 'package:video_editor/video_editor.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/mentions.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/extensions/string_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/content/dtos/gallery_entry.dart';
import 'package:app/providers/content/gallery_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/providers/user/mixins/profile_switch_mixin.dart';
import 'package:app/services/clip_ffmpeg_service.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/organisms/post/component/positive_discard_clip_dialogue.dart';
import 'package:app/widgets/organisms/post/component/positive_discard_post_dialogue.dart';
import 'package:app/widgets/organisms/post/create_post_tag_dialogue.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:app/widgets/organisms/shared/positive_camera.dart';
import '../../../../services/third_party.dart';

// Project imports:

part 'create_post_view_model.freezed.dart';
part 'create_post_view_model.g.dart';

@freezed
class CreatePostViewModelState with _$CreatePostViewModelState {
  const factory CreatePostViewModelState({
    @Default(false) bool isBusy,
    @Default(false) bool isProcessingMedia,
    @Default(false) bool isUploadingMedia,
    @Default(false) bool isCreatingPost,
    @Default(false) bool isEditingPost,
    @Default(PostType.image) PostType currentPostType,
    @Default(CreatePostCurrentPage.entry) CreatePostCurrentPage currentCreatePostPage,
    @Default('') String currentActivityID,
    @Default([]) List<Media> currentActivityMedia,
    @Default([]) List<GalleryEntry> galleryEntries,
    GalleryEntry? editingGalleryEntry,
    @Default([]) List<String> tags,
    @Default('') String promotionKey,
    @Default(true) bool allowSharing,
    @Default(ActivitySecurityConfigurationMode.public()) @JsonKey(fromJson: ActivitySecurityConfigurationMode.fromJson, toJson: ActivitySecurityConfigurationMode.toJson) ActivitySecurityConfigurationMode visibleTo,
    @Default(ActivitySecurityConfigurationMode.signedIn()) @JsonKey(fromJson: ActivitySecurityConfigurationMode.fromJson, toJson: ActivitySecurityConfigurationMode.toJson) ActivitySecurityConfigurationMode allowComments,
    @Default("") String activeButtonFlexText,
    @Default(false) bool saveToGallery,
    required AwesomeFilter currentFilter,
    //? Repost
    @Default('') String? reposterActivityID,
    //? Editing
    required ActivityData previousActivity,
    //? Clip delay and clip length options
    @Default(0) int delayTimerCurrentSelection,
    //? Repost
    @Default('') String postingAsProfileID,
    @Default(false) bool isDelayTimerEnabled,
    @Default(0) int maximumClipDurationSelection,
    @Default(false) bool isMaximumClipDurationEnabled,
    @Default(true) bool isBottomNavigationEnabled,
    @Default(false) bool isRecordingClip,
    required GlobalKey<PositiveCameraState> cameraWidgetKey,
    @Default(PositivePostNavigationActiveButton.post) PositivePostNavigationActiveButton activeButton,
    @Default(PositivePostNavigationActiveButton.post) PositivePostNavigationActiveButton lastActiveButton,
  }) = _CreatePostViewModelState;

  factory CreatePostViewModelState.initialState() => CreatePostViewModelState(
        currentFilter: AwesomeFilter.None,
        previousActivity: ActivityData(),
        cameraWidgetKey: GlobalKey(),
      );
}

@riverpod
class CreatePostViewModel extends _$CreatePostViewModel with ProfileSwitchMixin {
  final TextEditingController captionController = TextEditingController();
  final TextEditingController altTextController = TextEditingController();
  final TextEditingController promotionKeyTextController = TextEditingController();

  VideoEditorController? videoEditorController;
  File? uneditedVideoFile;

  bool get isRepost => state.previousActivity.postType == PostType.repost;

  PositiveCameraState? get currentPositiveCameraState {
    return state.cameraWidgetKey.currentState is PositiveCameraState ? state.cameraWidgetKey.currentState as PositiveCameraState : null;
  }

  CameraState? get currentCameraState {
    return currentPositiveCameraState?.cachedCameraState?.cameraContext.stateController.valueOrNull;
  }

  @override
  CreatePostViewModelState build() {
    return CreatePostViewModelState.initialState();
  }

  Future<void> onFirstOpen() async {
    final bool selectedAccount = await trySwitchProfile();

    if (!selectedAccount) {
      return;
    }

    displayCamera(PostType.image);
    return;
  }

  Future<bool> trySwitchProfile() async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    if (canSwitchProfile) {
      state = state.copyWith(
        postingAsProfileID: await requestSwitchProfileDialog(
          context,
          title: localisations.generic_organisation_actions_post_as_title,
          requestSwitchProfile: false,
          mode: null,
        ),
      );
      if (state.postingAsProfileID.isEmpty) {
        router.pop();
        return false;
      }
    } else {
      state = state.copyWith(postingAsProfileID: "");
    }
    return true;
  }

  Future<bool> goBack({
    bool shouldForceClose = false,
  }) async {
    //? Navigation not permitted while processing
    if (state.isBusy) {
      return false;
    }

    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
    final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    final bool isHandlingVideo = state.currentCreatePostPage == CreatePostCurrentPage.camera && state.currentPostType == PostType.clip;
    final bool isRecordingVideo = isHandlingVideo && !(currentPositiveCameraState?.clipRecordingState.isInactive ?? false);
    final bool isPrerecordingVideo = isHandlingVideo && currentPositiveCameraState?.clipRecordingState == ClipRecordingState.preRecording;

    // Quickly back out if we're editing any post
    if (state.isEditingPost && state.currentCreatePostPage.isCreationDialog) {
      await analyticsController.trackEvent(AnalyticEvents.postEditDiscarded);
      router.removeLast();
      return false;
    }

    // Quickly back out if in the countdown
    if (isPrerecordingVideo) {
      await currentPositiveCameraState?.stopClipRecording();
      currentPositiveCameraState?.onClipResetState();
      displayCamera(PostType.clip);
      return false;
    }

    if (isRecordingVideo || state.currentCreatePostPage == CreatePostCurrentPage.createPostEditClip) {
      // await currentPositiveCameraState?.onPauseResumeClip(forcePause: true);
      await currentPositiveCameraState?.stopClipRecording();
      // we were recording a video - this has a special dialog to show the user
      final bool hasAcceptedDiscardDialog = await positiveDiscardClipDialogue(
        context: context,
        colors: colors,
        typography: typography,
      );

      if (!hasAcceptedDiscardDialog) {
        return false;
      }

      if (state.currentCreatePostPage == CreatePostCurrentPage.createPostEditClip) {
        displayCamera(PostType.clip);
      } else {
        currentPositiveCameraState?.onClipResetState();
      }

      if (hasAcceptedDiscardDialog) {
        clearVideoData();
        clearPostData();
        return false;
      }

      // Close the video and remove the page
      if (shouldForceClose) {
        await analyticsController.trackEvent(AnalyticEvents.postDiscarded);
        router.removeLast();
      }
      return false;
    } else {
      if (shouldForceClose) {
        if (await positiveDiscardPostDialogue(
          context: context,
          colors: colors,
          typography: typography,
        )) {
          await analyticsController.trackEvent(AnalyticEvents.postDiscarded);
          router.removeLast();
        } else {
          return false;
        }
      }

      // we actually always want to show a basic dialog telling them that quitting the dialog
      // will discard their post
      bool userRequestedNavigation = false;

      /// When , we want to confim that the user want's to discard
      /// their progress before going back to the previous state
      switch (state.currentCreatePostPage) {
        //? Only the create page for post text and multi image are the last in the list so should request a dialog
        case CreatePostCurrentPage.createPostText:
        case CreatePostCurrentPage.createPostMultiImage:
        //? As edit photo is equivalent of edit clip, and does not have criteria, assume dialog functionality should match.
        case CreatePostCurrentPage.editPhoto:
          if (isRepost) {
            userRequestedNavigation = true;
          } else {
            userRequestedNavigation = await positiveDiscardPostDialogue(
              context: context,
              colors: colors,
              typography: typography,
            );
          }

        //? PP1-615, back button on repost preview returns to last page
        case CreatePostCurrentPage.repostPreview:
        //? according to PP1-284 camera page should direct back to hub without dialog, unless a clip is being recorded
        case CreatePostCurrentPage.camera:
        //? Assuming entry page (called while camera initialises), should have the same logic as camera above
        case CreatePostCurrentPage.entry:
        //? Edit Clip page has its own dialog above
        case CreatePostCurrentPage.createPostEditClip:
        //? Remaining create post pages always pop without asking
        case CreatePostCurrentPage.createPostImage:
        case CreatePostCurrentPage.createPostClip:
          userRequestedNavigation = true;
      }

      if (!userRequestedNavigation) {
        return false;
      }
    }

    switch (state.currentCreatePostPage) {
      case CreatePostCurrentPage.entry:
      case CreatePostCurrentPage.repostPreview:
      case CreatePostCurrentPage.camera:
        await goBackFromCamera();
        return false;
      case CreatePostCurrentPage.createPostText:
        if (isRepost) {
          state = state.copyWith(
            currentCreatePostPage: CreatePostCurrentPage.repostPreview,
            activeButtonFlexText: localisations.shared_actions_next,
          );
        } else {
          displayCamera(PostType.image);
        }
        clearPostData();
        break;
      case CreatePostCurrentPage.createPostImage:
        state = state.copyWith(
          currentPostType: PostType.image,
          currentCreatePostPage: CreatePostCurrentPage.editPhoto,
          activeButton: PositivePostNavigationActiveButton.flex,
          activeButtonFlexText: localisations.shared_actions_next,
        );
        break;
      case CreatePostCurrentPage.editPhoto:
      case CreatePostCurrentPage.createPostMultiImage:
        displayCamera(PostType.image);
        clearPostData();
        break;
      case CreatePostCurrentPage.createPostEditClip:
        displayCamera(PostType.clip);
        clearVideoData();
        clearPostData();
        break;
      case CreatePostCurrentPage.createPostClip:
        await loadUneditedVideo();
        break;
    }
    return false;
  }

  Future<void> goBackFromCamera() async {
    final AppRouter router = ref.read(appRouterProvider);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);
    final bool isEditingPost = state.isEditingPost;
    if (isEditingPost) {
      await analyticsController.trackEvent(AnalyticEvents.postEditDiscarded);
    } else {
      await analyticsController.trackEvent(AnalyticEvents.postDiscarded);
    }

    router.removeLast();
  }

  void clearPostData() {
    captionController.clear();
    altTextController.clear();
    promotionKeyTextController.clear();

    state = state.copyWith(
      allowSharing: true,
      visibleTo: const ActivitySecurityConfigurationMode.public(),
      allowComments: const ActivitySecurityConfigurationMode.signedIn(),
      saveToGallery: false,
      galleryEntries: [],
      tags: [],
    );
  }

  void clearVideoData() {
    uneditedVideoFile = null;
    videoEditorController = null;
  }

  Future<void> onPostPressed() async {
    state = state.copyWith(
      activeButton: PositivePostNavigationActiveButton.post,
      lastActiveButton: PositivePostNavigationActiveButton.post,
      currentPostType: PostType.image,
    );
    await currentPositiveCameraState?.reactivateFlash();
  }

  Future<void> onClipPressed() async {
    state = state.copyWith(
      activeButton: PositivePostNavigationActiveButton.clip,
      lastActiveButton: PositivePostNavigationActiveButton.clip,
      currentPostType: PostType.clip,
    );
    await currentPositiveCameraState?.deactivateFlash();
  }

  Future<void> onEventPressed() async {
    state = state.copyWith(
      activeButton: PositivePostNavigationActiveButton.event,
      lastActiveButton: PositivePostNavigationActiveButton.event,
      currentPostType: PostType.event,
    );
  }

  Future<void> onFlexButtonPressed() async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    switch (state.currentCreatePostPage) {
      case CreatePostCurrentPage.entry:
        break;
      case CreatePostCurrentPage.camera:
        await stopClipRecordingAndProcessResult();
        break;
      case CreatePostCurrentPage.editPhoto:
        state = state.copyWith(
          currentCreatePostPage: CreatePostCurrentPage.createPostImage,
          activeButtonFlexText: localisations.page_create_post_create,
        );
        break;
      case CreatePostCurrentPage.createPostEditClip:
        try {
          state = state.copyWith(isProcessingMedia: true, isBusy: true);
          final ({File file, Size size}) completer = await onClipEditFinish();
          await onClipExported(completer.file, completer.size);
        } finally {
          state = state.copyWith(isProcessingMedia: false, isBusy: false);
        }
        break;
      case CreatePostCurrentPage.repostPreview:
        state = state.copyWith(
          currentCreatePostPage: CreatePostCurrentPage.createPostText,
          activeButtonFlexText: localisations.page_create_post_create,
        );
      case CreatePostCurrentPage.createPostClip:
      case CreatePostCurrentPage.createPostText:
      case CreatePostCurrentPage.createPostImage:
      case CreatePostCurrentPage.createPostMultiImage:
        final bool isAbleToSwitchProfileBack = state.postingAsProfileID.isNotEmpty && profileController.currentProfile != null && profileController.currentProfile!.flMeta != null && profileController.currentProfile!.flMeta!.id != null;
        String? currentProfileID;

        if (isAbleToSwitchProfileBack) {
          currentProfileID = profileController.currentProfile!.flMeta!.id!;
          switchProfile(state.postingAsProfileID);
        }
        await onPostFinished(profileController.currentProfile);
        if (currentProfileID != null) {
          switchProfile(currentProfileID);
        }
        break;
    }
  }

  void displayCamera(PostType postType) {
    final PositivePostNavigationActiveButton activeButton = switch (postType) {
      PostType.clip => PositivePostNavigationActiveButton.clip,
      PostType.event => PositivePostNavigationActiveButton.event,
      (_) => PositivePostNavigationActiveButton.post,
    };

    state = state.copyWith(
      currentCreatePostPage: CreatePostCurrentPage.camera,
      currentPostType: postType,
      isBottomNavigationEnabled: true,
      lastActiveButton: activeButton,
      activeButton: activeButton,
    );
  }

  Future<void> loadActivityData(ActivityData activityData) async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final logger = ref.read(loggerProvider);

    if (activityData.postType == PostType.repost) {
      final bool hasSelectedAccount = await trySwitchProfile();
      if (!hasSelectedAccount) {
        return;
      }
    }

    state = state.copyWith(isBusy: true);

    try {
      late final CreatePostCurrentPage currentPage;
      PostType currentPostType;
      String flexText = localisations.page_create_post_create;

      switch (activityData.postType) {
        case PostType.image:
          currentPage = CreatePostCurrentPage.createPostImage;
          currentPostType = PostType.image;
          break;
        case PostType.multiImage:
          currentPage = CreatePostCurrentPage.createPostMultiImage;
          currentPostType = PostType.multiImage;
          break;
        case PostType.repost:
          currentPage = CreatePostCurrentPage.repostPreview;
          flexText = localisations.shared_actions_next;
          currentPostType = PostType.repost;
          break;
        case PostType.event:
        case PostType.clip:
        default:
          currentPage = CreatePostCurrentPage.createPostText;
          currentPostType = PostType.text;
          break;
      }

      // Store the edited media
      if (activityData.media?.isNotEmpty == true) {
        state = state.copyWith(
          currentActivityMedia: activityData.media ?? [],
        );
      }

      // If the post is a repost, we have no data so we can skip this
      if (activityData.postType == PostType.repost) {
        state = state.copyWith(
          currentCreatePostPage: currentPage,
          currentPostType: currentPostType,
          reposterActivityID: activityData.reposterActivityID,
          activeButton: PositivePostNavigationActiveButton.flex,
          activeButtonFlexText: flexText,
          previousActivity: activityData,
        );

        return;
      }

      captionController.text = activityData.content ?? "";
      altTextController.text = activityData.altText ?? "";
      promotionKeyTextController.text = activityData.promotionKey ?? "";

      if (activityData.reposterActivityID?.isNotEmpty ?? false) {
        activityData.postType = PostType.repost;
        currentPostType = PostType.repost;
      }

      //? State is updated in two steps, otherwise the camera can breifly activate on the edit page due to the asynchronus fucnctions required for gallery
      state = state.copyWith(
        currentActivityID: activityData.activityID ?? "",
        isEditingPost: true,
        tags: activityData.tags ?? [],
        promotionKey: activityData.promotionKey ?? '',
        allowSharing: activityData.allowSharing ?? false,
        allowComments: activityData.commentPermissionMode ?? const ActivitySecurityConfigurationMode.signedIn(),
        visibleTo: activityData.visibilityMode ?? const ActivitySecurityConfigurationMode.public(),
        currentCreatePostPage: currentPage,
        currentPostType: currentPostType,
        activeButton: PositivePostNavigationActiveButton.flex,
        activeButtonFlexText: localisations.post_dialogue_update_post,
        previousActivity: activityData,
      );

      final List<Future<GalleryEntry>> galleryEntriesFutures = activityData.media?.map((e) async => await Media.toGalleryEntry(media: e)).toList() ?? [];
      final List<GalleryEntry> galleryEntries = await Future.wait(galleryEntriesFutures);

      state = state.copyWith(galleryEntries: galleryEntries);
    } catch (e) {
      logger.e("Error loading activity data: $e");
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<void> onTagsPressed() async {
    final TagsController tagsController = ref.read(tagsControllerProvider.notifier);

    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final List<String>? newTags = await showGeneralDialog<List<String>>(
      context: context,
      transitionDuration: kAnimationDurationExtended,
      transitionBuilder: (context, anim1, anim2, child) {
        final bool isExiting = anim1.status == AnimationStatus.reverse;

        // Slide transition for entrance
        final Offset slideBegin = isExiting ? const Offset(0.0, 0.0) : const Offset(0.0, 1.0);
        const Offset slideEnd = Offset.zero;
        const Curve slideCurve = Curves.easeInOutSine;

        final Animatable<Offset> slideTween = Tween(begin: slideBegin, end: slideEnd).chain(CurveTween(curve: slideCurve));
        final Animation<Offset> slideAnimation = anim1.drive(slideTween);

        // Fade transition for exit
        final Tween<double> fadeTween = Tween(begin: 0.0, end: 1.0);
        final Animation<double> fadeAnimation = isExiting ? anim1.drive(fadeTween) : const AlwaysStoppedAnimation(1.0);

        return SlideTransition(
          position: slideAnimation,
          child: FadeTransition(
            opacity: fadeAnimation,
            child: child,
          ),
        );
      },
      pageBuilder: (_, anim1, anim2) => CreatePostTagDialogue(
        currentTags: tagsController.getTagsFromString(state.tags),
      ),
    );

    if (newTags != null) {
      state = state.copyWith(tags: newTags);
    }
  }

  void onUpdateSaveToGallery() {
    state = state.copyWith(saveToGallery: !state.saveToGallery);
  }

  void onUpdateAllowSharing() {
    state = state.copyWith(allowSharing: !state.allowSharing);
  }

  void onUpdatePromotePost(String userId) {
    if (userId.isEmpty) {
      throw Exception("User ID is empty, cannot promote post");
    }

    final List<String> newTags = [...state.tags];

    // and toggle the state
    if (isPromotedPost) {
      // there is at least one tag that shows this is a promoted activity, remove them all
      newTags.removeWhere((element) => TagHelpers.isPromoted(element));
      promotionKeyTextController.text = '';
    } else {
      // this is not a promoted activity, add the required tags
      newTags.addAll(TagHelpers.createPromotedTags(userId: userId));
    }

    // and put these new tags back into the state
    state = state.copyWith(tags: newTags);
  }

  bool get isPromotedPost => state.tags.indexWhere((element) => TagHelpers.isPromoted(element)) != -1;

  void onUpdateVisibleTo(ActivitySecurityConfigurationMode mode) {
    state = state.copyWith(visibleTo: mode);
  }

  void onUpdateAllowComments(ActivitySecurityConfigurationMode mode) {
    state = state.copyWith(allowComments: mode);
  }

  bool get isNavigationEnabled {
    final bool hasChanged = state.isEditingPost ? hasPostBeenUpdated : true;

    switch (state.currentCreatePostPage) {
      case CreatePostCurrentPage.createPostText:
        if (captionController.text.isNotEmpty && hasChanged) {
          return true;
        } else {
          return false;
        }
      case CreatePostCurrentPage.createPostImage:
      case CreatePostCurrentPage.camera:
      default:
        return true;
    }
  }

  bool get hasPostBeenUpdated {
    if (captionController.text != state.previousActivity.content) return true;
    if (altTextController.text != state.previousActivity.altText) return true;
    if (promotionKeyTextController.text != state.previousActivity.promotionKey) return true;
    if (state.allowComments != state.previousActivity.commentPermissionMode) return true;
    if (state.visibleTo != state.previousActivity.visibilityMode) return true;
    if (state.allowSharing != state.previousActivity.allowSharing) return true;
    if (!listEquals(state.tags, state.previousActivity.tags)) return true;

    return false;
  }

  void showCreateTextPost() {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    state = state.copyWith(
      currentCreatePostPage: CreatePostCurrentPage.createPostText,
      currentPostType: PostType.text,
      activeButton: PositivePostNavigationActiveButton.flex,
      activeButtonFlexText: localisations.page_create_post_create,
    );
  }

  final List<int> delayTimerOptions = [3, 10];

  void onDelayTimerChanged(int index) {
    state = state.copyWith(
      delayTimerCurrentSelection: index,
    );
  }

  final List<int> maximumClipDurationOptions = [180000, 90000, 60000, 30000];

  void onClipDurationChanged(int index) {
    state = state.copyWith(
      maximumClipDurationSelection: index,
    );
  }

  String clipDurationString(int duration) {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    if (duration >= 120000) {
      return "${duration ~/ 60000}${localisations.page_create_post_minuets}";
    }

    return "${duration ~/ 1000}${localisations.page_create_post_seconds}";
  }

  /// Call to update main create post page UI
  void onClipStateChange(ClipRecordingState clipRecordingState) {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    PositivePostNavigationActiveButton actionButton = PositivePostNavigationActiveButton.flex;
    if (clipRecordingState.isInactive) {
      actionButton = PositivePostNavigationActiveButton.clip;
    }

    /// Called whenever clip begins or ends recording, returns true when begining, returns false when ending
    state = state.copyWith(
      isBottomNavigationEnabled: clipRecordingState.isNotRecordingOrPaused,
      isRecordingClip: clipRecordingState.isActive,
      activeButton: actionButton,
      activeButtonFlexText: localisations.shared_actions_next,
      lastActiveButton: PositivePostNavigationActiveButton.clip,
    );
  }

  void onTimerToggleRequest() {
    state = state.copyWith(isDelayTimerEnabled: !state.isDelayTimerEnabled);
  }

  //? Create video Post here
  Future<void> onVideoEditRequest(XFile xFile) async {
    uneditedVideoFile = File(xFile.path);
    await loadUneditedVideo();
  }

  Future<void> loadUneditedVideo() async {
    final logger = ref.read(loggerProvider);
    if (uneditedVideoFile == null) {
      logger.e("Unedited video file is null, cannot create clip");
      return;
    }

    final int length = await uneditedVideoFile?.length() ?? 0;
    if (length <= 0) {
      logger.e("Video file is null, cannot create clip");
      return;
    }

    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    await Future<void>.delayed(kAnimationDurationDebounce);
    currentCameraState?.dispose();

    videoEditorController = VideoEditorController.file(
      uneditedVideoFile!,
      minDuration: const Duration(milliseconds: 10),
      maxDuration: const Duration(seconds: 180),
    );

    state = state.copyWith(
      currentCreatePostPage: CreatePostCurrentPage.createPostEditClip,
      currentPostType: PostType.clip,
      isRecordingClip: false,
      activeButton: PositivePostNavigationActiveButton.flex,
      activeButtonFlexText: localisations.shared_actions_next,
      isBottomNavigationEnabled: true,
      lastActiveButton: PositivePostNavigationActiveButton.clip,
    );
  }

  Future<({File file, Size size})> onClipEditFinish() async {
    final logger = ref.read(loggerProvider);
    if (videoEditorController == null) {
      logger.e("Video editor controller is null, cannot export clip");
      return Future.error("Video editor controller is null, cannot export clip");
    }

    final CreateClipExportService exportService = ref.read(createClipExportServiceProvider);
    final File outputFile = await exportService.exportVideoFromController(videoEditorController!);
    final Size size = await exportService.getVideoSize(outputFile);

    return (file: outputFile, size: size);
  }

  Future<void> onClipExported(File file, Size size) async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final GalleryController galleryController = ref.read(galleryControllerProvider.notifier);
    final logger = ref.read(loggerProvider);

    // final XFile xFile = XFile.fromData(await file.readAsBytes());
    final XFile xFile = XFile(file.path);
    final List<GalleryEntry> entries = [];

    if (file.path.isNotEmpty) {
      final GalleryEntry entry = await galleryController.createGalleryEntryFromXFile(xFile, uploadImmediately: false, size: size);
      entries.add(entry);
    }

    if (entries.isEmpty) {
      logger.e("onClipExported: entries list is empty");
      throw Exception("onClipExported: entries list is empty");
    }

    state = state.copyWith(
      galleryEntries: entries,
      currentCreatePostPage: CreatePostCurrentPage.createPostClip,
      editingGalleryEntry: entries.firstOrNull,
      currentPostType: PostType.clip,
      activeButton: PositivePostNavigationActiveButton.flex,
      activeButtonFlexText: localisations.page_create_post_create,
    );
  }

  //? Create image Post here!
  Future<void> onImageTaken(XFile file) async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final GalleryController galleryController = ref.read(galleryControllerProvider.notifier);

    final List<GalleryEntry> entries = [];
    if (file.path.isNotEmpty) {
      final GalleryEntry entry = await galleryController.createGalleryEntryFromXFile(file, uploadImmediately: false);

      entries.add(entry);
    }

    if (entries.isEmpty) {
      return;
    }

    state = state.copyWith(
      galleryEntries: entries,
      currentCreatePostPage: CreatePostCurrentPage.editPhoto,
      editingGalleryEntry: entries.firstOrNull,
      currentPostType: PostType.image,
      activeButton: PositivePostNavigationActiveButton.flex,
      activeButtonFlexText: localisations.shared_actions_next,
    );

    return;
  }

  void onMultiMediaPicker() async {
    if (state.activeButton == PositivePostNavigationActiveButton.clip) {
      onSingleVideoPicker();
    } else {
      onMultiImagePicker();
    }
  }

  Future<void> onSingleVideoPicker() async {
    final logger = ref.read(loggerProvider);
    final ImagePicker picker = ref.read(imagePickerProvider);

    try {
      logger.d("[ProfilePhotoViewModel] onImagePicker [start]");
      state = state.copyWith(isBusy: true);

      final XFile? media = await picker.pickVideo(source: ImageSource.gallery);
      if (media == null) {
        logger.w("onMultiImagePicker: image list is empty");
        return;
      }

      await onVideoEditRequest(media);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onMultiImagePicker() async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final logger = ref.read(loggerProvider);
    final ImagePicker picker = ref.read(imagePickerProvider);
    final GalleryController galleryController = ref.read(galleryControllerProvider.notifier);

    logger.d("[ProfilePhotoViewModel] onImagePicker [start]");
    state = state.copyWith(isBusy: true);

    try {
      final List<XFile> media = await picker.pickMultiImage();
      if (media.isEmpty) {
        logger.d("onMultiImagePicker: image list is empty");
        return;
      }

      final List<GalleryEntry> entries = await Future.wait(
        media.map(
          (XFile image) => galleryController.createGalleryEntryFromXFile(image, uploadImmediately: false, store: state.allowSharing),
        ),
      );

      if (entries.isEmpty) {
        logger.d("onMultiImagePicker: entries list is empty");
        return;
      }

      final bool isMultiImage = entries.length > 1;

      if (isMultiImage) {
        state = state.copyWith(
          isBusy: false,
          galleryEntries: entries,
          editingGalleryEntry: entries.firstOrNull,
          currentCreatePostPage: CreatePostCurrentPage.createPostMultiImage,
          currentPostType: PostType.multiImage,
          activeButton: PositivePostNavigationActiveButton.flex,
          activeButtonFlexText: localisations.page_create_post_create,
        );
      } else {
        state = state.copyWith(
          isBusy: false,
          galleryEntries: entries,
          editingGalleryEntry: entries.firstOrNull,
          currentCreatePostPage: CreatePostCurrentPage.editPhoto,
          currentPostType: PostType.image,
          activeButton: PositivePostNavigationActiveButton.flex,
          activeButtonFlexText: localisations.shared_actions_done,
        );
      }
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onFilterSelected(AwesomeFilter filter) {
    state = state.copyWith(currentFilter: filter);
  }

  Future<void> stopClipRecordingAndProcessResult() async {
    //? temp removed due to ios issue
    // await currentPositiveCameraState?.onPauseResumeClip(forcePause: false);
    // await currentPositiveCameraState?.stopClipRecording();
    await currentPositiveCameraState?.attemptProcessVideoResult();
  }

  void onGalleryEntrySelected(GalleryEntry entry) {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final logger = ref.read(loggerProvider);

    final String fileName = entry.fileName;
    final bool isCurrentlySelected = state.editingGalleryEntry?.fileName == fileName;

    if (!isCurrentlySelected) {
      logger.d("onGalleryEntrySelected: $fileName");
      state = state.copyWith(editingGalleryEntry: entry);
      return;
    }

    state = state.copyWith(
      editingGalleryEntry: entry,
      currentCreatePostPage: CreatePostCurrentPage.editPhoto,
      activeButtonFlexText: localisations.shared_actions_done,
    );
  }

  Future<void> onPostFinished(Profile? currentProfile) async {
    final logger = ref.read(loggerProvider);
    if (state.isBusy) {
      logger.w("Attempted to post while busy");
      return;
    }

    if (currentProfile == null) {
      logger.e("Profile ID is null, cannot post");
      return;
    }

    final Iterable<String> taggedUsers = captionController.text.getHandles(includeHandle: false);

    try {
      final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);
      state = state.copyWith(isBusy: true, isUploadingMedia: state.galleryEntries.isNotEmpty, isCreatingPost: true);

      final List<GalleryEntry> galleryEntries = [...state.galleryEntries];
      for (final GalleryEntry entry in galleryEntries) {
        entry.saveToGallery = state.saveToGallery;
      }

      // Upload gallery entries
      List<Media> media = [];
      if (state.isEditingPost) {
        media = state.currentActivityMedia;
      } else {
        media = await Future.wait(galleryEntries.map(
          (e) => e.createMedia(
            filter: state.currentFilter,
            altText: altTextController.text.trim(),
            mimeType: e.mimeType ?? "",
          ),
        ));
      }

      // If we are editing, and have any media; then we need to reattach it and not upload it again

      late final ActivityData activityData;
      if (state.isEditingPost) {
        activityData = ActivityData(
          activityID: state.currentActivityID,
          content: captionController.text.trim(),
          altText: altTextController.text.trim(),
          promotionKey: promotionKeyTextController.text.trim(),
          tags: state.tags,
          postType: state.currentPostType,
          media: media,
          allowSharing: state.allowSharing,
          commentPermissionMode: state.allowComments,
          visibilityMode: state.visibleTo,
          mentions: taggedUsers.map((e) => Mention.fromDisplayName(e)).toList(),
        );
      } else {
        activityData = ActivityData(
          content: captionController.text.trim(),
          altText: altTextController.text.trim(),
          promotionKey: promotionKeyTextController.text.trim(),
          tags: state.tags,
          postType: state.currentPostType,
          media: media,
          allowSharing: state.allowSharing,
          commentPermissionMode: state.allowComments,
          visibilityMode: state.visibleTo,
          reposterActivityID: state.reposterActivityID,
          mentions: taggedUsers.map((e) => Mention.fromDisplayName(e)).toList(),
        );
      }

      // Prevent sharing of reposts (for now)
      if (activityData.postType == PostType.repost) {
        activityData.allowSharing = false;
      }

      if (!state.isEditingPost) {
        await activityController.postActivity(
          currentProfile: currentProfile,
          activityData: activityData,
        );
      } else {
        await activityController.editActivity(
          currentProfile: currentProfile,
          activityData: activityData,
        );
      }

      await onPostActivitySuccess();
    } catch (e) {
      logger.e("Error posting activity: $e");
      await onPostActivityFailure(e);
      return;
    } finally {
      state = state.copyWith(isBusy: false, isUploadingMedia: false, isCreatingPost: false);
    }
  }

  Future<void> onPostActivitySuccess() async {
    final AppRouter router = ref.read(appRouterProvider);
    final AppLocalizations localisations = AppLocalizations.of(router.navigatorKey.currentContext!)!;
    final logger = ref.read(loggerProvider);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));

    logger.i("Attempted to ${state.isEditingPost ? "edit" : "create"} post, Pop Create Post page, push Home page");

    final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
      title: state.isEditingPost ? localisations.page_create_post_edited : localisations.page_create_post_created,
      icon: UniconsLine.plus_circle,
      backgroundColour: colours.black,
    );

    router.removeLast();

    // Wait for the page to pop before pushing the snackbar
    await Future.delayed(kAnimationDurationEntry);
    if (router.navigatorKey.currentContext != null) {
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(router.navigatorKey.currentContext!);
      messenger.showSnackBar(snackBar);
    }
  }

  Future<void> onPostActivityFailure(Object? exception) async {
    final AppRouter router = ref.read(appRouterProvider);
    final logger = ref.read(loggerProvider);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));

    logger.e("Error posting activity: $exception");
    final bool alreadyExists = exception is FirebaseException && exception.code == "already-exists";

    late final PositiveSnackBar snackBar;

    if (alreadyExists) {
      snackBar = PositiveGenericSnackBar(
        title: "No update required",
        icon: UniconsLine.envelope_exclamation,
        backgroundColour: colours.black,
      );
    } else {
      snackBar = PositiveErrorSnackBar(
        text: "Post ${state.isEditingPost ? "Edit" : "Creation"} Failed",
      );
    }

    if (router.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
    }
  }
}
