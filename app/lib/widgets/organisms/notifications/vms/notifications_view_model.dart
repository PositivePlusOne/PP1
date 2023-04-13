// Package imports:
import 'package:app/dtos/database/notifications/user_notification.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
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

  Future<void> onNotificationDismissed(UserNotification notification) async {
    final Logger logger = ref.read(loggerProvider);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    logger.d('Dismissing notification: ${notification.key}');

    await notificationsController.dismissNotification(notification.key);
    logger.d('Notification dismissed');
  }

  Future<void> performNotificationAction(Future<void> Function(Ref ref) action, {String? dismissKey}) async {
    final Logger logger = ref.read(loggerProvider);
    logger.d('Performing notification action');

    state = state.copyWith(isBusy: true);

    try {
      await action(ref);
      if (dismissKey != null) {
        final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
        await notificationsController.dismissNotification(dismissKey);
      }
    } catch (ex) {
      logger.e('Error performing notification action', ex);
    } finally {
      state = state.copyWith(isBusy: false);
    }
  }
}
