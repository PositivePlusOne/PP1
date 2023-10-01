// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cache_controller.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_CacheRecord _$$_CacheRecordFromJson(Map<String, dynamic> json) =>
    _$_CacheRecord(
      key: json['key'] as String,
      value: json['value'] as Object,
      metadata: FlMeta.fromJson(json['metadata'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$_CacheRecordToJson(_$_CacheRecord instance) =>
    <String, dynamic>{
      'key': instance.key,
      'value': instance.value,
      'metadata': instance.metadata.toJson(),
    };

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$cacheControllerHash() => r'be125cb6f5017f7b95aa0919ee1cd6b9c55803b1';

/// See also [cacheController].
@ProviderFor(cacheController)
final cacheControllerProvider = Provider<CacheController>.internal(
  cacheController,
  name: r'cacheControllerProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$cacheControllerHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef CacheControllerRef = ProviderRef<CacheController>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
