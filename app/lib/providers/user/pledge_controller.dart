// Package imports:
import 'package:app/providers/analytics/analytic_events.dart';
import 'package:app/providers/analytics/analytics_controller.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Project imports:
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
    return resetProvider();
  }

  //* Calls into Shared Preferences to obtain the user's pledge state.
  Future<PledgeControllerState> resetProvider() async {
    final SharedPreferences sharedPreferences = await ref.watch(sharedPreferencesProvider.future);
    final bool arePledgesAccepted = sharedPreferences.getBool(kPledgeAcceptedKey) ?? false;
    final PledgeControllerState newState = (state.value ?? PledgeControllerState.initialState()).copyWith(
      arePledgesAccepted: arePledgesAccepted,
    );

    return newState;
  }

  Future<void> notifyPledgesAccepted() async {
    final SharedPreferences sharedPreferences = await ref.read(sharedPreferencesProvider.future);
    final AnalyticsController analyticsController = ref.read(analyticsControllerProvider.notifier);

    await sharedPreferences.setBool(kPledgeAcceptedKey, true);
    await analyticsController.trackEvent(AnalyticEvents.accountPledgesAccepted);

    final PledgeControllerState newState = (state.value ?? PledgeControllerState.initialState()).copyWith(
      arePledgesAccepted: true,
    );

    state = AsyncValue.data(newState);
  }
}
