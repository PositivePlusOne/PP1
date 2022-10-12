// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

// Project imports:
import 'package:ppoa/business/state/environment/models/environment.dart';
import 'package:ppoa/business/state/user/models/user.dart';

part 'app_state.freezed.dart';
part 'app_state.g.dart';

class AppStateNotifier extends StateNotifier<AppState> {
  AppStateNotifier({
    required AppState state,
  }) : super(state);
}

@freezed
class AppState with _$AppState {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory AppState({
    required Environment environment,
    required User user,
  }) = _AppState;

  factory AppState.initialState({
    required Environment environment,
    required User user,
  }) =>
      AppState(environment: environment, user: user);

  factory AppState.fromJson(Map<String, Object?> json) => _$AppStateFromJson(json);
}
