// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'activity_enrichment_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$activityEnrichmentControllerHash() =>
    r'2a83f1914040fc10ef089f801a1f5d057c10a95d';

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

abstract class _$ActivityEnrichmentController
    extends BuildlessNotifier<ActivityEnrichmentControllerState> {
  late final String profileId;

  ActivityEnrichmentControllerState build(
    String profileId,
  );
}

/// See also [ActivityEnrichmentController].
@ProviderFor(ActivityEnrichmentController)
const activityEnrichmentControllerProvider =
    ActivityEnrichmentControllerFamily();

/// See also [ActivityEnrichmentController].
class ActivityEnrichmentControllerFamily
    extends Family<ActivityEnrichmentControllerState> {
  /// See also [ActivityEnrichmentController].
  const ActivityEnrichmentControllerFamily();

  /// See also [ActivityEnrichmentController].
  ActivityEnrichmentControllerProvider call(
    String profileId,
  ) {
    return ActivityEnrichmentControllerProvider(
      profileId,
    );
  }

  @override
  ActivityEnrichmentControllerProvider getProviderOverride(
    covariant ActivityEnrichmentControllerProvider provider,
  ) {
    return call(
      provider.profileId,
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
  String? get name => r'activityEnrichmentControllerProvider';
}

/// See also [ActivityEnrichmentController].
class ActivityEnrichmentControllerProvider extends NotifierProviderImpl<
    ActivityEnrichmentController, ActivityEnrichmentControllerState> {
  /// See also [ActivityEnrichmentController].
  ActivityEnrichmentControllerProvider(
    String profileId,
  ) : this._internal(
          () => ActivityEnrichmentController()..profileId = profileId,
          from: activityEnrichmentControllerProvider,
          name: r'activityEnrichmentControllerProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$activityEnrichmentControllerHash,
          dependencies: ActivityEnrichmentControllerFamily._dependencies,
          allTransitiveDependencies:
              ActivityEnrichmentControllerFamily._allTransitiveDependencies,
          profileId: profileId,
        );

  ActivityEnrichmentControllerProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.profileId,
  }) : super.internal();

  final String profileId;

  @override
  ActivityEnrichmentControllerState runNotifierBuild(
    covariant ActivityEnrichmentController notifier,
  ) {
    return notifier.build(
      profileId,
    );
  }

  @override
  Override overrideWith(ActivityEnrichmentController Function() create) {
    return ProviderOverride(
      origin: this,
      override: ActivityEnrichmentControllerProvider._internal(
        () => create()..profileId = profileId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        profileId: profileId,
      ),
    );
  }

  @override
  NotifierProviderElement<ActivityEnrichmentController,
      ActivityEnrichmentControllerState> createElement() {
    return _ActivityEnrichmentControllerProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is ActivityEnrichmentControllerProvider &&
        other.profileId == profileId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, profileId.hashCode);

    return _SystemHash.finish(hash);
  }
}

mixin ActivityEnrichmentControllerRef
    on NotifierProviderRef<ActivityEnrichmentControllerState> {
  /// The parameter `profileId` of this provider.
  String get profileId;
}

class _ActivityEnrichmentControllerProviderElement
    extends NotifierProviderElement<ActivityEnrichmentController,
        ActivityEnrichmentControllerState>
    with ActivityEnrichmentControllerRef {
  _ActivityEnrichmentControllerProviderElement(super.provider);

  @override
  String get profileId =>
      (origin as ActivityEnrichmentControllerProvider).profileId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member
