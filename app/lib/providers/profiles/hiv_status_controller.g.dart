// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'hiv_status_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$HivStatusImpl _$$HivStatusImplFromJson(Map<String, dynamic> json) =>
    _$HivStatusImpl(
      value: json['value'] as String,
      label: json['label'] as String,
      children: (json['children'] as List<dynamic>?)
          ?.map((e) => HivStatus.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$HivStatusImplToJson(_$HivStatusImpl instance) =>
    <String, dynamic>{
      'value': instance.value,
      'label': instance.label,
      'children': instance.children?.map((e) => e.toJson()).toList(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$hivStatusControllerHash() =>
    r'1d256800caf33de1aef34e8e0eca2389945147f8';

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
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
