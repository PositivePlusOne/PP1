// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'environment.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Environment _$$_EnvironmentFromJson(Map<String, dynamic> json) =>
    _$_Environment(
      type: $enumDecode(_$EnvironmentTypeEnumMap, json['type']),
      onboardingSteps: (json['onboarding_steps'] as List<dynamic>)
          .map((e) => OnboardingStep.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_EnvironmentToJson(_$_Environment instance) =>
    <String, dynamic>{
      'type': _$EnvironmentTypeEnumMap[instance.type]!,
      'onboarding_steps': instance.onboardingSteps,
    };

const _$EnvironmentTypeEnumMap = {
  EnvironmentType.develop: 'develop',
  EnvironmentType.staging: 'staging',
  EnvironmentType.production: 'production',
  EnvironmentType.test: 'test',
  EnvironmentType.simulation: 'simulation',
};
