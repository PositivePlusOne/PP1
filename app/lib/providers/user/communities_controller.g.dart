// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'communities_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$communitiesControllerHash() =>
    r'cc89d682d7edc68794962b53360403299515634c';

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
  late final String? currentProfileId;
  late final String? currentUserId;
  late final bool isManagedProfile;

  CommunitiesControllerState build({
    required String? currentProfileId,
    required String? currentUserId,
    bool isManagedProfile = false,
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
    required String? currentProfileId,
    required String? currentUserId,
    bool isManagedProfile = false,
  }) {
    return CommunitiesControllerProvider(
      currentProfileId: currentProfileId,
      currentUserId: currentUserId,
      isManagedProfile: isManagedProfile,
    );
  }

  @override
  CommunitiesControllerProvider getProviderOverride(
    covariant CommunitiesControllerProvider provider,
  ) {
    return call(
      currentProfileId: provider.currentProfileId,
      currentUserId: provider.currentUserId,
      isManagedProfile: provider.isManagedProfile,
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
    required String? currentProfileId,
    required String? currentUserId,
    bool isManagedProfile = false,
  }) : this._internal(
          () => CommunitiesController()
            ..currentProfileId = currentProfileId
            ..currentUserId = currentUserId
            ..isManagedProfile = isManagedProfile,
          from: communitiesControllerProvider,
          name: r'communitiesControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$communitiesControllerHash,
          dependencies: CommunitiesControllerFamily._dependencies,
          allTransitiveDependencies:
              CommunitiesControllerFamily._allTransitiveDependencies,
          currentProfileId: currentProfileId,
          currentUserId: currentUserId,
          isManagedProfile: isManagedProfile,
        );

  CommunitiesControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.currentProfileId,
    required this.currentUserId,
    required this.isManagedProfile,
  }) : super.internal();

  final String? currentProfileId;
  final String? currentUserId;
  final bool isManagedProfile;

  @override
  CommunitiesControllerState runNotifierBuild(
    covariant CommunitiesController notifier,
  ) {
    return notifier.build(
      currentProfileId: currentProfileId,
      currentUserId: currentUserId,
      isManagedProfile: isManagedProfile,
    );
  }

  @override
  Override overrideWith(CommunitiesController Function() create) {
    return ProviderOverride(
      origin: this,
      override: CommunitiesControllerProvider._internal(
        () => create()
          ..currentProfileId = currentProfileId
          ..currentUserId = currentUserId
          ..isManagedProfile = isManagedProfile,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        currentProfileId: currentProfileId,
        currentUserId: currentUserId,
        isManagedProfile: isManagedProfile,
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
        other.currentProfileId == currentProfileId &&
        other.currentUserId == currentUserId &&
        other.isManagedProfile == isManagedProfile;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, currentProfileId.hashCode);
    hash = _SystemHash.combine(hash, currentUserId.hashCode);
    hash = _SystemHash.combine(hash, isManagedProfile.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin CommunitiesControllerRef
    on NotifierProviderRef<CommunitiesControllerState> {
  /// The parameter `currentProfileId` of this provider.
  String? get currentProfileId;

  /// The parameter `currentUserId` of this provider.
  String? get currentUserId;

  /// The parameter `isManagedProfile` of this provider.
  bool get isManagedProfile;
}

class _CommunitiesControllerProviderElement extends NotifierProviderElement<
    CommunitiesController,
    CommunitiesControllerState> with CommunitiesControllerRef {
  _CommunitiesControllerProviderElement(super.provider);

  @override
  String? get currentProfileId =>
      (origin as CommunitiesControllerProvider).currentProfileId;
  @override
  String? get currentUserId =>
      (origin as CommunitiesControllerProvider).currentUserId;
  @override
  bool get isManagedProfile =>
      (origin as CommunitiesControllerProvider).isManagedProfile;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
