// Dart imports:

// Flutter imports:
import 'package:app/dtos/database/activities/activities.dart';
import 'package:app/extensions/activity_extensions.dart';
import 'package:app/providers/content/tags_controller.dart';
import 'package:app/providers/events/content/activities.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:event_bus/event_bus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Package imports:
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:unicons/unicons.dart';

// Project imports:
import 'package:app/dtos/system/design_colors_model.dart';
import 'package:app/gen/app_router.dart';
import 'package:app/main.dart';
import 'package:app/providers/activities/activities_controller.dart';
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
    // @Default("") String singleImagePath,
    // @Default([]) List<String> multiImagePaths,
    @Default([]) List<String> tags,
    @Default("") String videoPath,
    @Default("") String visibleTo,
    @Default("") String allowComments,
    @Default(PositivePostNavigationActiveButton.post) PositivePostNavigationActiveButton activeButton,
    @Default("") String activeButtonFlexText,
    @Default(false) bool allowSharing,
    @Default(false) bool saveToGallery,
  }) = _CreatePostViewModelState;

  factory CreatePostViewModelState.initialState() => const CreatePostViewModelState();
}

@riverpod
class CreatePostViewModel extends _$CreatePostViewModel {
  final TextEditingController captionController = TextEditingController();
  final TextEditingController altTextController = TextEditingController();

  final List<XFile> multiImageXFiles = [];
  String singleImagePath = "";
  bool isEditMode = false;
  String activityID = "";

  @override
  CreatePostViewModelState build() {
    return CreatePostViewModelState.initialState();
  }

  void loadActivityData(BuildContext context, ActivityData activityData) {
    final AppLocalizations localisations = AppLocalizations.of(context)!;
    switch (activityData.postType) {
      case PostType.text:
        showCreateTextPost(context);
        break;
      case PostType.image:
        //TODO add path from storage
        onImageTaken(context, "");
        break;
      case PostType.multiImage:
        onMultiImagePicker(context);

        break;
      case PostType.event:
      case PostType.clip:
      default:
    }

    captionController.text = activityData.content ?? "";
    // altTextController.text = activityData.altText??"";
    state = state.copyWith(
      tags: activityData.tags ?? [],
      allowComments: activityData.allowComments ?? "",
      allowSharing: activityData.allowSharing ?? false,
      visibleTo: activityData.visibleTo ?? "",
      activeButtonFlexText: localisations.post_dialogue_update_post,
    );

    activityID = activityData.activityID ?? "";
    isEditMode = true;
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

    try {
      state = state.copyWith(isBusy: true);

      if (!isEditMode) {
        activity = await activityController.postActivity(
          activityData: ActivityData(
            content: captionController.text.trim(),
            // altText: altTextController.text.trim(),
            tags: state.tags,
            postType: state.currentPostType,
            // media: ,
            allowComments: state.allowComments,
            allowSharing: state.allowSharing,
            visibleTo: state.visibleTo,
          ),
        );
      } else {
        activity = await activityController.updateActivity(
          activityData: ActivityData(
            activityID: activityID,
            content: captionController.text.trim(),
            // altText: altTextController.text.trim(),
            tags: state.tags,
            postType: state.currentPostType,
            // media: ,
            allowComments: state.allowComments,
            allowSharing: state.allowSharing,
            visibleTo: state.visibleTo,
          ),
        );
      }
    } catch (e) {
      logger.e("Error posting activity: $e");

      final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
        title: "Post ${isEditMode ? "Edit" : "Creation"} Failed",
        icon: UniconsLine.plus_circle,
        backgroundColour: colours.black,
      );

      if (router.navigatorKey.currentContext != null) {
        ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
      }

      state = state.copyWith(isBusy: false);
      return;
    }

    state = state.copyWith(isBusy: false);
    logger.i("Attempted to ${isEditMode ? "edit" : "create"} post, Pop Create Post page, push Home page");

    final PositiveGenericSnackBar snackBar = PositiveGenericSnackBar(
      title: isEditMode ? localisations.page_create_post_edited : localisations.page_create_post_created,
      icon: UniconsLine.plus_circle,
      backgroundColour: colours.black,
    );

    final List<TargetFeed> targets = <TargetFeed>[
      TargetFeed('user', profileController.currentProfileId!),
      TargetFeed('timeline', profileController.currentProfileId!),
      ...activity.tagTargetFeeds,
    ];

    if (isEditMode) {
      eventBus.fire(ActivityUpdatedEvent(targets: targets, activity: activity));
    } else {
      eventBus.fire(ActivityCreatedEvent(targets: targets, activity: activity));
    }

    if (router.navigatorKey.currentContext != null) {
      ScaffoldMessenger.of(router.navigatorKey.currentContext!).showSnackBar(snackBar);
    }

    router.removeWhere((route) => true);
    await router.push(const HomeRoute());
  }

  Future<void> onTagsPressed(BuildContext context) async {
    final TagsController tagsController = ref.read(tagsControllerProvider.notifier);
    List<String> newTags = await showCupertinoDialog(
      context: context,
      builder: (_) => CreatePostTagDialogue(
        allTags: tagsController.byAscendingPopularity.map((e) => e.fallback).where((element) => element.isNotEmpty).toList(),
        currentTags: state.tags,
      ),
    );
    state = state.copyWith(tags: newTags);
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
        if (captionController.text.isNotEmpty) {
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
  Future<void> onImageTaken(BuildContext context, String imagePath) async {
    final AppLocalizations localisations = AppLocalizations.of(context)!;

    singleImagePath = imagePath;

    state = state.copyWith(
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

    logger.d("[ProfilePhotoViewModel] onImagePicker [start]");
    state = state.copyWith(isBusy: true);

    try {
      final List<XFile> images = await picker.pickMultiImage();

      if (images.isEmpty) {
        logger.d("onMultiImagePicker: image list is empty");
        return;
      }

      multiImageXFiles.clear();
      multiImageXFiles.addAll(images);

      state = state.copyWith(
        isBusy: false,
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

    if (isEditMode) {
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
        activeButton: PositivePostNavigationActiveButton.post, //TODO keep this state better
      );
    }
    return false;
  }
}
