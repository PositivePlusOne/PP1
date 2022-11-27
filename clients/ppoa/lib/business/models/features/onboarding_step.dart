// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_step.freezed.dart';
part 'onboarding_step.g.dart';

enum OnboardingStepType {
  welcome,
  feature,
  ourPledge,
  yourPledge,
}

@freezed
class OnboardingStep with _$OnboardingStep {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory OnboardingStep({
    required OnboardingStepType type,
    required String markdown,
  }) = _OnboardingStep;

  factory OnboardingStep.fromJson(Map<String, Object?> json) => _$OnboardingStepFromJson(json);
}
