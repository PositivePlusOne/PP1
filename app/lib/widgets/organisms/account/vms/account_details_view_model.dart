// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/gen/app_router.dart';
import 'package:app/providers/shared/enumerations/form_mode.dart';
import 'package:app/providers/user/account_form_controller.dart';
import '../../../../services/third_party.dart';

part 'account_details_view_model.freezed.dart';
part 'account_details_view_model.g.dart';

@freezed
class AccountDetailsViewModelState with _$AccountDetailsViewModelState {
  const factory AccountDetailsViewModelState({
    @Default(false) bool isBusy,
  }) = _AccountDetailsViewModelState;

  factory AccountDetailsViewModelState.initialState() => const AccountDetailsViewModelState();
}

@riverpod
class AccountDetailsViewModel extends _$AccountDetailsViewModel {
  @override
  AccountDetailsViewModelState build() {
    return AccountDetailsViewModelState.initialState();
  }

  Future<void> onUpdateEmailAddressButtonPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AccountFormController accountFormController = ref.read(accountFormControllerProvider.notifier);

    logger.d('onUpdateEmailAddressButtonPressed');
    accountFormController.resetState(formMode: FormMode.edit, editTarget: AccountEditTarget.email);
    await appRouter.push(const AccountUpdateEmailAddressRoute());
  }

  Future<void> onUpdatePhoneNumberButtonPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);
    final AccountFormController accountFormController = ref.read(accountFormControllerProvider.notifier);

    logger.d('onUpdatePhoneNumberButtonPressed');
    accountFormController.resetState(formMode: FormMode.edit, editTarget: AccountEditTarget.phone);
    await appRouter.push(const AccountUpdatePhoneNumberRoute());
  }

  Future<void> onGuidanceButtonPressed() async {
    final Logger logger = ref.read(loggerProvider);
    final AppRouter appRouter = ref.read(appRouterProvider);

    logger.d('onGuidanceButtonPressed');
    await appRouter.push(const GuidanceRoute());
  }
}
