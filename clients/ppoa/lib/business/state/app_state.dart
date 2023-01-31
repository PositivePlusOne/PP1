// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:ppoa/business/state/content/content_state.dart';

// Project imports:
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import 'package:ppoa/business/state/environment/models/environment.dart';
import 'package:ppoa/business/state/system/system_state.dart';
import 'package:ppoa/business/state/user/models/user.dart';
import 'design_system/models/design_system_state.dart';

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
    required DesignSystemState designSystem,
    required SystemState systemState,
    required ContentState contentState,
    required Environment environment,
    required User user,
  }) = _AppState;

  factory AppState.initialState({
    required EnvironmentType environmentType,
  }) =>
      AppState(
        environment: Environment.initialState(environmentType: environmentType),
        contentState: ContentState.empty(),
        systemState: SystemState.empty(),
        user: User.empty(),
        designSystem: DesignSystemState.empty(),
      );

  factory AppState.fromJson(Map<String, Object?> json) => _$AppStateFromJson(json);
}
