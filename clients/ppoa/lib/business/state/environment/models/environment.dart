// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';

part 'environment.freezed.dart';
part 'environment.g.dart';

@freezed
class Environment with _$Environment {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory Environment({
    required EnvironmentType type,
  }) = _Environment;

  factory Environment.fromJson(Map<String, Object?> json) => _$EnvironmentFromJson(json);
}
