// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$profileViewModelHash() => r'29a26854834cb3a82145f3dad6e083cf149677bf';

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
    extends BuildlessAutoDisposeNotifier<ProfileViewModelState> {
  late final String userId;

  ProfileViewModelState build(
    String userId,
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
    String userId,
  ) {
    return ProfileViewModelProvider(
      userId,
    );
  }

  @override
  ProfileViewModelProvider getProviderOverride(
    covariant ProfileViewModelProvider provider,
  ) {
    return call(
      provider.userId,
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
class ProfileViewModelProvider extends AutoDisposeNotifierProviderImpl<
    ProfileViewModel, ProfileViewModelState> {
  /// See also [ProfileViewModel].
  ProfileViewModelProvider(
    this.userId,
  ) : super.internal(
          () => ProfileViewModel()..userId = userId,
          from: profileViewModelProvider,
          name: r'profileViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$profileViewModelHash,
          dependencies: ProfileViewModelFamily._dependencies,
          allTransitiveDependencies:
              ProfileViewModelFamily._allTransitiveDependencies,
        );

  final String userId;

  @override
  bool operator ==(Object other) {
    return other is ProfileViewModelProvider && other.userId == userId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, userId.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  ProfileViewModelState runNotifierBuild(
    covariant ProfileViewModel notifier,
  ) {
    return notifier.build(
      userId,
    );
  }
}
// ignore_for_file: unnecessary_raw_strings, subtype_of_sealed_class, invalid_use_of_internal_member, do_not_use_environment, prefer_const_constructors, public_member_api_docs, avoid_private_typedef_functions
