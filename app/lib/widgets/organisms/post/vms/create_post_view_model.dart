// Dart imports:

// Flutter imports:
import 'package:app/gen/app_router.dart';
import 'package:app/widgets/organisms/post/create_post_dialogue.dart';
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

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
    @Default(null) String? imagePath,
  }) = _CreatePostViewModelState;

  factory CreatePostViewModelState.initialState() => const CreatePostViewModelState();
}

@riverpod
class CreatePostViewModel extends _$CreatePostViewModel {
  @override
  CreatePostViewModelState build() {
    return CreatePostViewModelState.initialState();
  }

  Future<void> onImageTaken(String imagePath) async {
    state = state.copyWith(
      currentCreatePostPage: CreatePostCurrentPage.createPostImage,
      currentPostType: PostType.image,
      imagePath: imagePath,
    );
    return;
  }

  void showCreateTextPost() {
    state = state.copyWith(currentCreatePostPage: CreatePostCurrentPage.createPostText, currentPostType: PostType.text);
  }

  Future<bool> onWillPopScope() async {
    final AppRouter router = ref.read(appRouterProvider);
    final Logger logger = ref.read(loggerProvider);

    if (state.currentCreatePostPage == CreatePostCurrentPage.camera) {
      logger.i("Pop Create Post page, push Home page");
      router.removeWhere((route) => true);
      router.push(const HomeRoute());
    } else {
      state = state.copyWith(currentCreatePostPage: CreatePostCurrentPage.camera, currentPostType: PostType.text);
    }
    return false;
  }
}

enum CreatePostCurrentPage {
  camera,
  createPostText,
  createPostImage,
}
