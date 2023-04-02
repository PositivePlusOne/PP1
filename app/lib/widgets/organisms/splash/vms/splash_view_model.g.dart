// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

<<<<<<< develop
<<<<<<< develop
<<<<<<< develop
<<<<<<< develop
String _$splashViewModelHash() => r'43ff57958da7925d476d5d91621b936e8838324e';
=======
String _$splashViewModelHash() => r'4e125da05197fe1c9e8d261c483501b1bdc9e624';
>>>>>>> Fix welcome back pages
=======
String _$splashViewModelHash() => r'61d3ef31588b392fb7570e895576e1426f066542';
>>>>>>> Update freezed for conflicts
=======
String _$splashViewModelHash() => r'54e7baaa4f21d8b07dd425167583af5776c43ab1';
>>>>>>> Plug in gender mappers
=======
String _$splashViewModelHash() => r'3b5321fd0491bf12426a5a669fcf36b4d24d8e72';
>>>>>>> Add in basic email and phone change functionality

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
    this.style,
  ) : super.internal(
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
        );

  final SplashStyle style;

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

  @override
  SplashViewModelState runNotifierBuild(
    covariant SplashViewModel notifier,
  ) {
    return notifier.build(
      style,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
