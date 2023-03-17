import 'dart:async';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'profile_interests_view_model.freezed.dart';

part 'profile_interests_view_model.g.dart';

@freezed
class Interest with _$Interest {
  const factory Interest({
    required String id,
    required String label,
  }) = _Interest;
}

@freezed
class ProfileInterestState with _$ProfileInterestState {
  const factory ProfileInterestState({
    @Default(<Interest>[]) List<Interest> options,
    @Default(<Interest>[]) List<Interest> selectedInterests,
  }) = _ProfileInterestState;
}

@riverpod
class ProfileInterestsViewModel extends _$ProfileInterestsViewModel {
  @override
  FutureOr<ProfileInterestState> build() async {
    final List<Interest> interests = await _fetchInterests();
    return ProfileInterestState(options: interests);
  }

  Future<List<Interest>> _fetchInterests() async {
    await Future.delayed(const Duration(seconds: 2));
    return tempData;
  }

  void updateSelectedInterests(Interest interest) {
    if (state.hasValue) {
      final List<Interest> updatedInterests = [...state.value!.selectedInterests];
      if (updatedInterests.contains(interest)) {
        updatedInterests.remove(interest);
      } else {
        updatedInterests.add(interest);
      }
      state = AsyncValue.data(
        state.value!.copyWith(
          selectedInterests: updatedInterests,
        ),
      );
    }
  }
}

const tempData = [
  Interest(label: "Attend Events", id: "Attend Events"),
  Interest(label: "Meet New People", id: "Meet New People"),
  Interest(label: "Get Advice", id: "Get Advice"),
  Interest(label: "Join A Community", id: "Join A Community"),
  Interest(label: "Dating", id: "Dating"),
];
