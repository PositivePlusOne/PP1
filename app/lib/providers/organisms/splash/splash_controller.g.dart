// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'splash_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// ignore_for_file: avoid_private_typedef_functions, non_constant_identifier_names, subtype_of_sealed_class, invalid_use_of_internal_member, unused_element, constant_identifier_names, unnecessary_raw_strings, library_private_types_in_public_api

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

String _$SplashControllerHash() => r'b2ca6dec5d54f5dd7daa8f66ab85a5efee0b2daf';

/// See also [SplashController].
class SplashControllerProvider extends AutoDisposeNotifierProviderImpl<
    SplashController, SplashControllerState> {
  SplashControllerProvider(
    this.style,
  ) : super(
          () => SplashController()..style = style,
          from: splashControllerProvider,
          name: r'splashControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$SplashControllerHash,
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
    covariant _$SplashController notifier,
  ) {
    return notifier.build(
      style,
    );
  }
}

typedef SplashControllerRef
    = AutoDisposeNotifierProviderRef<SplashControllerState>;

/// See also [SplashController].
final splashControllerProvider = SplashControllerFamily();

class SplashControllerFamily extends Family<SplashControllerState> {
  SplashControllerFamily();

  SplashControllerProvider call(
    SplashStyle style,
  ) {
    return SplashControllerProvider(
      style,
    );
  }

  @override
  AutoDisposeNotifierProviderImpl<SplashController, SplashControllerState>
      getProviderOverride(
    covariant SplashControllerProvider provider,
  ) {
    return call(
      provider.style,
    );
  }

  @override
  List<ProviderOrFamily>? get allTransitiveDependencies => null;

  @override
  List<ProviderOrFamily>? get dependencies => null;

  @override
  String? get name => r'splashControllerProvider';
}

abstract class _$SplashController
    extends BuildlessAutoDisposeNotifier<SplashControllerState> {
  late final SplashStyle style;

  SplashControllerState build(
    SplashStyle style,
  );
}
