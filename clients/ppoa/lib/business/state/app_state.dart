// Flutter imports:
import 'package:flutter/foundation.dart';

// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:ppoa/business/environment/models/environment.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

@freezed
class AppState with _$AppState {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory AppState({
    required Environment environment,
  }) = _AppState;

  factory AppState.initialState({
    required Environment environment,
  }) =>
      AppState(environment: environment);

  factory AppState.fromJson(Map<String, Object?> json) => _$AppStateFromJson(json);
}
