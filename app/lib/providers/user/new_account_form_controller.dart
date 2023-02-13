import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'new_account_form_controller.freezed.dart';
part 'new_account_form_controller.g.dart';

@freezed
class NewAccountFormState with _$NewAccountFormState {
  const factory NewAccountFormState({
    @Default('') String emailAddress,
    @Default('') String phoneNumber,
    @Default('') String pin,
  }) = _NewAccountFormState;

  factory NewAccountFormState.initialState() => const NewAccountFormState(
        emailAddress: '',
        phoneNumber: '',
        pin: '',
      );
}

@Riverpod(keepAlive: true)
class NewAccountFormController extends _$NewAccountFormController {
  @override
  NewAccountFormState build() {
    return NewAccountFormState.initialState();
  }

  void resetState() {
    state = NewAccountFormState.initialState();
  }
}
