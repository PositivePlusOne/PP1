// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'gender_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_GenderOption _$$_GenderOptionFromJson(Map<String, dynamic> json) =>
    _$_GenderOption(
      label: json['label'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$$_GenderOptionToJson(_$_GenderOption instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$genderControllerHash() => r'551c2adf4a256ed0d8849832f7079e937b9d0347';

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
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
