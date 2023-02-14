// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/key_constants.dart';
import '../../services/third_party.dart';

part 'pledge_controller.freezed.dart';
part 'pledge_controller.g.dart';

@freezed
class PledgeControllerState with _$PledgeControllerState {
  const factory PledgeControllerState({
    required bool arePledgesAccepted,
  }) = _PledgeControllerState;

  factory PledgeControllerState.initialState() => const PledgeControllerState(arePledgesAccepted: false);
}

@Riverpod(keepAlive: true)
class AsyncPledgeController extends _$AsyncPledgeController {
  @override
  FutureOr<PledgeControllerState> build() async {
    return PledgeControllerState.initialState();
  }

  //* Calls into Shared Preferences to obtain the user's pledge state.
  Future<void> resetProvider() async {
    final SharedPreferences sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    final bool arePledgesAccepted = sharedPreferences.getBool(kPledgeAcceptedKey) ?? false;
    final PledgeControllerState newState = (state.value ?? PledgeControllerState.initialState()).copyWith(
      arePledgesAccepted: arePledgesAccepted,
    );

    state = AsyncValue.data(newState);
  }

  Future<void> notifyPledgesAccepted() async {
    final SharedPreferences? sharedPreferences = ref.watch(sharedPreferencesProvider).maybeWhen(
          data: (value) => value,
          orElse: () => null,
        );

    if (sharedPreferences == null) {
      return;
    }

    await sharedPreferences.setBool(kPledgeAcceptedKey, true);
    final PledgeControllerState newState = (state.value ?? PledgeControllerState.initialState()).copyWith(
      arePledgesAccepted: true,
    );

    state = AsyncValue.data(newState);
  }
}
