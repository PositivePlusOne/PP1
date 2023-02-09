// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/dtos/user/pledge_model.dart';

part 'pledge_controller.freezed.dart';
part 'pledge_controller.g.dart';

@freezed
class PledgeControllerState with _$PledgeControllerState {
  const factory PledgeControllerState({
    required List<PledgeModel> pledges,
  }) = _PledgeControllerState;

  factory PledgeControllerState.initialState() => const PledgeControllerState(pledges: []);
}

@Riverpod(keepAlive: true)
class AsyncPledgeController extends _$AsyncPledgeController {
  @override
  FutureOr<PledgeControllerState> build() async {
    return PledgeControllerState.initialState();
  }

  //* Calls into Shared Preferences to obtain the user's pledge state.
  Future<void> resetProvider() async {
    state = AsyncValue.data(PledgeControllerState.initialState());
  }

  //* Called when the user toggles a pledge.
  void togglePledge(PledgeModel pledge) {
    final bool canToggle = state.hasValue && state.value!.pledges.contains(pledge);
    if (!canToggle) {
      return;
    }

    final List<PledgeModel> newPledges = state.value!.pledges.map((PledgeModel p) {
      if (p == pledge) {
        return pledge.copyWith(hasAccepted: !pledge.hasAccepted);
      }

      return p;
    }).toList();

    state = AsyncValue.data(state.value!.copyWith(pledges: newPledges));
  }
}
