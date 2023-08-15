// ignore_for_file: avoid_public_notifier_properties
// Dart imports:

// Flutter imports:
import 'package:app/constants/design_constants.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:event_bus/event_bus.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/dtos/database/common/media.dart';
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/activities/activities_controller.dart';
import 'package:app/providers/activities/dtos/gallery_entry.dart';
import 'package:app/providers/activities/gallery_controller.dart';
import 'package:app/providers/content/tags_controller.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/profiles/profile_controller.dart';
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
    @Default(CreatePostCurrentPage.camera) CreatePostCurrentPage currentCreatePostPage,
    @Default(false) bool isEditing,
    @Default('') String currentActivityID,
    @Default([]) List<GalleryEntry> galleryEntries,
    @Default([]) List<String> tags,
    @Default("") String visibleTo,
    @Default("") String allowComments,
    @Default("") String activeButtonFlexText,
    @Default(false) bool allowSharing,
    @Default(false) bool saveToGallery,
    @Default(PositivePostNavigationActiveButton.post) PositivePostNavigationActiveButton activeButton,
  }) = _CreatePostViewModelState;

  factory CreatePostViewModelState.initialState() => const CreatePostViewModelState();
}

@riverpod
class CreatePostViewModel extends _$CreatePostViewModel {
  final TextEditingController captionController = TextEditingController();
  final TextEditingController altTextController = TextEditingController();

  @override
  CreatePostViewModelState build() {
    return CreatePostViewModelState.initialState();
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

      final List<Future<GalleryEntry>> galleryEntriesFutures = activityData.media?.map((e) async => await Media.toGalleryEntry(media: e)).toList() ?? [];
      final List<GalleryEntry> galleryEntries = await Future.wait(galleryEntriesFutures);

      state = state.copyWith(
        galleryEntries: galleryEntries,
        currentActivityID: activityData.activityID ?? "",
        isEditing: true,
        tags: activityData.tags ?? [],
        allowComments: activityData.allowComments ?? "",
        allowSharing: activityData.allowSharing ?? false,
        visibleTo: activityData.visibleTo ?? "",
        currentCreatePostPage: currentPage,
        currentPostType: currentPostType,
        activeButton: PositivePostNavigationActiveButton.flex,
        activeButtonFlexText: localisations.post_dialogue_update_post,
      );
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
      // Update gallery entries with share flag
      for (final GalleryEntry entry in state.galleryEntries) {
        entry.saveToGallery = state.saveToGallery;
      }

      // Upload gallery entries
      final List<Media> media = await Future.wait(state.galleryEntries.map((e) => e.createMedia()));

      if (!state.isEditing) {
        activity = await activityController.postActivity(
          activityData: ActivityData(
            content: captionController.text.trim(),
            altText: altTextController.text.trim(),
            tags: state.tags,
            postType: state.currentPostType,
            media: media,
            allowComments: state.allowComments,
            allowSharing: state.allowSharing,
            visibleTo: state.visibleTo,
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
            allowComments: state.allowComments,
            allowSharing: state.allowSharing,
            visibleTo: state.visibleTo,
          ),
        );
      }
    } catch (e) {
      logger.e("Error posting activity: $e");

      final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
        title: "Post ${state.isEditing ? "Edit" : "Creation"} Failed",
        icon: UniconsLine.plus_circle,
        backgroundColour: colours.black,
      );

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

    if (router.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
    }

    state = state.copyWith(isBusy: false);

    router.removeWhere((route) => true);
    router.push(const HomeRoute());
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

  void onUpdateSaveToGallery() {
    state = state.copyWith(saveToGallery: !state.saveToGallery);
  }

  void onUpdateAllowSharing() {
    state = state.copyWith(allowSharing: !state.allowSharing);
  }

  void onUpdateVisibleTo(String newValue) {
    state = state.copyWith(visibleTo: newValue);
  }

  void onUpdateAllowComments(String newValue) {
    state = state.copyWith(allowComments: newValue);
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

    state = state.copyWith(
      galleryEntries: entries,
      currentCreatePostPage: CreatePostCurrentPage.createPostImage,
      currentPostType: PostType.image,
      activeButton: PositivePostNavigationActiveButton.flex,
      activeButtonFlexText: localisations.page_create_post_create,
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

      state = state.copyWith(
        isBusy: false,
        galleryEntries: entries,
        currentCreatePostPage: CreatePostCurrentPage.createPostMultiImage,
        currentPostType: PostType.multiImage,
        activeButton: PositivePostNavigationActiveButton.flex,
        activeButtonFlexText: localisations.page_create_post_create,
      );
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }

  Future<bool> onWillPopScope() async {
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    if (state.isEditing) {
      router.removeLast();
    }

    if (state.currentCreatePostPage == CreatePostCurrentPage.camera) {
      logger.i("Pop Create Post page, push Home page");
      router.removeWhere((route) => true);
      router.push(const HomeRoute());
    } else {
      state = state.copyWith(
        currentCreatePostPage: CreatePostCurrentPage.camera,
        currentPostType: PostType.text,
        activeButton: PositivePostNavigationActiveButton.post,
      );
    }
    return false;
  }
}
