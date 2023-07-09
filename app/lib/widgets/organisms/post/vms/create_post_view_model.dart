// Dart imports:

// Flutter imports:
import 'package:app/gen/app_router.dart';
import 'package:app/widgets/organisms/post/create_post_dialogue.dart';
import 'package:app/widgets/organisms/post/vms/create_post_enums.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../constants/design_constants.dart';
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
    @Default([]) List<String> imagePaths,
    @Default(null) String videoPath,
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
  List<String> tags = [];
  String visibleTo = "";
  String allowComments = "";

  @override
  CreatePostViewModelState build() {
    return CreatePostViewModelState.initialState();
  }

  void onPostFinished() {
    switch (state.currentPostType) {
      case PostType.text:
        captionController.text;
        tags;
        state.allowSharing;
        visibleTo;
        allowComments;
        break;
      case PostType.repost:
        captionController.text;
        tags;
        altTextController.text;
        state.saveToGallery;
        state.allowSharing;
        visibleTo;
        allowComments;
        break;
      case PostType.image:
        state.imagePaths.first;
        captionController.text;
        tags;
        altTextController.text;
        state.saveToGallery;
        state.allowSharing;
        visibleTo;
        allowComments;
        break;
      case PostType.multiImage:
        state.imagePaths;
        captionController.text;
        tags;
        state.saveToGallery;
        state.allowSharing;
        visibleTo;
        allowComments;
        break;
      case PostType.clip:
        state.videoPath;
        captionController.text;
        tags;
        altTextController.text;
        state.saveToGallery;
        state.allowSharing;
        visibleTo;
        allowComments;
        break;
      // case PostType.event:
      // eventNameController.text;
      // eventDate;
      // eventTime;
      // eventLocation;
      // eventCategory;
      // eventLink;
      // eventPrice;
      // break;
      default:
    }
  }

  void onUpdateTags(List<String> newTags) {
    tags = newTags;
  }

  void onUpdateSaveToGallery(bool newValue) {
    state = state.copyWith(saveToGallery: newValue);
  }

  void onUpdateAllowSharing(bool newValue) {
    state = state.copyWith(allowSharing: newValue);
  }

  void onUpdateVisibleTo(String newValue) {
    visibleTo = newValue;
  }

  void onUpdateAllowComments(String newValue) {
    allowComments = newValue;
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

    state = state.copyWith(
      currentCreatePostPage: CreatePostCurrentPage.createPostImage,
      currentPostType: PostType.image,
      //? Image path here
      imagePaths: [imagePath],
      activeButton: PositivePostNavigationActiveButton.flex,
      activeButtonFlexText: localisations.page_create_post_create,
    );
    return;
  }

  Future<bool> onWillPopScope() async {
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

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
