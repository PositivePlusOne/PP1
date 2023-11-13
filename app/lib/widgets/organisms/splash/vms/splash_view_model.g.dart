// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$splashViewModelHash() => r'fa7e12235474a50b4864910e22c6e51a62d6ae19';

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

abstract class _$SplashViewModel
    extends BuildlessAutoDisposeNotifier<SplashViewModelState> {
  late final SplashStyle style;

  SplashViewModelState build(
    SplashStyle style,
  );
}

/// See also [SplashViewModel].
@ProviderFor(SplashViewModel)
const splashViewModelProvider = SplashViewModelFamily();

/// See also [SplashViewModel].
class SplashViewModelFamily extends Family<SplashViewModelState> {
  /// See also [SplashViewModel].
  const SplashViewModelFamily();

  /// See also [SplashViewModel].
  SplashViewModelProvider call(
    SplashStyle style,
  ) {
    return SplashViewModelProvider(
      style,
    );
  }

  @override
  SplashViewModelProvider getProviderOverride(
    covariant SplashViewModelProvider provider,
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
  String? get name => r'splashViewModelProvider';
}

/// See also [SplashViewModel].
class SplashViewModelProvider extends AutoDisposeNotifierProviderImpl<
    SplashViewModel, SplashViewModelState> {
  /// See also [SplashViewModel].
  SplashViewModelProvider(
    SplashStyle style,
  ) : this._internal(
          () => SplashViewModel()..style = style,
          from: splashViewModelProvider,
          name: r'splashViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$splashViewModelHash,
          dependencies: SplashViewModelFamily._dependencies,
          allTransitiveDependencies:
              SplashViewModelFamily._allTransitiveDependencies,
          style: style,
        );

  SplashViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.style,
  }) : super.internal();

  final SplashStyle style;

  @override
  SplashViewModelState runNotifierBuild(
    covariant SplashViewModel notifier,
  ) {
    return notifier.build(
      style,
    );
  }

  @override
  Override overrideWith(SplashViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: SplashViewModelProvider._internal(
        () => create()..style = style,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        style: style,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<SplashViewModel, SplashViewModelState>
      createElement() {
    return _SplashViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is SplashViewModelProvider && other.style == style;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, style.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin SplashViewModelRef
    on AutoDisposeNotifierProviderRef<SplashViewModelState> {
  /// The parameter `style` of this provider.
  SplashStyle get style;
}

class _SplashViewModelProviderElement
    extends AutoDisposeNotifierProviderElement<SplashViewModel,
        SplashViewModelState> with SplashViewModelRef {
  _SplashViewModelProviderElement(super.provider);

  @override
  SplashStyle get style => (origin as SplashViewModelProvider).style;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
