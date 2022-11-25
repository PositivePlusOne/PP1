// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import 'package:ppoa/business/models/features/onboarding_feature.dart';
import 'package:ppoa/business/state/environment/enumerations/environment_type.dart';
import '../../../models/features/onboarding_step.dart';

part 'environment.freezed.dart';
part 'environment.g.dart';

@freezed
class Environment with _$Environment {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory Environment({
    required EnvironmentType type,
    required List<OnboardingFeature> onboardingFeatures,
    required List<OnboardingStep> onboardingSteps,
  }) = _Environment;

  factory Environment.initialState({
    required EnvironmentType environmentType,
  }) =>
      Environment(
        type: environmentType,
        onboardingFeatures: const <OnboardingFeature>[],
        onboardingSteps: const <OnboardingStep>[],
      );

  factory Environment.fromJson(Map<String, Object?> json) => _$EnvironmentFromJson(json);
}
