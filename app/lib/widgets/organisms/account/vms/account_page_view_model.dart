// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/user/mixins/profile_switch_mixin.dart';
import '../../../../gen/app_router.dart';
import '../../../../hooks/lifecycle_hook.dart';
import '../../../../services/third_party.dart';

part 'account_page_view_model.freezed.dart';
part 'account_page_view_model.g.dart';

@freezed
class AccountPageViewModelState with _$AccountPageViewModelState {
  const factory AccountPageViewModelState({
    @Default(false) bool isBusy,
  }) = _AccountPageViewModelState;

  factory AccountPageViewModelState.initialState() => const AccountPageViewModelState(
        isBusy: false,
      );
}

@Riverpod(keepAlive: true)
class AccountPageViewModel extends _$AccountPageViewModel with LifecycleMixin, ProfileSwitchMixin {
  @override
  AccountPageViewModelState build() {
    return AccountPageViewModelState.initialState();
  }

  @override
  void onFirstRender() {
    super.onFirstRender();
    prepareProfileSwitcher();
  }
    final AppRouter appRouter = ref.read(appRouterProvider);
}
