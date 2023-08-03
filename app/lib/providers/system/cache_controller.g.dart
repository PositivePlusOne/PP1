// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CacheRecord _$$_CacheRecordFromJson(Map<String, dynamic> json) =>
    _$_CacheRecord(
      key: json['key'] as String,
      value: json['value'] as Object,
      createdBy: json['createdBy'] as String,
      lastAccessedBy: json['lastAccessedBy'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastUpdatedAt: DateTime.parse(json['lastUpdatedAt'] as String),
    );

Map<String, dynamic> _$$_CacheRecordToJson(_$_CacheRecord instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'createdBy': instance.createdBy,
      'lastAccessedBy': instance.lastAccessedBy,
      'createdAt': instance.createdAt.toIso8601String(),
      'lastUpdatedAt': instance.lastUpdatedAt.toIso8601String(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cacheControllerHash() => r'834239e2f6dbe26e1672bd451b97010af263b008';

/// See also [CacheController].
@ProviderFor(CacheController)
final cacheControllerProvider =
    NotifierProvider<CacheController, CacheControllerState>.internal(
  CacheController.new,
  name: r'cacheControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cacheControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$CacheController = Notifier<CacheControllerState>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
