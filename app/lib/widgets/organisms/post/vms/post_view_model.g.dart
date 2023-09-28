// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postViewModelHash() => r'ebe66615df5d881b834eda540aca3d4be3704db6';

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

abstract class _$PostViewModel
    extends BuildlessAutoDisposeNotifier<PostViewModelState> {
  late final String activityId;
  late final InvalidType feed;

  PostViewModelState build(
    String activityId,
    InvalidType feed,
  );
}

/// See also [PostViewModel].
@ProviderFor(PostViewModel)
const postViewModelProvider = PostViewModelFamily();

/// See also [PostViewModel].
class PostViewModelFamily extends Family<PostViewModelState> {
  /// See also [PostViewModel].
  const PostViewModelFamily();

  /// See also [PostViewModel].
  PostViewModelProvider call(
    String activityId,
    InvalidType feed,
  ) {
    return PostViewModelProvider(
      activityId,
      feed,
    );
  }

  @override
  PostViewModelProvider getProviderOverride(
    covariant PostViewModelProvider provider,
  ) {
    return call(
      provider.activityId,
      provider.feed,
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
  String? get name => r'postViewModelProvider';
}

/// See also [PostViewModel].
class PostViewModelProvider
    extends AutoDisposeNotifierProviderImpl<PostViewModel, PostViewModelState> {
  /// See also [PostViewModel].
  PostViewModelProvider(
    this.activityId,
    this.feed,
  ) : super.internal(
          () => PostViewModel()
            ..activityId = activityId
            ..feed = feed,
          from: postViewModelProvider,
          name: r'postViewModelProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$postViewModelHash,
          dependencies: PostViewModelFamily._dependencies,
          allTransitiveDependencies:
              PostViewModelFamily._allTransitiveDependencies,
        );

  final String activityId;
  final InvalidType feed;

  @override
  bool operator ==(Object other) {
    return other is PostViewModelProvider &&
        other.activityId == activityId &&
        other.feed == feed;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, activityId.hashCode);
    hash = _SystemHash.combine(hash, feed.hashCode);

    return _SystemHash.finish(hash);
  }

  @override
  PostViewModelState runNotifierBuild(
    covariant PostViewModel notifier,
  ) {
    return notifier.build(
      activityId,
      feed,
    );
  }
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member
