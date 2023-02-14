// Package imports:
import 'package:app/providers/user/new_account_form_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../gen/app_router.dart';
import '../../../hooks/lifecycle_hook.dart';

part 'registration_account_controller.freezed.dart';
part 'registration_account_controller.g.dart';

@freezed
class RegistrationAccountControllerState with _$RegistrationAccountControllerState {
  const factory RegistrationAccountControllerState({
    @Default(false) bool isBusy,
  }) = _RegistrationAccountControllerState;

  factory RegistrationAccountControllerState.initialState() => const RegistrationAccountControllerState(isBusy: false);
}

@riverpod
class RegistrationAccountController extends _$RegistrationAccountController with LifecycleMixin {
  @override
  RegistrationAccountControllerState build() {
    return RegistrationAccountControllerState.initialState();
  }

  Future<void> onLoginWithEmailSelected() async {
    final AppRouter appRouter = ref.read(appRouterProvider);
    final NewAccountFormController newAccountFormController = ref.read(newAccountFormControllerProvider.notifier);

    newAccountFormController.resetState();
    await appRouter.push(const RegistrationEmailEntryRoute());
  }
}
