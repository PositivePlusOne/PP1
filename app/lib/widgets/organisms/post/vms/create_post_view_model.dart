// Dart imports:
import 'dart:io' as io;

// Flutter imports:
import 'package:app/dtos/system/design_typography_model.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/services/clip_ffmpeg_service.dart';
import 'package:app/widgets/organisms/post/component/positive_discard_clip_dialogue.dart';
import 'package:app/widgets/organisms/post/create_post_page.dart';
import 'package:app/widgets/organisms/shared/positive_camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:io' as io;

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
import 'package:app/widgets/organisms/post/create_post_tag_dialogue.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
import 'package:video_editor/video_editor.dart';
import '../../../../services/third_party.dart';

// Project imports:

part 'create_post_view_model.freezed.dart';
part 'create_post_view_model.g.dart';

@freezed
class CreatePostViewModelState with _$CreatePostViewModelState {
  const factory CreatePostViewModelState({
    @Default(false) bool isBusy,
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
    required ActivityData previousActivity,
    //? Clip delay and clip length options
    @Default(0) int delayTimerCurrentSelection,
    @Default(false) bool isDelayTimerEnabled,
    @Default(0) int maximumClipDurationSelection,
    @Default(false) bool isMaximumClipDurationEnabled,
    @Default(true) bool isBottomNavigationEnabled,
    @Default(false) bool isCreatingClip,
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

  PositiveCameraState get getCurrentCameraState {
    return state.cameraWidgetKey.currentState as PositiveCameraState;
  }

  @override
  CreatePostViewModelState build() {
    return CreatePostViewModelState.initialState();
  }

  Future<bool> onWillPopScope(BuildContext context) async {
    bool canPop = (state.currentCreatePostPage == CreatePostCurrentPage.camera || state.isEditing);

    //? if we are currently creating a clip request that we stop
    if (state.isCreatingClip) {
      if (state.currentCreatePostPage == CreatePostCurrentPage.camera) {
        getCurrentCameraState.onCloseButtonTapped();
        return false;
      } else {
        final DesignColorsModel colors = ref.read(designControllerProvider.select((value) => value.colors));
        final DesignTypographyModel typography = ref.read(designControllerProvider.select((value) => value.typography));
        canPop = !await positiveDiscardClipDialogue(
          context: context,
          colors: colors,
          typography: typography,
        );
      }
    }

    if (!canPop) {
      late PostType postType;
      switch (state.lastActiveButton) {
        case PositivePostNavigationActiveButton.post:
          postType = PostType.text;
          break;
        case PositivePostNavigationActiveButton.clip:
          postType = PostType.clip;
          break;
        case PositivePostNavigationActiveButton.event:
          break;
        default:
          postType = PostType.event;
      }

      state = state.copyWith(
        currentCreatePostPage: CreatePostCurrentPage.camera,
        currentPostType: postType,
        activeButton: state.lastActiveButton,
      );
    }

    return canPop;
  }

  Future<void> initCamera(BuildContext context) async {
    state = state.copyWith(
      currentCreatePostPage: CreatePostCurrentPage.camera,
      currentPostType: PostType.image,
      activeButton: PositivePostNavigationActiveButton.post,
    );
  }

  Future<void> loadActivityData(BuildContext context, ActivityData activityData) async {
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
        case PostType.event:
        case PostType.clip:
        default:
          currentPage = CreatePostCurrentPage.createPostText;
          currentPostType = PostType.text;
          break;
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

  Future<void> onPostFinished(BuildContext context, Profile? currentProfile) async {
    if (state.isBusy) {
      return;
    }

    final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    if (currentProfile == null) {
      logger.e("Profile ID is null, cannot post");
      return;
    }

    state = state.copyWith(isBusy: true);

    try {
      final List<GalleryEntry> galleryEntries = [...state.galleryEntries];
      for (final GalleryEntry entry in galleryEntries) {
        entry.saveToGallery = state.saveToGallery;
      }

      // Upload gallery entries
      final List<Media> media = await Future.wait(galleryEntries.map(
        (e) => e.createMedia(
          filter: state.currentFilter,
          altText: altTextController.text.trim(),
        ),
      ));

      if (!state.isEditing) {
        await activityController.postActivity(
          currentProfile: currentProfile,
          activityData: ActivityData(
            content: captionController.text.trim(),
            altText: altTextController.text.trim(),
            promotionKey: promotionKeyTextController.text.trim(),
            tags: state.tags,
            postType: state.currentPostType,
            media: media,
            allowSharing: state.allowSharing,
            commentPermissionMode: state.allowComments,
            visibilityMode: state.visibleTo,
          ),
        );
      } else {
        await activityController.updateActivity(
          currentProfile: currentProfile,
          activityData: ActivityData(
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
          ),
        );
      }
    } catch (e) {
      logger.e("Error posting activity: $e");
      final bool alreadyExists = e is FirebaseException && e.code == "already-exists";

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

      state = state.copyWith(isBusy: false);
      return;
    }

    logger.i("Attempted to ${state.isEditing ? "edit" : "create"} post, Pop Create Post page, push Home page");

    final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
      title: state.isEditing ? localisations.page_create_post_edited : localisations.page_create_post_created,
      icon: UniconsLine.plus_circle,
      backgroundColour: colours.black,
    );

    state = state.copyWith(isBusy: false);
    router.removeLast();

    // Wait for the page to pop before pushing the snackbar
    await Future.delayed(kAnimationDurationEntry);
    if (router.navigatorKey.currentContext != null) {
      final ScaffoldMessengerState messenger = ScaffoldMessenger.of(router.navigatorKey.currentContext!);
      messenger.showSnackBar(snackBar);
    }
  }

  Future<void> onTagsPressed(BuildContext context) async {
    final TagsController tagsController = ref.read(tagsControllerProvider.notifier);

    List<String>? newTags = await showGeneralDialog<List<String>>(
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

  void onUpdateSaveToGallery(BuildContext context) {
    state = state.copyWith(saveToGallery: !state.saveToGallery);
  }

  void onUpdateAllowSharing(BuildContext context) {
    state = state.copyWith(allowSharing: !state.allowSharing);
  }

  void onUpdatePromotePost(BuildContext context, String userId) {
    // get the current tags
    final newTags = [...state.tags];
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

  void showCreateTextPost(BuildContext context) {
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

  final List<int> maximumClipDurationOptions = [180000, 90000, 60000, 30000, 10000];

  void onClipDurationChanged(int index) {
    state = state.copyWith(
      maximumClipDurationSelection: index,
    );
  }

  String clipDurationString(BuildContext context, int duration) {
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    if (duration >= 120000) {
      return "${duration ~/ 60000}${localisations.page_create_post_minuets}";
    }

    return "${duration ~/ 1000}${localisations.page_create_post_seconds}";
  }

  /// Call to update main create post page UI
  void onClipStateChange(BuildContext context, ClipRecordingState clipRecordingState) {
    /// Called whenever clip begins or ends recording, returns true when begining, returns false when ending
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    state = state.copyWith(
      isBottomNavigationEnabled: clipRecordingState.isNotRecordingOrPaused,
      isCreatingClip: clipRecordingState.isActive,
      activeButton: clipRecordingState.isInactive ? PositivePostNavigationActiveButton.clip : PositivePostNavigationActiveButton.flex,
      activeButtonFlexText: localisations.shared_actions_next,
      lastActiveButton: PositivePostNavigationActiveButton.clip,
    );
  }

  void onTimerToggleRequest() {
    state = state.copyWith(isDelayTimerEnabled: !state.isDelayTimerEnabled);
  }

  //? Create video Post here
  Future<void> onVideoTaken(BuildContext context, XFile xFile) async {
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    final io.File file = io.File(xFile.path);

    videoEditorController = VideoEditorController.file(
      file,
      minDuration: const Duration(seconds: 1),
      maxDuration: const Duration(seconds: 180),
    );

    state = state.copyWith(
      currentCreatePostPage: CreatePostCurrentPage.createPostEditClip,
      currentPostType: PostType.clip,
      isCreatingClip: true,
      activeButton: PositivePostNavigationActiveButton.flex,
      activeButtonFlexText: localisations.shared_actions_next,
      isBottomNavigationEnabled: true,
      lastActiveButton: PositivePostNavigationActiveButton.clip,
    );
  }

  Future<void> onClipEditFinish(BuildContext context) async {
    CreateClipExportService exportService = CreateClipExportService();

    if (videoEditorController == null) {
      //TODO crash with grace here
      return;
    }

    exportService.exportVideoFromController(
      videoEditorController!,
      (file) => onClipEditProcessConcluded(
        context,
        file,
        Size(
          videoEditorController?.videoWidth ?? 640,
          videoEditorController?.videoHeight ?? 640,
        ),
      ),
    );
  }

  Future<void> onClipEditProcessConcluded(BuildContext context, io.File file, Size size) async {
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
  Future<void> onImageTaken(BuildContext context, XFile file) async {
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

  void onMultiImagePicker(BuildContext context) async {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final Logger logger = ref.read(loggerProvider);
    final ImagePicker picker = ref.read(imagePickerProvider);
    final GalleryController galleryController = ref.read(galleryControllerProvider.notifier);

    logger.d("[ProfilePhotoViewModel] onImagePicker [start]");
    state = state.copyWith(isBusy: true);

    try {
      final List<XFile> images = await picker.pickMultiImage();
      if (images.isEmpty) {
        logger.d("onMultiImagePicker: image list is empty");
        return;
      }

      final List<GalleryEntry> entries = await Future.wait(
        images.map(
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

  Future<void> onPostPressed(BuildContext context) async {
    state = state.copyWith(
      activeButton: PositivePostNavigationActiveButton.post,
      lastActiveButton: PositivePostNavigationActiveButton.post,
      currentPostType: PostType.image,
    );
  }

  Future<void> onClipPressed(BuildContext context) async {
    state = state.copyWith(
      activeButton: PositivePostNavigationActiveButton.clip,
      lastActiveButton: PositivePostNavigationActiveButton.clip,
      currentPostType: PostType.clip,
    );
  }

  Future<void> onEventPressed(BuildContext context) async {
    state = state.copyWith(
      activeButton: PositivePostNavigationActiveButton.event,
      lastActiveButton: PositivePostNavigationActiveButton.event,
      currentPostType: PostType.event,
    );
  }

  Future<void> onFlexButtonPressed(BuildContext context) async {
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
        state = state.copyWith(
          currentCreatePostPage: CreatePostCurrentPage.createPostClip,
          activeButtonFlexText: localisations.page_create_post_create,
        );
        await onClipEditFinish(context);
        break;
      case CreatePostCurrentPage.createPostClip:
      case CreatePostCurrentPage.createPostText:
      case CreatePostCurrentPage.createPostImage:
      case CreatePostCurrentPage.createPostMultiImage:
        await onPostFinished(context, profileController.currentProfile);
        break;
    }
  }

  void onGalleryEntrySelected(BuildContext context, GalleryEntry entry) {
    final Logger logger = ref.read(loggerProvider);
    final String fileName = entry.fileName;
    final bool isCurrentlySelected = state.editingGalleryEntry?.fileName == fileName;
    final AppLocalizations localisations = AppLocalizations.of(context)!;

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
