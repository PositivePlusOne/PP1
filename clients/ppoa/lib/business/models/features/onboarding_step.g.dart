// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_OnboardingStep _$$_OnboardingStepFromJson(Map<String, dynamic> json) =>
    _$_OnboardingStep(
      type: $enumDecode(_$OnboardingStepTypeEnumMap, json['type']),
      key: json['key'] as String,
      markdown: json['markdown'] as String,
    );

Map<String, dynamic> _$$_OnboardingStepToJson(_$_OnboardingStep instance) =>
    <String, dynamic>{
      'type': _$OnboardingStepTypeEnumMap[instance.type]!,
      'key': instance.key,
      'markdown': instance.markdown,
    };

const _$OnboardingStepTypeEnumMap = {
  OnboardingStepType.welcome: 'welcome',
  OnboardingStepType.feature: 'feature',
  OnboardingStepType.ourPledge: 'ourPledge',
  OnboardingStepType.yourPledge: 'yourPledge',
};
