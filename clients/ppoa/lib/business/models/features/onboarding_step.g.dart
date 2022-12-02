// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'onboarding_step.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_OnboardingStep _$$_OnboardingStepFromJson(Map<String, dynamic> json) =>
    _$_OnboardingStep(
      type: $enumDecode(_$OnboardingStepTypeEnumMap, json['type']),
      title: json['title'] as String? ?? '',
      body: json['body'] as String? ?? '',
      decorations: (json['decorations'] as List<dynamic>?)
              ?.map((e) => PageDecoration.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const <PageDecoration>[],
    );

Map<String, dynamic> _$$_OnboardingStepToJson(_$_OnboardingStep instance) =>
    <String, dynamic>{
      'type': _$OnboardingStepTypeEnumMap[instance.type]!,
      'title': instance.title,
      'body': instance.body,
      'decorations': instance.decorations,
    };

const _$OnboardingStepTypeEnumMap = {
  OnboardingStepType.welcome: 'welcome',
  OnboardingStepType.feature: 'feature',
  OnboardingStepType.ourPledge: 'ourPledge',
  OnboardingStepType.yourPledge: 'yourPledge',
};
