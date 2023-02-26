// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/user/user_controller.dart';
import '../../../hooks/lifecycle_hook.dart';

part 'error_controller.freezed.dart';
part 'error_controller.g.dart';

@freezed
class ErrorControllerState with _$ErrorControllerState {
  const factory ErrorControllerState({
    @Default(false) bool isBusy,
  }) = _ErrorControllerState;

  factory ErrorControllerState.initialState() => const ErrorControllerState();
}

@riverpod
class ErrorController extends _$ErrorController with LifecycleMixin {
  @override
  ErrorControllerState build() {
    return ErrorControllerState.initialState();
  }

  Future<void> onContinueSelected() async {
    state = state.copyWith(isBusy: true);

    try {
      final UserController userController = ref.read(userControllerProvider.notifier);
      await userController.signOut();
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
