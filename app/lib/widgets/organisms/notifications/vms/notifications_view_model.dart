// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/notifications/notification_payload.dart';
import 'package:app/providers/system/notifications_controller.dart';
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

  Future<void> onNotificationDismissed(NotificationPayload payload) async {
    final Logger logger = ref.read(loggerProvider);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    logger.d('Dismissing notification: ${payload.key}');

    notificationsController.dismissNotification(payload.key);
    logger.d('Notification dismissed');
  }
}
