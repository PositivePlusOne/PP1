// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'company_sectors_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CompanySectorsOptionImpl _$$CompanySectorsOptionImplFromJson(
        Map<String, dynamic> json) =>
    _$CompanySectorsOptionImpl(
      label: json['label'] as String,
      value: json['value'] as String,
    );

Map<String, dynamic> _$$CompanySectorsOptionImplToJson(
        _$CompanySectorsOptionImpl instance) =>
    <String, dynamic>{
      'label': instance.label,
      'value': instance.value,
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$companySectorsControllerHash() =>
    r'ebe5bea9769430b6ab2b80970545ef86e1943035';

/// See also [CompanySectorsController].
@ProviderFor(CompanySectorsController)
final companySectorsControllerProvider = NotifierProvider<
    CompanySectorsController, CompanySectorsControllerState>.internal(
  CompanySectorsController.new,
  name: r'companySectorsControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$companySectorsControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CompanySectorsController = Notifier<CompanySectorsControllerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
