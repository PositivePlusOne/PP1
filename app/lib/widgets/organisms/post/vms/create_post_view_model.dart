// Dart imports:

// Flutter imports:
import 'package:app/widgets/organisms/post/create_post_dialogue.dart';
import 'package:flutter/cupertino.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:

part 'create_post_view_model.freezed.dart';
part 'create_post_view_model.g.dart';

@freezed
class CreatePostViewModelState with _$CreatePostViewModelState {
  const factory CreatePostViewModelState({
    @Default(false) bool isBusy,
  }) = _CreatePostViewModelState;

  factory CreatePostViewModelState.initialState() => const CreatePostViewModelState();
}

@riverpod
class CreatePostViewModel extends _$CreatePostViewModel {
  @override
  CreatePostViewModelState build() {
    return CreatePostViewModelState.initialState();
  }

  Future<void> showCreatePostDialogue(BuildContext context) async {
    final dynamic result = await showCupertinoDialog(
      context: context,
      builder: (_) {
        return const CreatePostDialog();
      },
    );
  }
}
