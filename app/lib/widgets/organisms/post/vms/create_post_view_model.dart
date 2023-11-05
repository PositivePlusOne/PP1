// Dart imports:
import 'dart:io' as io;
import 'dart:io';

// Flutter imports:
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unicons/unicons.dart';
import 'package:video_editor/video_editor.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/activities/tags.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/database/profile/profile.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/content/dtos/gallery_entry.dart';
import 'package:app/providers/content/gallery_controller.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/services/clip_ffmpeg_service.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/organisms/post/component/positive_discard_clip_dialogue.dart';
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
    @Default(PostType.image) PostType currentPostType,
    @Default(CreatePostCurrentPage.entry) CreatePostCurrentPage currentCreatePostPage,
    @Default(false) bool isEditing,
    @Default('') String currentActivityID,
    @Default([]) List<GalleryEntry> galleryEntries,
    GalleryEntry? editingGalleryEntry,
    @Default([]) List<String> tags,
    @Default('') String promotionKey,
    @Default(false) bool allowSharing,
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
class CreatePostViewModel extends _$CreatePostViewModel {
  final TextEditingController captionController = TextEditingController();
  final TextEditingController altTextController = TextEditingController();
  final TextEditingController promotionKeyTextController = TextEditingController();

  VideoEditorController? videoEditorController;
  io.File? uneditedVideoFile;

  PositiveCameraState get getCurrentCameraState {
    return state.cameraWidgetKey.currentState as PositiveCameraState;
  }

  @override
  CreatePostViewModelState build() {
    return CreatePostViewModelState.initialState();
  }

  Future<bool> onForceClosePage() async {
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    bool canPop = false;
    if (state.isRecordingClip) {
      canPop = await getCurrentCameraState.onCloseButtonTapped();
    }
    if (state.currentCreatePostPage == CreatePostCurrentPage.createPostEditClip) {
      final AppRouter router = ref.read(appRouterProvider);
      final BuildContext context = router.navigatorKey.currentContext!;
      final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
      final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
      canPop = await positiveDiscardClipDialogue(
        context: context,
        colors: colors,
        typography: typography,
      );
    }

    if (canPop) {
      logger.i("Pop Search page, push Home page");
      router.popUntil((_) => !router.stack.any((route) => route.name == CreatePostRoute.name));
    }

    return false;
  }

  Future<bool> onWillPopScope() async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    //? If we are on the entry page, allow the user to pop scope, taking them to their last page
    if (state.currentCreatePostPage == CreatePostCurrentPage.entry) {
      return true;
    }

    //? If we are handling the pop ourselves, we need to return to the correct page
    //? postType tells us which tab to go back to on the camera page
    late PostType postType;
    late CreatePostCurrentPage pageToNavigateTo;
    late PositivePostNavigationActiveButton activeButton;
    late String activeButtonFlexText;

    switch (state.currentCreatePostPage) {
      case CreatePostCurrentPage.entry:
      case CreatePostCurrentPage.repostPreview:
        return true;
      case CreatePostCurrentPage.camera:
        if (state.isRecordingClip) {
          //! If we are on an ios device during clip recording, return to the hub page
          //! This is a workaround due to an error in the camera software state
          final BaseDeviceInfo deviceInfo = await ref.read(deviceInfoProvider.future);
          if (deviceInfo is IosDeviceInfo) {
            onForceClosePage();
            return false;
          }

    //? Only do this if we are on the edit clip page, as the camera is no longer mounted at that point
    if (state.currentCreatePostPage == CreatePostCurrentPage.createPostEditClip) {
      final AppRouter router = ref.read(appRouterProvider);
      final BuildContext context = router.navigatorKey.currentContext!;
      final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
      final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
      //? this is required here as the version within the camera will not be mounted on this page
      canPop = !await positiveDiscardClipDialogue(
        context: context,
        colors: colors,
        typography: typography,
      );
    }

    final bool isCreatingRepost = state.currentPostType == PostType.repost;
    final bool isShowingRepostPreview = state.currentCreatePostPage == CreatePostCurrentPage.repostPreview;
    if (isShowingRepostPreview) {
      return true;
    }

    // The only other page in this process is the creation screen on the repost, so we can just pop back to the repost preview
    if (isCreatingRepost) {
      final AppRouter router = ref.read(appRouterProvider);
      final BuildContext context = router.navigatorKey.currentContext!;
      final AppLocalizations localisations = AppLocalizations.of(context)!;

      state = state.copyWith(
        currentCreatePostPage: CreatePostCurrentPage.repostPreview,
        currentPostType: PostType.repost,
        activeButton: PositivePostNavigationActiveButton.flex,
        activeButtonFlexText: localisations.page_create_post_create,
      );

      return false;
    }

    if (!canPop) {
      late PostType postType;
      switch (state.lastActiveButton) {
        case PositivePostNavigationActiveButton.post:
          postType = PostType.text;
          break;
        case PositivePostNavigationActiveButton.clip:
          postType = PostType.clip;
          pageToNavigateTo = CreatePostCurrentPage.createPostEditClip;
          activeButton = state.lastActiveButton;
          activeButtonFlexText = localisations.shared_actions_next;
        } else {
          postType = PostType.image;
          pageToNavigateTo = CreatePostCurrentPage.camera;
          activeButton = state.lastActiveButton;
          activeButtonFlexText = localisations.shared_actions_next;
        }
        postType = PostType.clip;
        pageToNavigateTo = CreatePostCurrentPage.createPostEditClip;
        activeButton = PositivePostNavigationActiveButton.flex;
        activeButtonFlexText = localisations.shared_actions_next;
      case CreatePostCurrentPage.createPostImage:
        postType = PostType.image;
        pageToNavigateTo = CreatePostCurrentPage.editPhoto;
        activeButton = PositivePostNavigationActiveButton.flex;
        activeButtonFlexText = localisations.shared_actions_next;
      case CreatePostCurrentPage.createPostEditClip:
        final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
        final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
        //? Discard Dialogue is required here as the version within the camera will not be mounted at this point
        final bool discardClip = await positiveDiscardClipDialogue(
          context: context,
          colors: colors,
          typography: typography,
        );
        if (discardClip) {
          postType = PostType.clip;
          pageToNavigateTo = CreatePostCurrentPage.camera;
          activeButton = state.lastActiveButton;
          activeButtonFlexText = localisations.shared_actions_next;
        } else {
          return false;
        }
      case CreatePostCurrentPage.editPhoto:
      case CreatePostCurrentPage.createPostMultiImage:
      case CreatePostCurrentPage.createPostText:
      default:
        postType = PostType.image;
        pageToNavigateTo = CreatePostCurrentPage.camera;
        activeButton = state.lastActiveButton;
        activeButtonFlexText = localisations.shared_actions_next;
    }

    state = state.copyWith(
      currentCreatePostPage: pageToNavigateTo,
      currentPostType: postType,
      activeButton: activeButton,
      activeButtonFlexText: activeButtonFlexText,
      isBottomNavigationEnabled: true,
    );

    return false;
  }

  Future<void> initCamera() async {
    state = state.copyWith(
      currentCreatePostPage: CreatePostCurrentPage.camera,
      currentPostType: PostType.image,
      activeButton: PositivePostNavigationActiveButton.post,
    );
  }

  Future<void> loadActivityData(ActivityData activityData) async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final Logger logger = ref.read(loggerProvider);

    state = state.copyWith(isBusy: true);

    try {
      late final CreatePostCurrentPage currentPage;
      late final PostType currentPostType;

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
          currentPostType = PostType.repost;
          break;
        case PostType.event:
        case PostType.clip:
        default:
          currentPage = CreatePostCurrentPage.createPostText;
          currentPostType = PostType.text;
          break;
      }

      // If the post is a repost, we have no data so we can skip this
      if (activityData.postType == PostType.repost) {
        state = state.copyWith(
          currentCreatePostPage: currentPage,
          currentPostType: currentPostType,
          reposterActivityID: activityData.reposterActivityID,
          activeButton: PositivePostNavigationActiveButton.flex,
          activeButtonFlexText: localisations.page_create_post_create,
          previousActivity: activityData,
        );

        return;
      }

      captionController.text = activityData.content ?? "";
      altTextController.text = activityData.altText ?? "";
      promotionKeyTextController.text = activityData.promotionKey ?? "";

      //? State is updated in two steps, otherwise the camera can breifly activate on the edit page due to the asynchronus fucnctions required for gallery
      state = state.copyWith(
        currentActivityID: activityData.activityID ?? "",
        isEditing: true,
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

  Future<void> onPostFinished(Profile? currentProfile) async {
    final Logger logger = ref.read(loggerProvider);
    if (state.isBusy) {
      logger.w("Attempted to post while busy");
      return;
    }

    if (currentProfile == null) {
      logger.e("Profile ID is null, cannot post");
      return;
    }

    try {
      final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);
      state = state.copyWith(isBusy: true, isUploadingMedia: state.galleryEntries.isNotEmpty, isCreatingPost: true);

      final List<GalleryEntry> galleryEntries = [...state.galleryEntries];
      for (final GalleryEntry entry in galleryEntries) {
        entry.saveToGallery = state.saveToGallery;
      }

      // Upload gallery entries
      final List<Media> media = await Future.wait(galleryEntries.map(
        (e) => e.createMedia(
          filter: state.currentFilter,
          altText: altTextController.text.trim(),
          mimeType: e.mimeType ?? "",
        ),
      ));

      late final ActivityData activityData;

      if (state.isEditing) {
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
        );
      }

      // Prevent sharing of reposts (for now)
      if (activityData.postType == PostType.repost) {
        activityData.allowSharing = false;
      }

      if (!state.isEditing) {
        await activityController.postActivity(
          currentProfile: currentProfile,
          activityData: activityData,
        );
      } else {
        await activityController.updateActivity(
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
    final Logger logger = ref.read(loggerProvider);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));

    logger.i("Attempted to ${state.isEditing ? "edit" : "create"} post, Pop Create Post page, push Home page");

    final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
      title: state.isEditing ? localisations.page_create_post_edited : localisations.page_create_post_created,
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
    final Logger logger = ref.read(loggerProvider);
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
        text: "Post ${state.isEditing ? "Edit" : "Creation"} Failed",
      );
    }

    if (router.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
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
    final bool hasChanged = state.isEditing ? hasPostBeenUpdated : true;

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

    /// Called whenever clip begins or ends recording, returns true when begining, returns false when ending
    state = state.copyWith(
      isBottomNavigationEnabled: clipRecordingState.isNotRecordingOrPaused,
      isRecordingClip: clipRecordingState.isActive,
      activeButton: clipRecordingState.isInactive ? PositivePostNavigationActiveButton.clip : PositivePostNavigationActiveButton.flex,
      activeButtonFlexText: localisations.shared_actions_next,
      lastActiveButton: PositivePostNavigationActiveButton.clip,
    );
  }

  void onTimerToggleRequest() {
    state = state.copyWith(isDelayTimerEnabled: !state.isDelayTimerEnabled);
  }

  //? Create video Post here
  Future<void> onVideoTaken(XFile xFile) async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    uneditedVideoFile = io.File(xFile.path);

    videoEditorController = VideoEditorController.file(
      uneditedVideoFile!,
      minDuration: const Duration(seconds: 1),
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
    final Logger logger = ref.read(loggerProvider);
    if (videoEditorController == null) {
      logger.e("Video editor controller is null, cannot export clip");
      return Future.error("Video editor controller is null, cannot export clip");
    }

    final CreateClipExportService exportService = ref.read(createClipExportServiceProvider);
    final File outputFile = await exportService.exportVideoFromController(videoEditorController!);
    final Size size = await exportService.getVideoSize(outputFile);

    return (file: outputFile, size: size);
  }

  Future<void> onClipExported(io.File file, Size size) async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final GalleryController galleryController = ref.read(galleryControllerProvider.notifier);

    // final XFile xFile = XFile.fromData(await file.readAsBytes());
    final XFile xFile = XFile(file.path);
    final List<GalleryEntry> entries = [];

    if (file.path.isNotEmpty) {
      final GalleryEntry entry = await galleryController.createGalleryEntryFromXFile(xFile, uploadImmediately: false, size: size);
      entries.add(entry);
    }

    if (entries.isEmpty) {
      return;
    }

    state = state.copyWith(
      galleryEntries: entries,
      currentCreatePostPage: CreatePostCurrentPage.createPostClip,
      editingGalleryEntry: entries.firstOrNull,
      currentPostType: PostType.clip,
      activeButton: PositivePostNavigationActiveButton.flex,
      activeButtonFlexText: localisations.shared_actions_next,
    );

    return;
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
    final Logger logger = ref.read(loggerProvider);
    final ImagePicker picker = ref.read(imagePickerProvider);

    logger.d("[ProfilePhotoViewModel] onImagePicker [start]");
    state = state.copyWith(isBusy: true);

    try {
      final XFile? media = await picker.pickVideo(source: ImageSource.gallery);
      if (media == null) {
        logger.d("onMultiImagePicker: image list is empty");
        return;
      }
      onVideoTaken(media);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  void onMultiImagePicker() async {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final Logger logger = ref.read(loggerProvider);
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

  Future<void> onPostPressed() async {
    state = state.copyWith(
      activeButton: PositivePostNavigationActiveButton.post,
      lastActiveButton: PositivePostNavigationActiveButton.post,
      currentPostType: PostType.image,
    );
  }

  Future<void> onClipPressed() async {
    state = state.copyWith(
      activeButton: PositivePostNavigationActiveButton.clip,
      lastActiveButton: PositivePostNavigationActiveButton.clip,
      currentPostType: PostType.clip,
    );
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
        getCurrentCameraState.finishClipRecordingImmediately();
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
          final ({io.File file, Size size}) completer = await onClipEditFinish();
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
        await onPostFinished(profileController.currentProfile);
        break;
    }
  }

  void onGalleryEntrySelected(GalleryEntry entry) {
    final AppRouter router = ref.read(appRouterProvider);
    final BuildContext context = router.navigatorKey.currentContext!;
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final Logger logger = ref.read(loggerProvider);

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
}
