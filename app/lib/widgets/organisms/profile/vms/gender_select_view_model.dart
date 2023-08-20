// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/profiles/gender_controller.dart';

// Project imports:
part 'gender_select_view_model.freezed.dart';

part 'gender_select_view_model.g.dart';

@freezed
class GenderSelectState with _$GenderSelectState {
  const GenderSelectState._();
  const factory GenderSelectState({
    String? searchQuery,
    @Default(<GenderOption>[]) List<GenderOption> options,
  }) = _GenderSelectState;
  factory GenderSelectState.initialState(List<GenderOption> options) => GenderSelectState(options: options);
}

@riverpod
class GenderSelectViewModel extends _$GenderSelectViewModel {
  List<GenderOption> allOptions = <GenderOption>[];
  @override
  GenderSelectState build() {
    final genderController = ref.read(genderControllerProvider);
    allOptions = genderController.options;
    return GenderSelectState.initialState(genderController.options);
  }

  void updateSearchQuery(String query) {
    // only update the state if the options have been fetched
    final newState = state.copyWith(
      searchQuery: query,
      options: allOptions.where((option) => option.label.toLowerCase().contains(query.toLowerCase())).toList(),
    );
    state = newState;
  }

  void clearSearchQuery() {
    state = state.copyWith(
      searchQuery: null,
      options: allOptions,
    );
  }
}
