// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$getHttpsCallableResultHash() =>
    r'6eadcd487d6d09c447c55a24d9523d3393b6809f';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

typedef GetHttpsCallableResultRef
    = AutoDisposeFutureProviderRef<Map<String, Object?>>;

/// See also [getHttpsCallableResult].
@ProviderFor(getHttpsCallableResult)
const getHttpsCallableResultProvider = GetHttpsCallableResultFamily();

/// See also [getHttpsCallableResult].
class GetHttpsCallableResultFamily
    extends Family<AsyncValue<Map<String, Object?>>> {
  /// See also [getHttpsCallableResult].
  const GetHttpsCallableResultFamily();

  /// See also [getHttpsCallableResult].
  GetHttpsCallableResultProvider call({
    required String name,
    Pagination? pagination,
    Map<String, dynamic> parameters = const {},
  }) {
    return GetHttpsCallableResultProvider(
      name: name,
      pagination: pagination,
      parameters: parameters,
    );
  }

  @override
  GetHttpsCallableResultProvider getProviderOverride(
    covariant GetHttpsCallableResultProvider provider,
  ) {
    return call(
      name: provider.name,
      pagination: provider.pagination,
      parameters: provider.parameters,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getHttpsCallableResultProvider';
}

/// See also [getHttpsCallableResult].
class GetHttpsCallableResultProvider
    extends AutoDisposeFutureProvider<Map<String, Object?>> {
  /// See also [getHttpsCallableResult].
  GetHttpsCallableResultProvider({
    required this.name,
    this.pagination,
    this.parameters = const {},
  }) : super.internal(
          (ref) => getHttpsCallableResult(
            ref,
            name: name,
            pagination: pagination,
            parameters: parameters,
          ),
          from: getHttpsCallableResultProvider,
          name: r'getHttpsCallableResultProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getHttpsCallableResultHash,
          dependencies: GetHttpsCallableResultFamily._dependencies,
          allTransitiveDependencies:
              GetHttpsCallableResultFamily._allTransitiveDependencies,
        );

  final String name;
  final Pagination? pagination;
  final Map<String, dynamic> parameters;

  @override
  bool operator ==(Object other) {
    return other is GetHttpsCallableResultProvider &&
        other.name == name &&
        other.pagination == pagination &&
        other.parameters == parameters;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, name.hashCode);
    hash = _SystemHash.combine(hash, pagination.hashCode);
    hash = _SystemHash.combine(hash, parameters.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$getSystemConfigurationHash() =>
    r'05199903308ebadc43743d02613f05dc222e319f';

/// See also [getSystemConfiguration].
@ProviderFor(getSystemConfiguration)
final getSystemConfigurationProvider =
    AutoDisposeFutureProvider<Map<String, Object?>>.internal(
  getSystemConfiguration,
  name: r'getSystemConfigurationProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$getSystemConfigurationHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef GetSystemConfigurationRef
    = AutoDisposeFutureProviderRef<Map<String, Object?>>;
String _$getActivityHash() => r'903211402149371e33f99cfa22fa671e803990be';
typedef GetActivityRef = AutoDisposeFutureProviderRef<Map<String, Object?>>;

/// See also [getActivity].
@ProviderFor(getActivity)
const getActivityProvider = GetActivityFamily();

/// See also [getActivity].
class GetActivityFamily extends Family<AsyncValue<Map<String, Object?>>> {
  /// See also [getActivity].
  const GetActivityFamily();

  /// See also [getActivity].
  GetActivityProvider call({
    required String entryId,
  }) {
    return GetActivityProvider(
      entryId: entryId,
    );
  }

  @override
  GetActivityProvider getProviderOverride(
    covariant GetActivityProvider provider,
  ) {
    return call(
      entryId: provider.entryId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'getActivityProvider';
}

/// See also [getActivity].
class GetActivityProvider
    extends AutoDisposeFutureProvider<Map<String, Object?>> {
  /// See also [getActivity].
  GetActivityProvider({
    required this.entryId,
  }) : super.internal(
          (ref) => getActivity(
            ref,
            entryId: entryId,
          ),
          from: getActivityProvider,
          name: r'getActivityProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$getActivityHash,
          dependencies: GetActivityFamily._dependencies,
          allTransitiveDependencies:
              GetActivityFamily._allTransitiveDependencies,
        );

  final String entryId;

  @override
  bool operator ==(Object other) {
    return other is GetActivityProvider && other.entryId == entryId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entryId.hashCode);

    return _SystemHash.finish(hash);
  }
}

String _$updateFcmTokenHash() => r'bdbd0c8988d983111d74bfa9f4fc9af146a56bf7';
typedef UpdateFcmTokenRef = AutoDisposeFutureProviderRef<Map<String, Object?>>;

/// See also [updateFcmToken].
@ProviderFor(updateFcmToken)
const updateFcmTokenProvider = UpdateFcmTokenFamily();

/// See also [updateFcmToken].
class UpdateFcmTokenFamily extends Family<AsyncValue<Map<String, Object?>>> {
  /// See also [updateFcmToken].
  const UpdateFcmTokenFamily();

  /// See also [updateFcmToken].
  UpdateFcmTokenProvider call({
    required String fcmToken,
  }) {
    return UpdateFcmTokenProvider(
      fcmToken: fcmToken,
    );
  }

  @override
  UpdateFcmTokenProvider getProviderOverride(
    covariant UpdateFcmTokenProvider provider,
  ) {
    return call(
      fcmToken: provider.fcmToken,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'updateFcmTokenProvider';
}

/// See also [updateFcmToken].
class UpdateFcmTokenProvider
    extends AutoDisposeFutureProvider<Map<String, Object?>> {
  /// See also [updateFcmToken].
  UpdateFcmTokenProvider({
    required this.fcmToken,
  }) : super.internal(
          (ref) => updateFcmToken(
            ref,
            fcmToken: fcmToken,
          ),
          from: updateFcmTokenProvider,
          name: r'updateFcmTokenProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$updateFcmTokenHash,
          dependencies: UpdateFcmTokenFamily._dependencies,
          allTransitiveDependencies:
              UpdateFcmTokenFamily._allTransitiveDependencies,
        );

  final String fcmToken;

  @override
  bool operator ==(Object other) {
    return other is UpdateFcmTokenProvider && other.fcmToken == fcmToken;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, fcmToken.hashCode);

    return _SystemHash.finish(hash);
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
