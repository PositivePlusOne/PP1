// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import 'package:app/hooks/lifecycle_hook.dart';

// Project imports:

part 'guidance_view_model.freezed.dart';
part 'guidance_view_model.g.dart';

@freezed
class GuidanceViewModelState with _$GuidanceViewModelState {
  const factory GuidanceViewModelState({
    @Default(false) bool isRefreshing,
    @Default('') String entryId,
  }) = _GuidanceViewModelState;

  factory GuidanceViewModelState.fromEntryId(String entryID) => GuidanceViewModelState(entryId: entryID);
}

@riverpod
class GuidanceViewModel extends _$GuidanceViewModel with LifecycleMixin {
  @override
  GuidanceViewModelState build(String entryID) {
    return GuidanceViewModelState.fromEntryId(entryID);
  }

  @override
  void onFirstRender() {
    loadEntry();
    super.onFirstRender();
  }

  Future<void> loadEntry() async {
    // Either load the entry from a cache such as the guidance controller, or call the API to get it and show a loading state
  }
}
