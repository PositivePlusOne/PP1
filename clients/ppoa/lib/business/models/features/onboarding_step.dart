// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

// Project imports:
import '../../../client/components/atoms/decorations/ppo_scaffold_decoration.dart';
import '../ppo/page_decoration.dart';

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
    @Default('') String title,
    @Default('') String body,
    @Default(<PageDecoration>[]) List<PageDecoration> decorations,
  }) = _OnboardingStep;

  factory OnboardingStep.fromJson(Map<String, Object?> json) => _$OnboardingStepFromJson(json);
}
