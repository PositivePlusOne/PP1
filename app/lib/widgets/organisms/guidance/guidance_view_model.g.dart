// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'guidance_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$guidanceViewModelHash() => r'2744353457b713e1fe8882b337742fbbe3335c90';

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

abstract class _$GuidanceViewModel
    extends BuildlessAutoDisposeNotifier<GuidanceViewModelState> {
  late final String entryID;

  GuidanceViewModelState build(
    String entryID,
  );
}

/// See also [GuidanceViewModel].
@ProviderFor(GuidanceViewModel)
const guidanceViewModelProvider = GuidanceViewModelFamily();

/// See also [GuidanceViewModel].
class GuidanceViewModelFamily extends Family<GuidanceViewModelState> {
  /// See also [GuidanceViewModel].
  const GuidanceViewModelFamily();

  /// See also [GuidanceViewModel].
  GuidanceViewModelProvider call(
    String entryID,
  ) {
    return GuidanceViewModelProvider(
      entryID,
    );
  }

  @override
  GuidanceViewModelProvider getProviderOverride(
    covariant GuidanceViewModelProvider provider,
  ) {
    return call(
      provider.entryID,
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
  String? get name => r'guidanceViewModelProvider';
}

/// See also [GuidanceViewModel].
class GuidanceViewModelProvider extends AutoDisposeNotifierProviderImpl<
    GuidanceViewModel, GuidanceViewModelState> {
  /// See also [GuidanceViewModel].
  GuidanceViewModelProvider(
    this.entryID,
  ) : super.internal(
          () => GuidanceViewModel()..entryID = entryID,
          from: guidanceViewModelProvider,
          name: r'guidanceViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$guidanceViewModelHash,
          dependencies: GuidanceViewModelFamily._dependencies,
          allTransitiveDependencies:
              GuidanceViewModelFamily._allTransitiveDependencies,
        );

  final String entryID;

  @override
  bool operator ==(Object other) {
    return other is GuidanceViewModelProvider && other.entryID == entryID;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entryID.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  GuidanceViewModelState runNotifierBuild(
    covariant GuidanceViewModel notifier,
  ) {
    return notifier.build(
      entryID,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
