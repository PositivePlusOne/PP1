// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'notifications_view_model.freezed.dart';
part 'notifications_view_model.g.dart';

@freezed
class NotificationsViewModelState with _$NotificationsViewModelState {
  const factory NotificationsViewModelState({
    @Default(false) bool isBusy,
  }) = _NotificationsViewModelState;

  factory NotificationsViewModelState.initialState() => const NotificationsViewModelState(
        isBusy: false,
      );
}

@riverpod
class NotificationsViewModel extends _$NotificationsViewModel with LifecycleMixin {
  @override
  NotificationsViewModelState build() {
    return NotificationsViewModelState.initialState();
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.d('onAccountSelected()');

    await appRouter.push(const AccountRoute());
  }
}
