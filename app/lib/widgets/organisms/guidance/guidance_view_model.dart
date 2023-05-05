// Package imports:
import 'package:firebase_auth/firebase_auth.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:logger/logger.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

// Project imports:
import '../../../gen/app_router.dart';
import '../../../services/third_party.dart';

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
