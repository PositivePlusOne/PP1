// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/providers/profiles/company_sectors_controller.dart';

// Project imports:
part 'company_sectors_select_view_model.freezed.dart';

part 'company_sectors_select_view_model.g.dart';

@freezed
class CompanySectorsSelectState with _$CompanySectorsSelectState {
  const CompanySectorsSelectState._();
  const factory CompanySectorsSelectState({
    String? searchQuery,
    @Default(<CompanySectorsOption>[]) List<CompanySectorsOption> options,
  }) = _CompanySectorsSelectState;
  factory CompanySectorsSelectState.initialState(List<CompanySectorsOption> options) => CompanySectorsSelectState(options: options);
}

@riverpod
class CompanySectorSelectViewModel extends _$CompanySectorSelectViewModel {
  List<CompanySectorsOption> allOptions = <CompanySectorsOption>[];
  @override
  CompanySectorsSelectState build() {
    final companySectorsController = ref.read(companySectorsControllerProvider);
    allOptions = companySectorsController.options;
    return CompanySectorsSelectState.initialState(companySectorsController.options);
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
