// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/constants/design_constants.dart';
import 'package:app/providers/profiles/profile_controller.dart';
import 'package:app/providers/system/notifications_controller.dart';
import 'package:app/providers/user/mixins/profile_switch_mixin.dart';
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

@Riverpod(keepAlive: true)
class NotificationsViewModel extends _$NotificationsViewModel with LifecycleMixin, ProfileSwitchMixin {
  @override
  NotificationsViewModelState build() {
    return NotificationsViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    prepareProfileSwitcher();
    notifyNotificationsSeen();
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.d('onAccountSelected()');

    await appRouter.push(const AccountRoute());
  }

  Future<void> onProfileSelected(String id) async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    final currentRoute = appRouter.current.name;

    logger.d('onProfileSelected($id)');
    await switchProfileAndAttemptToMarkNotifications(id);

    // Check if we are still on the same route.
    // If so, pop the route as we can assume we are on a dialog.
    if (appRouter.current.name == currentRoute) {
      await appRouter.pop();
    }
  }

  Future<void> notifyNotificationsSeen() async {
    final Logger logger = ref.read(loggerProvider);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);
    final ProfileController profileController = ref.read(profileControllerProvider.notifier);

    if (!profileController.isCurrentlyUserProfile) {
      logger.d('notifyNotificationsSeen() - not current profile');
      return;
    }

    logger.d('notifyNotificationsSeen()');
    await notificationsController.updateNotificationCheckTime();
  }

  Future<void> switchProfileAndAttemptToMarkNotifications(String supportedProfileId) async {
    final Logger logger = ref.read(loggerProvider);
    final NotificationsController notificationsController = ref.read(notificationsControllerProvider.notifier);

    logger.d('switchProfileAndAttemptToMarkNotifications($supportedProfileId)');
    switchProfile(supportedProfileId);

    // Allow time for the window to load.
    Future.delayed(kAnimationDurationFSWait, () async {
      await notificationsController.updateNotificationCheckTime();
    });
  }
}
