// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiv_status_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_HivStatus _$$_HivStatusFromJson(Map<String, dynamic> json) => _$_HivStatus(
      value: json['value'] as String,
      label: json['label'] as String,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => HivStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$_HivStatusToJson(_$_HivStatus instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'children': instance.children?.map((e) => e.toJson()).toList(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hivStatusControllerHash() =>
    r'7203ffd53b86673e1e25bf54f737bc2566f7d1e3';

/// See also [HivStatusController].
@ProviderFor(HivStatusController)
final hivStatusControllerProvider =
    NotifierProvider<HivStatusController, HivStatusControllerState>.internal(
  HivStatusController.new,
  name: r'hivStatusControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$hivStatusControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$HivStatusController = Notifier<HivStatusControllerState>;
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
