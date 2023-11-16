// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gender_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$GenderOptionImpl _$$GenderOptionImplFromJson(Map<String, dynamic> json) =>
    _$GenderOptionImpl(
      label: json['label'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$$GenderOptionImplToJson(_$GenderOptionImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genderControllerHash() => r'94209d222dea24a26fdd5c75c78a9680f01c543b';

/// See also [GenderController].
@ProviderFor(GenderController)
final genderControllerProvider =
    NotifierProvider<GenderController, GenderControllerState>.internal(
  GenderController.new,
  name: r'genderControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$genderControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$GenderController = Notifier<GenderControllerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
