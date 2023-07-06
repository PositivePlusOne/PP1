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

String _$genderControllerHash() => r'd7c256bd9bc250a00cf4eaec3c75f614cd568069';

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
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
