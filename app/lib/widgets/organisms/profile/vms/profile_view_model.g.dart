// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileViewModelHash() => r'f8b665cf83135d25066af34d37afdcde73a18df9';

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

abstract class _$ProfileViewModel
    extends BuildlessNotifier<ProfileViewModelState> {
  late final String targetId;

  ProfileViewModelState build(
    String targetId,
  );
}

/// See also [ProfileViewModel].
@ProviderFor(ProfileViewModel)
const profileViewModelProvider = ProfileViewModelFamily();

/// See also [ProfileViewModel].
class ProfileViewModelFamily extends Family<ProfileViewModelState> {
  /// See also [ProfileViewModel].
  const ProfileViewModelFamily();

  /// See also [ProfileViewModel].
  ProfileViewModelProvider call(
    String targetId,
  ) {
    return ProfileViewModelProvider(
      targetId,
    );
  }

  @override
  ProfileViewModelProvider getProviderOverride(
    covariant ProfileViewModelProvider provider,
  ) {
    return call(
      provider.targetId,
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
  String? get name => r'profileViewModelProvider';
}

/// See also [ProfileViewModel].
class ProfileViewModelProvider
    extends NotifierProviderImpl<ProfileViewModel, ProfileViewModelState> {
  /// See also [ProfileViewModel].
  ProfileViewModelProvider(
    String targetId,
  ) : this._internal(
          () => ProfileViewModel()..targetId = targetId,
          from: profileViewModelProvider,
          name: r'profileViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileViewModelHash,
          dependencies: ProfileViewModelFamily._dependencies,
          allTransitiveDependencies:
              ProfileViewModelFamily._allTransitiveDependencies,
          targetId: targetId,
        );

  ProfileViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.targetId,
  }) : super.internal();

  final String targetId;

  @override
  ProfileViewModelState runNotifierBuild(
    covariant ProfileViewModel notifier,
  ) {
    return notifier.build(
      targetId,
    );
  }

  @override
  Override overrideWith(ProfileViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: ProfileViewModelProvider._internal(
        () => create()..targetId = targetId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        targetId: targetId,
      ),
    );
  }

  @override
  NotifierProviderElement<ProfileViewModel, ProfileViewModelState>
      createElement() {
    return _ProfileViewModelProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ProfileViewModelProvider && other.targetId == targetId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, targetId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ProfileViewModelRef on NotifierProviderRef<ProfileViewModelState> {
  /// The parameter `targetId` of this provider.
  String get targetId;
}

class _ProfileViewModelProviderElement
    extends NotifierProviderElement<ProfileViewModel, ProfileViewModelState>
    with ProfileViewModelRef {
  _ProfileViewModelProviderElement(super.provider);

  @override
  String get targetId => (origin as ProfileViewModelProvider).targetId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
