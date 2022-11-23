// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'onboarding_feature.freezed.dart';
part 'onboarding_feature.g.dart';

@freezed
class OnboardingFeature with _$OnboardingFeature {
  @JsonSerializable(
    fieldRename: FieldRename.snake,
  )
  const factory OnboardingFeature({
    required String key,
    required String locale,
    required String localizedMarkdown,
  }) = _OnboardingFeature;

  factory OnboardingFeature.fromJson(Map<String, Object?> json) => _$OnboardingFeatureFromJson(json);
}
