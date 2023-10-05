// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'post_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$postViewModelHash() => r'c181ad4dc258dd464c1ddd7a05857876fe94a05a';

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
  late final TargetFeed feed;

  PostViewModelState build(
    String activityId,
    TargetFeed feed,
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
    TargetFeed feed,
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
    String activityId,
    TargetFeed feed,
  ) : this._internal(
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
          activityId: activityId,
          feed: feed,
        );

  PostViewModelProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.activityId,
    required this.feed,
  }) : super.internal();

  final String activityId;
  final TargetFeed feed;

  @override
  PostViewModelState runNotifierBuild(
    covariant PostViewModel notifier,
  ) {
    return notifier.build(
      activityId,
      feed,
    );
  }

  @override
  Override overrideWith(PostViewModel Function() create) {
    return ProviderOverride(
      origin: this,
      override: PostViewModelProvider._internal(
        () => create()
          ..activityId = activityId
          ..feed = feed,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        activityId: activityId,
        feed: feed,
      ),
    );
  }

  @override
  AutoDisposeNotifierProviderElement<PostViewModel, PostViewModelState>
      createElement() {
    return _PostViewModelProviderElement(this);
  }

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
}

mixin PostViewModelRef on AutoDisposeNotifierProviderRef<PostViewModelState> {
  /// The parameter `activityId` of this provider.
  String get activityId;

  /// The parameter `feed` of this provider.
  TargetFeed get feed;
}

class _PostViewModelProviderElement extends AutoDisposeNotifierProviderElement<
    PostViewModel, PostViewModelState> with PostViewModelRef {
  _PostViewModelProviderElement(super.provider);

  @override
  String get activityId => (origin as PostViewModelProvider).activityId;
  @override
  TargetFeed get feed => (origin as PostViewModelProvider).feed;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
