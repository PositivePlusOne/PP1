// Dart imports:

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:

part 'promoted_posts_controller.freezed.dart';
part 'promoted_posts_controller.g.dart';

@freezed
class PromotedPostsControllerState with _$PromotedPostsControllerState {
  const factory PromotedPostsControllerState({
    @Default(false) bool isBusy,
  }) = _PromotedPostsControllerState;

  factory PromotedPostsControllerState.initialState() => const PromotedPostsControllerState();
}

@Riverpod(keepAlive: true)
class PromotedPostsController extends _$PromotedPostsController {
  @override
  PromotedPostsControllerState build() {
    return PromotedPostsControllerState.initialState();
  }
}
