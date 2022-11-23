// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Environment _$$_EnvironmentFromJson(Map<String, dynamic> json) =>
    _$_Environment(
      type: $enumDecode(_$EnvironmentTypeEnumMap, json['type']),
      onboardingFeatures: (json['onboarding_features'] as List<dynamic>)
          .map((e) => OnboardingFeature.fromJson(e as Map<String, dynamic>))
          .toList(),
      onboardingSteps: (json['onboarding_steps'] as List<dynamic>)
          .map((e) => $enumDecode(_$OnboardingStepEnumMap, e))
          .toList(),
    );

Map<String, dynamic> _$$_EnvironmentToJson(_$_Environment instance) =>
    <String, dynamic>{
      'type': _$EnvironmentTypeEnumMap[instance.type]!,
      'onboarding_features': instance.onboardingFeatures,
      'onboarding_steps': instance.onboardingSteps
          .map((e) => _$OnboardingStepEnumMap[e]!)
          .toList(),
    };

const _$EnvironmentTypeEnumMap = {
  EnvironmentType.develop: 'develop',
  EnvironmentType.staging: 'staging',
  EnvironmentType.production: 'production',
  EnvironmentType.test: 'test',
  EnvironmentType.simulation: 'simulation',
};

const _$OnboardingStepEnumMap = {
  OnboardingStep.welcome: 'welcome',
  OnboardingStep.feature: 'feature',
  OnboardingStep.pledge: 'pledge',
};
