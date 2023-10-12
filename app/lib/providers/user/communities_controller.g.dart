// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communities_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communitiesControllerHash() =>
    r'f2d58439f12e5fdea4def19a9be6b934f99e6168';

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

abstract class _$CommunitiesController
    extends BuildlessNotifier<CommunitiesControllerState> {
  late final Profile? currentProfile;
  late final User? currentUser;

  CommunitiesControllerState build({
    required Profile? currentProfile,
    required User? currentUser,
  });
}

/// See also [CommunitiesController].
@ProviderFor(CommunitiesController)
const communitiesControllerProvider = CommunitiesControllerFamily();

/// See also [CommunitiesController].
class CommunitiesControllerFamily extends Family<CommunitiesControllerState> {
  /// See also [CommunitiesController].
  const CommunitiesControllerFamily();

  /// See also [CommunitiesController].
  CommunitiesControllerProvider call({
    required Profile? currentProfile,
    required User? currentUser,
  }) {
    return CommunitiesControllerProvider(
      currentProfile: currentProfile,
      currentUser: currentUser,
    );
  }

  @override
  CommunitiesControllerProvider getProviderOverride(
    covariant CommunitiesControllerProvider provider,
  ) {
    return call(
      currentProfile: provider.currentProfile,
      currentUser: provider.currentUser,
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
  String? get name => r'communitiesControllerProvider';
}

/// See also [CommunitiesController].
class CommunitiesControllerProvider extends NotifierProviderImpl<
    CommunitiesController, CommunitiesControllerState> {
  /// See also [CommunitiesController].
  CommunitiesControllerProvider({
    required Profile? currentProfile,
    required User? currentUser,
  }) : this._internal(
          () => CommunitiesController()
            ..currentProfile = currentProfile
            ..currentUser = currentUser,
          from: communitiesControllerProvider,
          name: r'communitiesControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$communitiesControllerHash,
          dependencies: CommunitiesControllerFamily._dependencies,
          allTransitiveDependencies:
              CommunitiesControllerFamily._allTransitiveDependencies,
          currentProfile: currentProfile,
          currentUser: currentUser,
        );

  CommunitiesControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currentProfile,
    required this.currentUser,
  }) : super.internal();

  final Profile? currentProfile;
  final User? currentUser;

  @override
  CommunitiesControllerState runNotifierBuild(
    covariant CommunitiesController notifier,
  ) {
    return notifier.build(
      currentProfile: currentProfile,
      currentUser: currentUser,
    );
  }

  @override
  Override overrideWith(CommunitiesController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommunitiesControllerProvider._internal(
        () => create()
          ..currentProfile = currentProfile
          ..currentUser = currentUser,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currentProfile: currentProfile,
        currentUser: currentUser,
      ),
    );
  }

  @override
  NotifierProviderElement<CommunitiesController, CommunitiesControllerState>
      createElement() {
    return _CommunitiesControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is CommunitiesControllerProvider &&
        other.currentProfile == currentProfile &&
        other.currentUser == currentUser;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currentProfile.hashCode);
    hash = _SystemHash.combine(hash, currentUser.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CommunitiesControllerRef
    on NotifierProviderRef<CommunitiesControllerState> {
  /// The parameter `currentProfile` of this provider.
  Profile? get currentProfile;

  /// The parameter `currentUser` of this provider.
  User? get currentUser;
}

class _CommunitiesControllerProviderElement extends NotifierProviderElement<
    CommunitiesController,
    CommunitiesControllerState> with CommunitiesControllerRef {
  _CommunitiesControllerProviderElement(super.provider);

  @override
  Profile? get currentProfile =>
      (origin as CommunitiesControllerProvider).currentProfile;
  @override
  User? get currentUser =>
      (origin as CommunitiesControllerProvider).currentUser;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
