// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$splashControllerHash() => r'67dad39125ca879a2953d123df9b1044ac424f0e';

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

abstract class _$SplashController
    extends BuildlessAutoDisposeNotifier<SplashControllerState> {
  late final SplashStyle style;

  SplashControllerState build(
    SplashStyle style,
  );
}

/// See also [SplashController].
@ProviderFor(SplashController)
const splashControllerProvider = SplashControllerFamily();

/// See also [SplashController].
class SplashControllerFamily extends Family<SplashControllerState> {
  /// See also [SplashController].
  const SplashControllerFamily();

  /// See also [SplashController].
  SplashControllerProvider call(
    SplashStyle style,
  ) {
    return SplashControllerProvider(
      style,
    );
  }

  @override
  SplashControllerProvider getProviderOverride(
    covariant SplashControllerProvider provider,
  ) {
    return call(
      provider.style,
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
  String? get name => r'splashControllerProvider';
}

/// See also [SplashController].
class SplashControllerProvider extends AutoDisposeNotifierProviderImpl<
    SplashController, SplashControllerState> {
  /// See also [SplashController].
  SplashControllerProvider(
    this.style,
  ) : super.internal(
          () => SplashController()..style = style,
          from: splashControllerProvider,
          name: r'splashControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$splashControllerHash,
          dependencies: SplashControllerFamily._dependencies,
          allTransitiveDependencies:
              SplashControllerFamily._allTransitiveDependencies,
        );

  final SplashStyle style;

  @override
  bool operator ==(Object other) {
    return other is SplashControllerProvider && other.style == style;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, style.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  SplashControllerState runNotifierBuild(
    covariant SplashController notifier,
  ) {
    return notifier.build(
      style,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
