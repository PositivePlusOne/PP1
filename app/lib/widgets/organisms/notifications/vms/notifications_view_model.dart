// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/database/profile/profile.dart';
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
    @Default('') currentProfileId,
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
  }

  Future<void> onAccountSelected() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    logger.d('onAccountSelected()');

    await appRouter.push(const AccountRoute());
  }

  @override
  String getCurrentProfileId() {
    return state.currentProfileId;
  }

  @override
  void onProfileSwitched(String? id, Profile? profile) {
    final Logger logger = ref.read(loggerProvider);
    logger.d('[NotificationsViewModel.onProfileSwitched] - id: $id, profile: $profile');

    state = state.copyWith(currentProfileId: id ?? '');
  }
}
