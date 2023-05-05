// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:

part 'guidance_view_model.freezed.dart';
part 'guidance_view_model.g.dart';

@freezed
class GuidanceViewModelState with _$GuidanceViewModelState {
  const factory GuidanceViewModelState({
    @Default(false) bool isRefreshing,
  }) = _GuidanceViewModelState;

  factory GuidanceViewModelState.initialState() => const GuidanceViewModelState();
}

@riverpod
class GuidanceViewModel extends _$GuidanceViewModel {
  @override
  GuidanceViewModelState build() {
    return GuidanceViewModelState.initialState();
  }
}
