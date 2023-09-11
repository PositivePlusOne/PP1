// Flutter imports:
import 'package:flutter/material.dart';

// Package imports:
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:event_bus/event_bus.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/content/activities_controller.dart';
import 'package:app/providers/content/dtos/gallery_entry.dart';
import 'package:app/providers/content/gallery_controller.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/profiles/tags_controller.dart';
import 'package:app/providers/system/design_controller.dart';
import 'package:app/widgets/atoms/indicators/positive_snackbar.dart';
import 'package:app/widgets/organisms/post/create_post_tag_dialogue.dart';
import 'package:app/widgets/organisms/post/vms/create_post_data_structures.dart';
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
    @Default(false) bool allowSharing,
    @Default(ActivitySecurityConfigurationMode.public()) @JsonKey(fromJson: ActivitySecurityConfigurationMode.fromJson, toJson: ActivitySecurityConfigurationMode.toJson) ActivitySecurityConfigurationMode visibleTo,
    @Default(ActivitySecurityConfigurationMode.signedIn()) @JsonKey(fromJson: ActivitySecurityConfigurationMode.fromJson, toJson: ActivitySecurityConfigurationMode.toJson) ActivitySecurityConfigurationMode allowComments,
    @Default("") String activeButtonFlexText,
    @Default(false) bool saveToGallery,
    required AwesomeFilter currentFilter,
    @Default(PositivePostNavigationActiveButton.post) PositivePostNavigationActiveButton activeButton,
  }) = _CreatePostViewModelState;

  factory CreatePostViewModelState.initialState() => CreatePostViewModelState(
        currentFilter: AwesomeFilter.None,
      );
}

@riverpod
class CreatePostViewModel extends _$CreatePostViewModel {
  final TextEditingController captionController = TextEditingController();
  final TextEditingController altTextController = TextEditingController();

  @override
  CreatePostViewModelState build() {
    return CreatePostViewModelState.initialState();
  }

  Future<bool> onWillPopScope() async {
    final bool canPop = state.currentCreatePostPage == CreatePostCurrentPage.camera || state.isEditing;
    if (!canPop) {
      state = state.copyWith(
        currentCreatePostPage: CreatePostCurrentPage.camera,
        currentPostType: PostType.text,
        activeButton: PositivePostNavigationActiveButton.post,
      );
    }

    return canPop;
  }

  Future<void> initCamera(BuildContext context) async {
    state = state.copyWith(
      currentCreatePostPage: CreatePostCurrentPage.camera,
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

      //? State is updated in two steps, otherwise the camera can breifly activate on the edit page due to the asynchronus fucnctions required for gallery
      state = state.copyWith(
        currentActivityID: activityData.activityID ?? "",
        isEditing: true,
        tags: activityData.tags ?? [],
        allowSharing: activityData.allowSharing ?? false,
        allowComments: activityData.commentPermissionMode ?? const ActivitySecurityConfigurationMode.signedIn(),
        visibleTo: activityData.visibilityMode ?? const ActivitySecurityConfigurationMode.public(),
        currentCreatePostPage: currentPage,
        currentPostType: currentPostType,
        activeButton: PositivePostNavigationActiveButton.flex,
        activeButtonFlexText: localisations.post_dialogue_update_post,
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

  Future<void> onPostFinished(BuildContext context) async {
    if (state.isBusy) {
      return;
    }

    final EventBus eventBus = ref.read(eventBusProvider);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);
    final ActivitiesController activityController = ref.read(activitiesControllerProvider.notifier);
    final DesignColorsModel colours = providerContainer.read(designControllerProvider.select((value) => value.colors));
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);
    late final Activity activity;

    if (profileController.currentProfileId == null) {
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
        activity = await activityController.postActivity(
          activityData: ActivityData(
            content: captionController.text.trim(),
            altText: altTextController.text.trim(),
            tags: state.tags,
            postType: state.currentPostType,
            media: media,
            allowSharing: state.allowSharing,
            commentPermissionMode: state.allowComments,
            visibilityMode: state.visibleTo,
          ),
        );
      } else {
        activity = await activityController.updateActivity(
          activityData: ActivityData(
            activityID: state.currentActivityID,
            content: captionController.text.trim(),
            altText: altTextController.text.trim(),
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

    final List<TargetFeed> targets = <TargetFeed>[
      TargetFeed('user', profileController.currentProfileId!),
      TargetFeed('timeline', profileController.currentProfileId!),
      ...activity.tagTargetFeeds,
    ];

    if (state.isEditing) {
      eventBus.fire(ActivityUpdatedEvent(targets: targets, activity: activity));
    } else {
      eventBus.fire(ActivityCreatedEvent(targets: targets, activity: activity));
    }

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

  void onUpdateVisibleTo(ActivitySecurityConfigurationMode mode) {
    state = state.copyWith(visibleTo: mode);
  }

  void onUpdateAllowComments(ActivitySecurityConfigurationMode mode) {
    state = state.copyWith(allowComments: mode);
  }

  bool get isNavigationEnabled {
    switch (state.currentCreatePostPage) {
      case CreatePostCurrentPage.createPostText:
      case CreatePostCurrentPage.createPostImage:
        if (captionController.text.isNotEmpty) {
          return true;
        } else {
          return false;
        }
      case CreatePostCurrentPage.camera:
      default:
        return true;
    }
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
          (XFile image) => galleryController.createGalleryEntryFromXFile(
            image,
            uploadImmediately: false,
            store: state.allowSharing,
          ),
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

  Future<void> onFlexButtonPressed(BuildContext context) async {
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    switch (state.currentCreatePostPage) {
      case CreatePostCurrentPage.entry:
        break;
      case CreatePostCurrentPage.camera:
        throw Exception("Cannot press flex button on camera page");
      case CreatePostCurrentPage.editPhoto:
        state = state.copyWith(
          currentCreatePostPage: CreatePostCurrentPage.createPostImage,
          activeButtonFlexText: localisations.page_create_post_create,
        );
        break;
      case CreatePostCurrentPage.createPostText:
      case CreatePostCurrentPage.createPostImage:
      case CreatePostCurrentPage.createPostMultiImage:
        await onPostFinished(context);
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
